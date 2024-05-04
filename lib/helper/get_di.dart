import 'dart:convert';
import 'package:sixam_mart_store/common/controllers/theme_controller.dart';
import 'package:sixam_mart_store/api/api_client.dart';
import 'package:sixam_mart_store/features/addon/controllers/addon_controller.dart';
import 'package:sixam_mart_store/features/addon/domain/repositories/addon_repository.dart';
import 'package:sixam_mart_store/features/addon/domain/repositories/addon_repository_interface.dart';
import 'package:sixam_mart_store/features/addon/domain/services/addon_service.dart';
import 'package:sixam_mart_store/features/addon/domain/services/addon_service_interface.dart';
import 'package:sixam_mart_store/features/address/controllers/address_controller.dart';
import 'package:sixam_mart_store/features/address/domain/repositories/address_repository.dart';
import 'package:sixam_mart_store/features/address/domain/repositories/address_repository_interface.dart';
import 'package:sixam_mart_store/features/address/domain/services/address_service.dart';
import 'package:sixam_mart_store/features/address/domain/services/address_service_interface.dart';
import 'package:sixam_mart_store/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart_store/features/auth/domain/repositories/auth_repository.dart';
import 'package:sixam_mart_store/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:sixam_mart_store/features/auth/domain/services/auth_service.dart';
import 'package:sixam_mart_store/features/auth/domain/services/auth_service_interface.dart';
import 'package:sixam_mart_store/features/banner/controllers/banner_controller.dart';
import 'package:sixam_mart_store/features/banner/domain/repositories/banner_repository.dart';
import 'package:sixam_mart_store/features/banner/domain/repositories/banner_repository_interface.dart';
import 'package:sixam_mart_store/features/banner/domain/services/banner_service.dart';
import 'package:sixam_mart_store/features/banner/domain/services/banner_service_interface.dart';
import 'package:sixam_mart_store/features/campaign/controllers/campaign_controller.dart';
import 'package:sixam_mart_store/features/campaign/domain/repositories/campaign_repository.dart';
import 'package:sixam_mart_store/features/campaign/domain/repositories/campaign_repository_interface.dart';
import 'package:sixam_mart_store/features/campaign/domain/services/campaign_service.dart';
import 'package:sixam_mart_store/features/campaign/domain/services/campaign_service_interface.dart';
import 'package:sixam_mart_store/features/category/controllers/category_controller.dart';
import 'package:sixam_mart_store/features/category/domain/repositories/category_repository.dart';
import 'package:sixam_mart_store/features/category/domain/repositories/category_repository_interface.dart';
import 'package:sixam_mart_store/features/category/domain/services/category_service.dart';
import 'package:sixam_mart_store/features/category/domain/services/category_service_interface.dart';
import 'package:sixam_mart_store/features/chat/controllers/chat_controller.dart';
import 'package:sixam_mart_store/features/chat/domain/repositories/chat_repository.dart';
import 'package:sixam_mart_store/features/chat/domain/repositories/chat_repository_interface.dart';
import 'package:sixam_mart_store/features/chat/domain/services/chat_service.dart';
import 'package:sixam_mart_store/features/chat/domain/services/chat_service_interface.dart';
import 'package:sixam_mart_store/features/coupon/controllers/coupon_controller.dart';
import 'package:sixam_mart_store/features/coupon/domain/repositories/coupon_repository.dart';
import 'package:sixam_mart_store/features/coupon/domain/repositories/coupon_repository_interface.dart';
import 'package:sixam_mart_store/features/coupon/domain/services/coupon_service.dart';
import 'package:sixam_mart_store/features/coupon/domain/services/coupon_service_interface.dart';
import 'package:sixam_mart_store/features/deliveryman/controllers/deliveryman_controller.dart';
import 'package:sixam_mart_store/features/deliveryman/domain/repositories/deliveryman_repository.dart';
import 'package:sixam_mart_store/features/deliveryman/domain/repositories/deliveryman_repository_interface.dart';
import 'package:sixam_mart_store/features/deliveryman/domain/services/deliveryman_service.dart';
import 'package:sixam_mart_store/features/deliveryman/domain/services/deliveryman_service_interface.dart';
import 'package:sixam_mart_store/features/disbursement/controllers/disbursement_controller.dart';
import 'package:sixam_mart_store/features/disbursement/domain/repositories/disbursement_repository.dart';
import 'package:sixam_mart_store/features/disbursement/domain/repositories/disbursement_repository_interface.dart';
import 'package:sixam_mart_store/features/disbursement/domain/services/disbursement_service.dart';
import 'package:sixam_mart_store/features/disbursement/domain/services/disbursement_service_interface.dart';
import 'package:sixam_mart_store/features/expense/controllers/expense_controller.dart';
import 'package:sixam_mart_store/features/expense/domain/repositories/expense_repository.dart';
import 'package:sixam_mart_store/features/expense/domain/repositories/expense_repository_interface.dart';
import 'package:sixam_mart_store/features/expense/domain/services/expense_service.dart';
import 'package:sixam_mart_store/features/expense/domain/services/expense_service_interface.dart';
import 'package:sixam_mart_store/features/forgot_password/controllers/forgot_password_controller.dart';
import 'package:sixam_mart_store/features/forgot_password/domain/repositories/forgot_password_repository.dart';
import 'package:sixam_mart_store/features/forgot_password/domain/repositories/forgot_password_repository_interface.dart';
import 'package:sixam_mart_store/features/forgot_password/domain/services/forgot_password_service.dart';
import 'package:sixam_mart_store/features/forgot_password/domain/services/forgot_password_service_interface.dart';
import 'package:sixam_mart_store/features/html/controllers/html_controller.dart';
import 'package:sixam_mart_store/features/html/domain/repositories/html_repository.dart';
import 'package:sixam_mart_store/features/html/domain/repositories/html_repository_interface.dart';
import 'package:sixam_mart_store/features/html/domain/services/html_service.dart';
import 'package:sixam_mart_store/features/html/domain/services/html_service_interface.dart';
import 'package:sixam_mart_store/features/language/controllers/language_controller.dart';
import 'package:sixam_mart_store/features/language/domain/repositories/language_repository.dart';
import 'package:sixam_mart_store/features/language/domain/repositories/language_repository_interface.dart';
import 'package:sixam_mart_store/features/language/domain/services/language_service.dart';
import 'package:sixam_mart_store/features/language/domain/services/language_service_interface.dart';
import 'package:sixam_mart_store/features/notification/controllers/notification_controller.dart';
import 'package:sixam_mart_store/features/notification/domain/repositories/notification_repository.dart';
import 'package:sixam_mart_store/features/notification/domain/repositories/notification_repository_interface.dart';
import 'package:sixam_mart_store/features/notification/domain/services/notification_service.dart';
import 'package:sixam_mart_store/features/notification/domain/services/notification_service_interface.dart';
import 'package:sixam_mart_store/features/order/controllers/order_controller.dart';
import 'package:sixam_mart_store/features/order/domain/repositories/order_repository.dart';
import 'package:sixam_mart_store/features/order/domain/repositories/order_repository_interface.dart';
import 'package:sixam_mart_store/features/order/domain/services/order_service.dart';
import 'package:sixam_mart_store/features/order/domain/services/order_service_interface.dart';
import 'package:sixam_mart_store/features/payment/controllers/payment_controller.dart';
import 'package:sixam_mart_store/features/payment/domain/repositories/payment_repository.dart';
import 'package:sixam_mart_store/features/payment/domain/repositories/payment_repository_interface.dart';
import 'package:sixam_mart_store/features/payment/domain/services/payment_service.dart';
import 'package:sixam_mart_store/features/payment/domain/services/payment_service_interface.dart';
import 'package:sixam_mart_store/features/pos/controllers/pos_controller.dart';
import 'package:sixam_mart_store/features/pos/domain/repositories/pos_repository.dart';
import 'package:sixam_mart_store/features/pos/domain/repositories/pos_repository_interface.dart';
import 'package:sixam_mart_store/features/pos/domain/services/pos_service.dart';
import 'package:sixam_mart_store/features/pos/domain/services/pos_service_interface.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/profile/domain/repositories/profile_repository.dart';
import 'package:sixam_mart_store/features/profile/domain/repositories/profile_repository_interface.dart';
import 'package:sixam_mart_store/features/profile/domain/services/profile_service.dart';
import 'package:sixam_mart_store/features/profile/domain/services/profile_service_interface.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/features/splash/domain/repositories/splash_repository.dart';
import 'package:sixam_mart_store/features/splash/domain/repositories/splash_repository_interface.dart';
import 'package:sixam_mart_store/features/splash/domain/services/splash_service.dart';
import 'package:sixam_mart_store/features/splash/domain/services/splash_service_interface.dart';
import 'package:sixam_mart_store/features/store/controllers/store_controller.dart';
import 'package:sixam_mart_store/features/store/domain/repositories/store_repository.dart';
import 'package:sixam_mart_store/features/store/domain/repositories/store_repository_interface.dart';
import 'package:sixam_mart_store/features/store/domain/services/store_service.dart';
import 'package:sixam_mart_store/features/store/domain/services/store_service_interface.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:sixam_mart_store/features/language/domain/models/language_model.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

Future<Map<String, Map<String, String>>> init() async {

  /// Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.baseUrl, sharedPreferences: Get.find()));

  ///Repository Interface
  AuthRepositoryInterface authRepositoryInterface = AuthRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => authRepositoryInterface);

  AddonRepositoryInterface addonRepositoryInterface = AddonRepository(apiClient: Get.find());
  Get.lazyPut(() => addonRepositoryInterface);

  BannerRepositoryInterface bannerRepositoryInterface = BannerRepository(apiClient: Get.find());
  Get.lazyPut(() => bannerRepositoryInterface);

  CampaignRepositoryInterface campaignRepositoryInterface = CampaignRepository(apiClient: Get.find());
  Get.lazyPut(() => campaignRepositoryInterface);

  CategoryRepositoryInterface categoryRepositoryInterface = CategoryRepository(apiClient: Get.find());
  Get.lazyPut(() => categoryRepositoryInterface);

  SplashRepositoryInterface splashRepositoryInterface = SplashRepository(sharedPreferences: Get.find(), apiClient: Get.find());
  Get.lazyPut(() => splashRepositoryInterface);

  HtmlRepositoryInterface htmlRepositoryInterface = HtmlRepository(apiClient: Get.find());
  Get.lazyPut(() => htmlRepositoryInterface);

  ExpenseRepositoryInterface expenseRepositoryInterface = ExpenseRepository(apiClient: Get.find());
  Get.lazyPut(() => expenseRepositoryInterface);

  CouponRepositoryInterface couponRepositoryInterface = CouponRepository(apiClient: Get.find());
  Get.lazyPut(() => couponRepositoryInterface);

  DeliverymanRepositoryInterface deliverymanRepositoryInterface = DeliverymanRepository(apiClient: Get.find());
  Get.lazyPut(() => deliverymanRepositoryInterface);

  DisbursementRepositoryInterface disbursementRepositoryInterface = DisbursementRepository(apiClient: Get.find());
  Get.lazyPut(() => disbursementRepositoryInterface);

  ForgotPasswordRepositoryInterface forgotPasswordRepositoryInterface = ForgotPasswordRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => forgotPasswordRepositoryInterface);

  LanguageRepositoryInterface languageRepositoryInterface = LanguageRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => languageRepositoryInterface);

  NotificationRepositoryInterface notificationRepositoryInterface = NotificationRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => notificationRepositoryInterface);

  PaymentRepositoryInterface paymentRepositoryInterface = PaymentRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => paymentRepositoryInterface);

  ProfileRepositoryInterface profileRepositoryInterface = ProfileRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => profileRepositoryInterface);

  AddressRepositoryInterface addressRepositoryInterface = AddressRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => addressRepositoryInterface);

  ChatRepositoryInterface chatRepositoryInterface = ChatRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => chatRepositoryInterface);

  OrderRepositoryInterface orderRepositoryInterface = OrderRepository(apiClient: Get.find(), sharedPreferences: Get.find());
  Get.lazyPut(() => orderRepositoryInterface);

  StoreRepositoryInterface storeRepositoryInterface = StoreRepository(apiClient: Get.find());
  Get.lazyPut(() => storeRepositoryInterface);

  PosRepositoryInterface posRepositoryInterface = PosRepository(apiClient: Get.find());
  Get.lazyPut(() => posRepositoryInterface);

  /// Service Interface
  AuthServiceInterface authServiceInterface = AuthService(authRepositoryInterface: Get.find());
  Get.lazyPut(() => authServiceInterface);

  AddonServiceInterface addonServiceInterface = AddonService(addonRepositoryInterface: Get.find());
  Get.lazyPut(() => addonServiceInterface);

  BannerServiceInterface bannerServiceInterface = BannerService(bannerRepositoryInterface: Get.find());
  Get.lazyPut(() => bannerServiceInterface);

  CampaignServiceInterface campaignServiceInterface = CampaignService(campaignRepositoryInterface: Get.find());
  Get.lazyPut(() => campaignServiceInterface);

  CategoryServiceInterface categoryServiceInterface = CategoryService(categoryRepositoryInterface: Get.find());
  Get.lazyPut(() => categoryServiceInterface);

  SplashServiceInterface splashServiceInterface = SplashService(splashRepositoryInterface: Get.find());
  Get.lazyPut(() => splashServiceInterface);

  HtmlServiceInterface htmlServiceInterface = HtmlService(htmlRepositoryInterface: Get.find());
  Get.lazyPut(() => htmlServiceInterface);

  ExpenseServiceInterface expenseServiceInterface = ExpenseService(expenseRepositoryInterface: Get.find());
  Get.lazyPut(() => expenseServiceInterface);

  CouponServiceInterface couponServiceInterface = CouponService(couponRepositoryInterface: Get.find());
  Get.lazyPut(() => couponServiceInterface);

  DeliverymanServiceInterface deliverymanServiceInterface = DeliverymanService(deliverymanRepositoryInterface: Get.find());
  Get.lazyPut(() => deliverymanServiceInterface);

  DisbursementServiceInterface disbursementServiceInterface = DisbursementService(disbursementRepositoryInterface: Get.find());
  Get.lazyPut(() => disbursementServiceInterface);

  ForgotPasswordServiceInterface forgotPasswordServiceInterface = ForgotPasswordService(forgotPasswordRepositoryInterface: Get.find());
  Get.lazyPut(() => forgotPasswordServiceInterface);

  LanguageServiceInterface languageServiceInterface = LanguageService(languageRepositoryInterface: Get.find());
  Get.lazyPut(() => languageServiceInterface);

  NotificationServiceInterface notificationServiceInterface = NotificationService(notificationRepositoryInterface: Get.find());
  Get.lazyPut(() => notificationServiceInterface);

  PaymentServiceInterface paymentServiceInterface = PaymentService(paymentRepositoryInterface: Get.find());
  Get.lazyPut(() => paymentServiceInterface);

  ProfileServiceInterface profileServiceInterface = ProfileService(profileRepositoryInterface: Get.find());
  Get.lazyPut(() => profileServiceInterface);

  AddressServiceInterface addressServiceInterface = AddressService(addressRepositoryInterface: Get.find());
  Get.lazyPut(() => addressServiceInterface);

  ChatServiceInterface chatServiceInterface = ChatService(chatRepositoryInterface: Get.find());
  Get.lazyPut(() => chatServiceInterface);

  OrderServiceInterface orderServiceInterface = OrderService(orderRepositoryInterface: Get.find());
  Get.lazyPut(() => orderServiceInterface);

  StoreServiceInterface storeServiceInterface = StoreService(storeRepositoryInterface: Get.find());
  Get.lazyPut(() => storeServiceInterface);

  PosServiceInterface posServiceInterface = PosService(posRepositoryInterface: Get.find());
  Get.lazyPut(() => posServiceInterface);

  /// Services
  Get.lazyPut(() => AuthService(authRepositoryInterface: Get.find()));
  Get.lazyPut(() => AddonService(addonRepositoryInterface: Get.find()));
  Get.lazyPut(() => BannerService(bannerRepositoryInterface: Get.find()));
  Get.lazyPut(() => CampaignService(campaignRepositoryInterface: Get.find()));
  Get.lazyPut(() => CategoryService(categoryRepositoryInterface: Get.find()));
  Get.lazyPut(() => SplashService(splashRepositoryInterface: Get.find()));
  Get.lazyPut(() => HtmlService(htmlRepositoryInterface: Get.find()));
  Get.lazyPut(() => ExpenseService(expenseRepositoryInterface: Get.find()));
  Get.lazyPut(() => CouponService(couponRepositoryInterface: Get.find()));
  Get.lazyPut(() => DeliverymanService(deliverymanRepositoryInterface: Get.find()));
  Get.lazyPut(() => DisbursementService(disbursementRepositoryInterface: Get.find()));
  Get.lazyPut(() => ForgotPasswordService(forgotPasswordRepositoryInterface: Get.find()));
  Get.lazyPut(() => LanguageService(languageRepositoryInterface: Get.find()));
  Get.lazyPut(() => NotificationService(notificationRepositoryInterface: Get.find()));
  Get.lazyPut(() => PaymentService(paymentRepositoryInterface: Get.find()));
  Get.lazyPut(() => ProfileService(profileRepositoryInterface: Get.find()));
  Get.lazyPut(() => AddressService(addressRepositoryInterface: Get.find()));
  Get.lazyPut(() => ChatService(chatRepositoryInterface: Get.find()));
  Get.lazyPut(() => OrderService(orderRepositoryInterface: Get.find()));
  Get.lazyPut(() => StoreService(storeRepositoryInterface: Get.find()));
  Get.lazyPut(() => PosService(posRepositoryInterface: Get.find()));

  /// Controller
  Get.lazyPut(() => AuthController(authServiceInterface: Get.find()));
  Get.lazyPut(() => AddonController(addonServiceInterface: Get.find()));
  Get.lazyPut(() => BannerController(bannerServiceInterface: Get.find()));
  Get.lazyPut(() => CampaignController(campaignServiceInterface: Get.find()));
  Get.lazyPut(() => CategoryController(categoryServiceInterface: Get.find()));
  Get.lazyPut(() => SplashController(splashServiceInterface: Get.find()));
  Get.lazyPut(() => HtmlController(htmlServiceInterface: Get.find()));
  Get.lazyPut(() => ExpenseController(expenseServiceInterface: Get.find()));
  Get.lazyPut(() => CouponController(couponServiceInterface: Get.find()));
  Get.lazyPut(() => DeliveryManController(deliverymanServiceInterface: Get.find()));
  Get.lazyPut(() => DisbursementController(disbursementServiceInterface: Get.find()));
  Get.lazyPut(() => ForgotPasswordController(forgotPasswordServiceInterface: Get.find()));
  Get.lazyPut(() => LocalizationController(languageServiceInterface: Get.find()));
  Get.lazyPut(() => NotificationController(notificationServiceInterface: Get.find()));
  Get.lazyPut(() => PaymentController(paymentServiceInterface: Get.find()));
  Get.lazyPut(() => ProfileController(profileServiceInterface: Get.find()));
  Get.lazyPut(() => AddressController(addressServiceInterface: Get.find()));
  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));
  Get.lazyPut(() => ChatController(chatServiceInterface: Get.find()));
  Get.lazyPut(() => OrderController(orderServiceInterface: Get.find()));
  Get.lazyPut(() => StoreController(storeServiceInterface: Get.find()));
  Get.lazyPut(() => PosController(posServiceInterface: Get.find()));

  /// Retrieving localized data
  Map<String, Map<String, String>> languages = {};
  for(LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues =  await rootBundle.loadString('assets/language/${languageModel.languageCode}.json');
    Map<String, dynamic> mappedJson = jsonDecode(jsonStringValues);
    Map<String, String> json = {};
    mappedJson.forEach((key, value) {
      json[key] = value.toString();
    });
    languages['${languageModel.languageCode}_${languageModel.countryCode}'] = json;
  }
  return languages;
}