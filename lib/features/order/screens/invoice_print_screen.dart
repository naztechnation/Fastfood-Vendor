import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as i;
import 'package:sixam_mart_store/features/order/widgets/invoice_dialog_widget.dart';
import 'package:sixam_mart_store/features/order/domain/models/bluetooth_printer_body_model.dart';
import 'package:sixam_mart_store/features/order/domain/models/order_details_model.dart';
import 'package:sixam_mart_store/features/order/domain/models/order_model.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class InVoicePrintScreen extends StatefulWidget {
  final OrderModel? order;
  final List<OrderDetailsModel>? orderDetails;
  final bool? isPrescriptionOrder;
  final double dmTips;
  const InVoicePrintScreen({super.key, required this.order, required this.orderDetails, this.isPrescriptionOrder = false, required this.dmTips});

  @override
  State<InVoicePrintScreen> createState() => _InVoicePrintScreenState();
}

class _InVoicePrintScreenState extends State<InVoicePrintScreen> {
  PrinterType _defaultPrinterType = PrinterType.bluetooth;
  final bool _isBle = GetPlatform.isIOS;
  final PrinterManager _printerManager = PrinterManager.instance;
  final List<BluetoothPrinterModel> _devices = <BluetoothPrinterModel>[];
  StreamSubscription<PrinterDevice>? _subscription;
  StreamSubscription<BTStatus>? _subscriptionBtStatus;
  BTStatus currentStatus = BTStatus.none;
  List<int>? pendingTask;
  String _ipAddress = '';
  String _port = '9100';
  bool _paper80MM = true;
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _portController = TextEditingController();
  BluetoothPrinterModel? _selectedPrinter;
  bool _searchingMode = true;

  @override
  void initState() {
    if (Platform.isWindows) _defaultPrinterType = PrinterType.usb;
    super.initState();
    _portController.text = _port;
    _scan();

    /// subscription to listen change status of bluetooth connection
    _subscriptionBtStatus = PrinterManager.instance.stateBluetooth.listen((status) {
      log(' ------ status bt $status ---------- ');
      currentStatus = status;

      if (status == BTStatus.connected && pendingTask != null) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          PrinterManager.instance.send(type: PrinterType.bluetooth, bytes: pendingTask!);
          pendingTask = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _subscriptionBtStatus?.cancel();
    _portController.dispose();
    _ipController.dispose();
    super.dispose();
  }

  /// method to scan devices according PrinterType
  void _scan() {
    _devices.clear();
    _subscription = _printerManager.discovery(type: _defaultPrinterType, isBle: _isBle).listen((device) {
      _devices.add(BluetoothPrinterModel(
        deviceName: device.name,
        address: device.address,
        isBle: _isBle,
        vendorId: device.vendorId,
        productId: device.productId,
        typePrinter: _defaultPrinterType,
      ));
      setState(() {});
    });
  }

  void _setPort(String value) {
    if (value.isEmpty) value = '9100';
    _port = value;
    var device = BluetoothPrinterModel(
      deviceName: value,
      address: _ipAddress,
      port: _port,
      typePrinter: PrinterType.network,
      state: false,
    );
    _selectDevice(device);
  }

  void _setIpAddress(String value) {
    _ipAddress = value;
    BluetoothPrinterModel device = BluetoothPrinterModel(
      deviceName: value,
      address: _ipAddress,
      port: _port,
      typePrinter: PrinterType.network,
      state: false,
    );
    _selectDevice(device);
  }

  void _selectDevice(BluetoothPrinterModel device) async {
    if (_selectedPrinter != null) {
      if ((device.address != _selectedPrinter!.address) || (device.typePrinter == PrinterType.usb && _selectedPrinter!.vendorId != device.vendorId)) {
        await PrinterManager.instance.disconnect(type: _selectedPrinter!.typePrinter);
      }
    }

    _selectedPrinter = device;
    setState(() {});
  }

  Future _printReceipt(i.Image image) async {
    i.Image resized = i.copyResize(image, width: _paper80MM ? 500 : 365);
    CapabilityProfile profile = await CapabilityProfile.load();
    Generator generator = Generator(_paper80MM ? PaperSize.mm80 : PaperSize.mm58, profile);
    List<int> bytes = [];
    bytes += generator.image(resized);
    _printEscPos(bytes, generator);
  }

  /// print ticket
  void _printEscPos(List<int> bytes, Generator generator) async {
    if (_selectedPrinter == null) return;
    var bluetoothPrinter = _selectedPrinter!;

    switch (bluetoothPrinter.typePrinter) {
      case PrinterType.usb:
        bytes += generator.feed(2);
        bytes += generator.cut();
        await _printerManager.connect(
          type: bluetoothPrinter.typePrinter,
          model: UsbPrinterInput(
            name: bluetoothPrinter.deviceName,
            productId: bluetoothPrinter.productId,
            vendorId: bluetoothPrinter.vendorId,
          ),
        );
        break;
      case PrinterType.bluetooth:
        bytes += generator.cut();
        await _printerManager.connect(
          type: bluetoothPrinter.typePrinter,
          model: BluetoothPrinterInput(
            name: bluetoothPrinter.deviceName,
            address: bluetoothPrinter.address!,
            isBle: bluetoothPrinter.isBle,
          ),
        );
        pendingTask = null;
        if (Platform.isIOS || Platform.isAndroid) pendingTask = bytes;
        break;
      case PrinterType.network:
        bytes += generator.feed(2);
        bytes += generator.cut();
        await _printerManager.connect(
          type: bluetoothPrinter.typePrinter,
          model: TcpPrinterInput(ipAddress: bluetoothPrinter.address!),
        );
        break;
      default:
    }
    if (bluetoothPrinter.typePrinter == PrinterType.bluetooth) {
      try{
        Future.delayed(Duration(seconds: GetPlatform.isIOS ? 2 : 1), () {
          _printerManager.send(type: bluetoothPrinter.typePrinter, bytes: bytes);
          pendingTask = null;
        });
      }catch(_) {}
    } else {
      _printerManager.send(type: bluetoothPrinter.typePrinter, bytes: bytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _searchingMode ? SingleChildScrollView(
      padding: const EdgeInsets.all(Dimensions.fontSizeLarge),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Text('paper_size'.tr, style: robotoMedium),
          Row(children: [
            Expanded(child: RadioListTile(
              title: Text('80_mm'.tr),
              groupValue: _paper80MM,
              dense: true,
              contentPadding: EdgeInsets.zero,
              value: true,
              onChanged: (bool? value) {
                _paper80MM = true;
                setState(() {});
              },
            )),
            Expanded(child: RadioListTile(
              title: Text('58_mm'.tr),
              groupValue: _paper80MM,
              contentPadding: EdgeInsets.zero,
              dense: true,
              value: false,
              onChanged: (bool? value) {
                _paper80MM = false;
                setState(() {});
              },
            )),
          ]),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          ListView.builder(
            itemCount: _devices.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                child: InkWell(
                  onTap: () {
                    _selectDevice(_devices[index]);
                    setState(() {
                      _searchingMode = false;
                    });
                  },
                  child: Stack(children: [

                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      Text('${_devices[index].deviceName}'),

                      Platform.isAndroid && _defaultPrinterType == PrinterType.usb ? const SizedBox() : Visibility(
                        visible: !Platform.isWindows,
                        child: Text("${_devices[index].address}"),
                      ),

                      index != _devices.length-1 ? Divider(color: Theme.of(context).disabledColor) : const SizedBox(),

                    ]),

                    (_selectedPrinter != null && ((_devices[index].typePrinter == PrinterType.usb && Platform.isWindows
                        ? _devices[index].deviceName == _selectedPrinter!.deviceName
                        : _devices[index].vendorId != null && _selectedPrinter!.vendorId == _devices[index].vendorId) ||
                        (_devices[index].address != null && _selectedPrinter!.address == _devices[index].address))) ? const Positioned(
                      top: 5, right: 5,
                      child: Icon(Icons.check, color: Colors.green),
                    ) : const SizedBox(),

                  ]),
                ),
              );
            },
          ),
          Visibility(
            visible: _defaultPrinterType == PrinterType.network && Platform.isWindows,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: TextFormField(
                controller: _ipController,
                keyboardType: const TextInputType.numberWithOptions(signed: true),
                decoration: InputDecoration(
                  label: Text('ip_address'.tr),
                  prefixIcon: const Icon(Icons.wifi, size: 24),
                ),
                onChanged: _setIpAddress,
              ),
            ),
          ),
          Visibility(
            visible: _defaultPrinterType == PrinterType.network && Platform.isWindows,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: TextFormField(
                controller: _portController,
                keyboardType: const TextInputType.numberWithOptions(signed: true),
                decoration: InputDecoration(
                  label: Text('port'.tr),
                  prefixIcon: const Icon(Icons.numbers_outlined, size: 24),
                ),
                onChanged: _setPort,
              ),
            ),
          ),
          Visibility(
            visible: _defaultPrinterType == PrinterType.network && Platform.isWindows,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: OutlinedButton(
                onPressed: () async {
                  if (_ipController.text.isNotEmpty) _setIpAddress(_ipController.text);
                  setState(() {
                    _searchingMode = false;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 50),
                  child: Text("print_ticket".tr, textAlign: TextAlign.center),
                ),
              ),
            ),
          )
        ],
      ),
    ) : InvoiceDialog(
      order: widget.order, orderDetails: widget.orderDetails, isPrescriptionOrder: widget.isPrescriptionOrder,
      onPrint: (i.Image? image) => _printReceipt(image!), paper80MM: _paper80MM, dmTips: widget.dmTips,
    );
  }
}