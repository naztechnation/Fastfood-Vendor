import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sixam_mart_store/features/address/controllers/address_controller.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_dropdown_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/address/widgets/location_search_dialog_widget.dart';
import 'package:sixam_mart_store/features/address/widgets/module_view_widget.dart';

class SelectLocationAndModuleViewWidget extends StatefulWidget {
  final bool fromView;
  final GoogleMapController? mapController;
  const SelectLocationAndModuleViewWidget({super.key, required this.fromView, this.mapController});

  @override
  State<SelectLocationAndModuleViewWidget> createState() => _SelectLocationAndModuleViewWidgetState();
}

class _SelectLocationAndModuleViewWidgetState extends State<SelectLocationAndModuleViewWidget> {

  late CameraPosition _cameraPosition;
  final Set<Polygon> _polygons = HashSet<Polygon>();
  GoogleMapController? _mapController;
  GoogleMapController? _screenMapController;

  @override
  void initState() {
    super.initState();
    if(Get.find<AddressController>().zoneList != null) {
      Get.find<AddressController>().getZoneList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddressController>(builder: (addressController) {

      List<int> zoneIndexList = [];
      List<DropdownItem<int>> zoneList = [];
      if(addressController.zoneList != null && addressController.zoneIds != null) {
        for(int index = 0; index < addressController.zoneList!.length; index++) {
          zoneIndexList.add(index);
          zoneList.add(DropdownItem<int>(value: index, child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('${addressController.zoneList![index].name}'),
            ),
          )));
        }
      }

      return SizedBox(child: Padding(
        padding: EdgeInsets.all(widget.fromView ? 0 : Dimensions.paddingSizeSmall),
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            Row(children: [
              Expanded(child: zoneSection(addressController, zoneList)),
              SizedBox(width: addressController.moduleList != null ? Dimensions.paddingSizeSmall : 0),

              const Expanded(child: ModuleViewWidget()),

            ]),
            const SizedBox(height: Dimensions.paddingSizeExtraLarge),

            mapView(addressController),
            SizedBox(height: !widget.fromView ? Dimensions.paddingSizeSmall : 0),

            !widget.fromView ? CustomButtonWidget(
              buttonText: 'set_location'.tr,
              onPressed: () async {
                try{
                  await widget.mapController!.moveCamera(CameraUpdate.newCameraPosition(_cameraPosition));
                  Get.back();
                }catch(e){
                  showCustomSnackBar('please_setup_the_marker_in_your_required_location'.tr);
                }
              },
            ) : const SizedBox()

          ]),
        ),
      ));
    });
  }

  Widget zoneSection(AddressController addressController, List<DropdownItem<int>> zoneList) {
    return zoneList.isNotEmpty ? Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          color: Theme.of(context).cardColor,
          border: Border.all(color: Theme.of(context).primaryColor, width: 0.3)
      ),
      child: CustomDropdown<int>(
        onChange: (int? value, int index) {
          addressController.setZoneIndex(value);
        },
        dropdownButtonStyle: DropdownButtonStyle(
          height: 45,
          padding: const EdgeInsets.symmetric(
            vertical: Dimensions.paddingSizeExtraSmall,
            horizontal: Dimensions.paddingSizeExtraSmall,
          ),
          primaryColor: Theme.of(context).textTheme.bodyLarge!.color,
        ),
        dropdownStyle: DropdownStyle(
          elevation: 10,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
        ),
        items: zoneList,
        child: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text('${addressController.zoneList![addressController.selectedZoneIndex!].name}'),
        ),
      ),
    ) : Center(child: Text('service_not_available_in_this_area'.tr));
  }

  Widget mapView(AddressController addressController) {
    return addressController.zoneList!.isNotEmpty ? Container(
      height: widget.fromView ? 125 : (context.height * 0.55),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        border: Border.all(width: 1, color: Theme.of(context).primaryColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        child: Stack(clipBehavior: Clip.none, children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lat ?? '0'),
                double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lng ?? '0'),
              ), zoom: 16,
            ),
            minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
            zoomControlsEnabled: false,
            compassEnabled: false,
            indoorViewEnabled: true,
            mapToolbarEnabled: false,
            myLocationEnabled: false,
            zoomGesturesEnabled: true,
            polygons: _polygons,
            onCameraIdle: () {
              addressController.setLocation(_cameraPosition.target);
              if(!widget.fromView) {
                widget.mapController!.moveCamera(CameraUpdate.newCameraPosition(_cameraPosition));
              }
            },
            onCameraMove: ((position) => _cameraPosition = position),
            onMapCreated: (GoogleMapController controller) {
              addressController.setLocation(LatLng(
                double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lat ?? '0'),
                double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lng ?? '0'),
              ));
              if(widget.fromView) {
                _mapController = controller;
              }else {
                _screenMapController = controller;
              }
            },
          ),
          Center(child: Image.asset(Images.pickMarker, height: 50, width: 50)),

          widget.fromView ? Positioned(top: 10, left: 10,
            child: InkWell(
              onTap: () async {
                var p = await Get.dialog(LocationSearchDialogWidget(mapController: widget.fromView ? _mapController : _screenMapController));
                Position? position = p;
                if(position != null) {
                  _cameraPosition = CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 16);
                  if(!widget.fromView) {
                    widget.mapController!.moveCamera(CameraUpdate.newCameraPosition(_cameraPosition));
                    addressController.setLocation(_cameraPosition.target);
                  }
                }
              },
              child: Container(
                height: 30, width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  color: Theme.of(context).cardColor,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2)],
                ),
                padding: const EdgeInsets.only(left: 10),
                alignment: Alignment.centerLeft,
                child: Text('search'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
              ),
            ),
          ) : const SizedBox(),

          widget.fromView ? Positioned(
            top: 10, right: 0,
            child: InkWell(
              onTap: () {
                Get.to(Scaffold(
                    appBar: CustomAppBarWidget(title: 'set_your_store_location'.tr),
                    body: SelectLocationAndModuleViewWidget(fromView: false, mapController: _mapController)),
                );
              },
              child: Container(
                width: 30, height: 30,
                margin: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Colors.white),
                child: Icon(Icons.fullscreen, color: Theme.of(context).primaryColor, size: 20),
              ),
            ),
          ) : const SizedBox(),
        ]),
      ),
    ) : const SizedBox();
  }
}
