import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/features/deliveryman/domain/models/delivery_man_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/review_model.dart';

abstract class DeliverymanServiceInterface {
  Future<List<DeliveryManModel>?> getDeliveryManList();
  Future<bool> addDeliveryMan(DeliveryManModel deliveryMan, String pass, XFile? image, List<XFile> identities, String token, bool isAdd);
  Future<bool> deleteDeliveryMan(int? deliveryManID);
  Future<bool> updateDeliveryManStatus(int? deliveryManID, int status);
  Future<List<ReviewModel>?> getDeliveryManReviews(int? deliveryManID);
  int identityTypeIndex(List<String> identityTypeList, String? identityType);
  Future<XFile?> pickImageFromGallery();
}