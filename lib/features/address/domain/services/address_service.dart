import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sixam_mart_store/features/address/domain/models/zone_model.dart';
import 'package:sixam_mart_store/features/auth/domain/models/module_model.dart';
import 'package:sixam_mart_store/features/address/domain/models/place_details_model.dart';
import 'package:sixam_mart_store/features/address/domain/models/prediction_model.dart';
import 'package:sixam_mart_store/features/address/domain/models/zone_response_model.dart';
import 'package:sixam_mart_store/features/address/domain/repositories/address_repository_interface.dart';
import 'package:sixam_mart_store/features/address/domain/services/address_service_interface.dart';

class AddressService implements AddressServiceInterface {
  final AddressRepositoryInterface addressRepositoryInterface;
  AddressService({required this.addressRepositoryInterface});

  @override
  Future<List<ZoneModel>?> getZoneList() async {
    return await addressRepositoryInterface.getList();
  }

  @override
  Future<String> getAddressFromGeocode(LatLng latLng) async {
    return await addressRepositoryInterface.getAddressFromGeocode(latLng);
  }

  @override
  Future<List<PredictionModel>> searchLocation(String text) async {
    return await addressRepositoryInterface.searchLocation(text);
  }

  @override
  Future<PlaceDetailsModel?> getPlaceDetails(String? placeID) async {
    return await addressRepositoryInterface.getPlaceDetails(placeID);
  }

  @override
  Future<Response> getZone(String lat, String lng) async {
    return await addressRepositoryInterface.getZone(lat, lng);
  }

  @override
  Future<bool> saveUserAddress(String address, List<int>? zoneIDs) async {
    return await addressRepositoryInterface.saveUserAddress(address, zoneIDs);
  }

  @override
  String? getUserAddress() {
    return addressRepositoryInterface.getUserAddress();
  }

  @override
  Future<List<ModuleModel>?> getModules(int? zoneId) async {
    return await addressRepositoryInterface.getModules(zoneId);
  }

  @override
  LatLng? setRestaurantLocation(ZoneResponseModel response, LatLng location) {
    LatLng? restaurantLocation;
    if(response.isSuccess && response.zoneIds.isNotEmpty) {
      restaurantLocation = location;
    }else {
      restaurantLocation = null;
    }
    return restaurantLocation;
  }

  @override
  List<int>? setZoneIds(ZoneResponseModel response) {
    List<int>? zoneIds;
    if(response.isSuccess && response.zoneIds.isNotEmpty) {
      zoneIds = response.zoneIds;
    }else {
      zoneIds = null;
    }
    return zoneIds;
  }

  @override
  int? setSelectedZoneIndex(ZoneResponseModel response, List<int>? zoneIds, int? selectedZoneIndex, List<ZoneModel>? zoneList) {
    int? zoneIndex = selectedZoneIndex;
    if(response.isSuccess && response.zoneIds.isNotEmpty) {
      for(int index = 0; index < zoneList!.length; index++) {
        if(zoneIds!.contains(zoneList[index].id)) {
          zoneIndex = index;
          break;
        }
      }
    }
    return zoneIndex;
  }

}