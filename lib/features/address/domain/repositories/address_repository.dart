import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixam_mart_store/api/api_client.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/auth/domain/models/module_model.dart';
import 'package:sixam_mart_store/features/address/domain/models/place_details_model.dart';
import 'package:sixam_mart_store/features/address/domain/models/prediction_model.dart';
import 'package:sixam_mart_store/features/address/domain/models/zone_model.dart';
import 'package:sixam_mart_store/features/address/domain/repositories/address_repository_interface.dart';
import 'package:sixam_mart_store/util/app_constants.dart';

class AddressRepository implements AddressRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AddressRepository({required this.apiClient, required this.sharedPreferences});

  @override
  Future<List<ZoneModel>?> getList() async {
    List<ZoneModel>? zoneList;
    Response response = await apiClient.getData(AppConstants.zoneListUri);
    if (response.statusCode == 200) {
      zoneList = [];
      response.body.forEach((zone) => zoneList!.add(ZoneModel.fromJson(zone)));
    }
    return zoneList;
  }

  @override
  Future<String> getAddressFromGeocode(LatLng latLng) async {
    String address = 'Unknown Location Found';
    Response response = await apiClient.getData('${AppConstants.geocodeUri}?lat=${latLng.latitude}&lng=${latLng.longitude}', handleError: false);
    if(response.statusCode == 200 && response.body['status'] == 'OK') {
      address = response.body['results'][0]['formatted_address'].toString();
    }else {
      showCustomSnackBar(response.body['error_message'] ?? response.bodyString);
    }
    return address;
  }

  @override
  Future<List<PredictionModel>> searchLocation(String text) async {
    List<PredictionModel> predictionList = [];
    Response response = await apiClient.getData('${AppConstants.searchLocationUri}?search_text=$text', handleError: false);
    if (response.statusCode == 200 && response.body['status'] == 'OK') {
      predictionList = [];
      response.body['predictions'].forEach((prediction) => predictionList.add(PredictionModel.fromJson(prediction)));
    } else {
      showCustomSnackBar(response.body['error_message'] ?? response.bodyString);
    }
    return predictionList;
  }

  @override
  Future<PlaceDetailsModel?> getPlaceDetails(String? placeID) async {
    PlaceDetailsModel? placeDetails;
    Response response = await apiClient.getData('${AppConstants.placeDetailsUri}?placeid=$placeID');
    if(response.statusCode == 200){
      placeDetails = PlaceDetailsModel.fromJson(response.body);
    }
    return placeDetails;
  }

  @override
  Future<Response> getZone(String lat, String lng) async {
    return await apiClient.getData('${AppConstants.zoneUri}?lat=$lat&lng=$lng');
  }

  @override
  Future<bool> saveUserAddress(String address, List<int>? zoneIDs) async {
    apiClient.updateHeader(
        sharedPreferences.getString(AppConstants.token),
        sharedPreferences.getString(AppConstants.languageCode), null,
        sharedPreferences.getString(AppConstants.type)
    );
    return await sharedPreferences.setString(AppConstants.userAddress, address);
  }

  @override
  String? getUserAddress() {
    return sharedPreferences.getString(AppConstants.userAddress);
  }

  @override
  Future<List<ModuleModel>?> getModules(int? zoneId) async {
    List<ModuleModel>? moduleList;
    Response response = await apiClient.getData('${AppConstants.modulesUri}?zone_id=$zoneId');
    if (response.statusCode == 200) {
      moduleList = [];
      response.body.forEach((storeCategory) => moduleList!.add(ModuleModel.fromJson(storeCategory)));
    }
    return moduleList;
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    throw UnimplementedError();
  }

  @override
  Future get(int? id) {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body) {
    throw UnimplementedError();
  }

}