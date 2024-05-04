import 'package:sixam_mart_store/interface/repository_interface.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/features/store/domain/models/store_body_model.dart';

abstract class AuthRepositoryInterface implements RepositoryInterface {
  Future<dynamic> login(String? email, String password, String type);
  Future<dynamic> registerRestaurant(StoreBodyModel store, XFile? logo, XFile? cover);
  Future<dynamic> updateToken();
  Future<bool> saveUserToken(String token, String zoneTopic, String type);
  String getUserToken();
  bool isLoggedIn();
  Future<bool> clearSharedData();
  Future<void> saveUserNumberAndPassword(String number, String password, String type);
  String getUserNumber();
  String getUserPassword();
  String getUserType();
  bool isNotificationActive();
  void setNotificationActive(bool isActive);
  Future<bool> clearUserNumberAndPassword();
  Future<dynamic> toggleStoreClosedStatus();
}