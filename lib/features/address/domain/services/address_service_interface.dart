import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sixam_mart_store/features/address/domain/models/place_details_model.dart';
import 'package:sixam_mart_store/features/address/domain/models/prediction_model.dart';
import 'package:sixam_mart_store/features/address/domain/models/zone_model.dart';
import 'package:sixam_mart_store/features/address/domain/models/zone_response_model.dart';
import 'package:sixam_mart_store/features/auth/domain/models/module_model.dart';

abstract class AddressServiceInterface {
  Future<List<ZoneModel>?> getZoneList();
  Future<String> getAddressFromGeocode(LatLng latLng);
  Future<List<PredictionModel>> searchLocation(String text);
  Future<PlaceDetailsModel?> getPlaceDetails(String? placeID);
  Future<Response> getZone(String lat, String lng);
  Future<bool> saveUserAddress(String address, List<int>? zoneIDs);
  String? getUserAddress();
  Future<List<ModuleModel>?> getModules(int? zoneId);
  LatLng? setRestaurantLocation(ZoneResponseModel response, LatLng location);
  List<int>? setZoneIds(ZoneResponseModel response);
  int? setSelectedZoneIndex(ZoneResponseModel response, List<int>? zoneIds, int? selectedZoneIndex, List<ZoneModel>? zoneList);
}