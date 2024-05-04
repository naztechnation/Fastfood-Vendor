import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sixam_mart_store/features/address/domain/models/address_model.dart';
import 'package:sixam_mart_store/features/auth/domain/models/module_model.dart';
import 'package:sixam_mart_store/features/address/domain/models/place_details_model.dart';
import 'package:sixam_mart_store/features/address/domain/models/prediction_model.dart';
import 'package:sixam_mart_store/features/address/domain/models/zone_model.dart';
import 'package:sixam_mart_store/features/address/domain/models/zone_response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/features/address/domain/services/address_service_interface.dart';

class AddressController extends GetxController implements GetxService {
  final AddressServiceInterface addressServiceInterface;
  AddressController({required this.addressServiceInterface});

  int? _selectedZoneIndex = -1;
  int? get selectedZoneIndex => _selectedZoneIndex;

  List<ZoneModel>? _zoneList;
  List<ZoneModel>? get zoneList => _zoneList;

  List<int>? _zoneIds;
  List<int>? get zoneIds => _zoneIds;

  LatLng? _restaurantLocation;
  LatLng? get restaurantLocation => _restaurantLocation;

  String? _storeAddress;
  String? get storeAddress => _storeAddress;

  List<ModuleModel>? _moduleList;
  List<ModuleModel>? get moduleList => _moduleList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<PredictionModel> _predictionList = [];
  List<PredictionModel> get predictionList => _predictionList;

  Position _pickPosition = Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1, altitudeAccuracy: 1, headingAccuracy: 1);
  Position get pickPosition => _pickPosition;

  String? _pickAddress = '';
  String? get pickAddress => _pickAddress;

  bool _loading = false;
  bool get loading => _loading;

  bool _inZone = false;
  bool get inZone => _inZone;

  int _zoneID = 0;
  int get zoneID => _zoneID;

  int? _selectedModuleIndex = -1;
  int? get selectedModuleIndex => _selectedModuleIndex;

  Future<void> getZoneList() async {
    _selectedZoneIndex = 0;
    _restaurantLocation = null;
    _zoneIds = null;
    List<ZoneModel>? zoneList = await addressServiceInterface.getZoneList();
    if (zoneList != null) {
      _zoneList = [];
      _zoneList!.addAll(zoneList);
      await getModules(_zoneList![0].id);
    }
    update();
  }

  Future<void> setZoneIndex(int? index) async {
    _selectedZoneIndex = index;
    _moduleList = null;
    _selectedModuleIndex = -1;
    update();
    await getModules(zoneList![selectedZoneIndex!].id);
    update();
  }

  Future<void> getModules(int? zoneId) async {
    List<ModuleModel>? moduleList = await addressServiceInterface.getModules(zoneId);
    if (moduleList != null) {
      _moduleList = [];
      _moduleList!.addAll(moduleList);
    }
    update();
  }

  void selectModuleIndex(int? index) {
    _selectedModuleIndex = index;
    update();
  }

  void setLocation(LatLng location) async{
    ZoneResponseModel response = await getZone(
      location.latitude.toString(), location.longitude.toString(), false,
    );
    _storeAddress = await _getAddressFromGeocode(LatLng(location.latitude, location.longitude));
    _restaurantLocation = addressServiceInterface.setRestaurantLocation(response, location);
    _zoneIds = addressServiceInterface.setZoneIds(response);
    _selectedZoneIndex = addressServiceInterface.setSelectedZoneIndex(response, _zoneIds, _selectedZoneIndex, _zoneList);
    update();
  }

  Future<String> _getAddressFromGeocode(LatLng latLng) async {
    String address = await addressServiceInterface.getAddressFromGeocode(latLng);
    return address;
  }

  Future<List<PredictionModel>> searchLocation(BuildContext context, String text) async {
    if(text.isNotEmpty) {
      List<PredictionModel> predictionList = await addressServiceInterface.searchLocation(text);
      if(predictionList.isNotEmpty) {
        _predictionList = [];
        _predictionList.addAll(predictionList);
      }
    }
    return _predictionList;
  }

  Future<Position> setSuggestedLocation(String? placeID, String? address, GoogleMapController? mapController) async {
    _isLoading = true;
    update();

    LatLng latLng = const LatLng(0, 0);
    PlaceDetailsModel? placeDetails = await addressServiceInterface.getPlaceDetails(placeID);
    if(placeDetails != null && placeDetails.status == 'OK') {
      latLng = LatLng(placeDetails.result!.geometry!.location!.lat!, placeDetails.result!.geometry!.location!.lng!);
    }

    _pickPosition = Position(
      latitude: latLng.latitude, longitude: latLng.longitude,
      timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1, altitudeAccuracy: 1, headingAccuracy: 1,
    );

    _pickAddress = address;

    if(mapController != null) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: latLng, zoom: 16)));
    }
    _isLoading = false;
    update();
    return _pickPosition;
  }

  Future<ZoneResponseModel> getZone(String lat, String long, bool markerLoad, {bool updateInAddress = false}) async {
    if(markerLoad) {
      _loading = true;
    }else {
      _isLoading = true;
    }

    if(!updateInAddress){
      update();
    }
    ZoneResponseModel responseModel;
    Response response = await addressServiceInterface.getZone(lat, long);
    if(response.statusCode == 200) {
      _inZone = true;
      _zoneID = int.parse(jsonDecode(response.body['zone_id'])[0].toString());
      List<int> zoneIds = [];
      jsonDecode(response.body['zone_id']).forEach((zoneId){
        zoneIds.add(int.parse(zoneId.toString()));
      });
      responseModel = ZoneResponseModel(true, '' , zoneIds);

    }else {
      _inZone = false;
      responseModel = ZoneResponseModel(false, response.statusText, []);
    }
    if(markerLoad) {
      _loading = false;
    }else {
      _isLoading = false;
    }
    update();
    return responseModel;
  }

  Future<bool> saveUserAddress(AddressModel address) async {
    String userAddress = jsonEncode(address.toJson());
    return await addressServiceInterface.saveUserAddress(userAddress, address.zoneIds);
  }

  AddressModel? getUserAddress() {
    AddressModel? addressModel;
    try {
      addressModel = AddressModel.fromJson(jsonDecode(addressServiceInterface.getUserAddress()!));
    }catch(e) {
      debugPrint('Address Not Found In SharedPreference:$e');
    }
    return addressModel;
  }

}