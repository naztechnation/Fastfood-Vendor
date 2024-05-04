import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:sixam_mart_store/features/auth/domain/services/auth_service_interface.dart';
import 'package:sixam_mart_store/features/store/domain/models/store_body_model.dart';

class AuthService implements AuthServiceInterface {
  final AuthRepositoryInterface authRepositoryInterface;
  AuthService({required this.authRepositoryInterface});

  @override
  Future<Response> login(String? email, String password, String type) async {
    return await authRepositoryInterface.login(email, password, type);
  }

  @override
  Future<bool> registerRestaurant(StoreBodyModel store, XFile? logo, XFile? cover) async {
    return await authRepositoryInterface.registerRestaurant(store, logo, cover);
  }

  @override
  Future<Response> updateToken() async {
    return await authRepositoryInterface.updateToken();
  }

  @override
  Future<bool> saveUserToken(String token, String zoneTopic, String type) async {
    return await authRepositoryInterface.saveUserToken(token, zoneTopic, type);
  }

  @override
  String getUserToken() {
    return authRepositoryInterface.getUserToken();
  }

  @override
  bool isLoggedIn() {
    return authRepositoryInterface.isLoggedIn();
  }

  @override
  Future<bool> clearSharedData() async {
    return await authRepositoryInterface.clearSharedData();
  }

  @override
  Future<void> saveUserNumberAndPassword(String number, String password, String type) async {
    return await authRepositoryInterface.saveUserNumberAndPassword(number, password, type);
  }

  @override
  String getUserNumber() {
    return authRepositoryInterface.getUserNumber();
  }

  @override
  String getUserPassword() {
    return authRepositoryInterface.getUserPassword();
  }

  @override
  String getUserType() {
    return authRepositoryInterface.getUserType();
  }

  @override
  bool isNotificationActive() {
    return authRepositoryInterface.isNotificationActive();
  }

  @override
  void setNotificationActive(bool isActive) {
    return authRepositoryInterface.setNotificationActive(isActive);
  }

  @override
  Future<bool> clearUserNumberAndPassword() async {
    return await authRepositoryInterface.clearUserNumberAndPassword();
  }

  @override
  Future<bool> toggleStoreClosedStatus() async {
    return await authRepositoryInterface.toggleStoreClosedStatus();
  }

}