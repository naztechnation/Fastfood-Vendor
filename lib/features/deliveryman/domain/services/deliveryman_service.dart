import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/deliveryman/domain/repositories/deliveryman_repository_interface.dart';
import 'package:sixam_mart_store/features/deliveryman/domain/services/deliveryman_service_interface.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/features/deliveryman/domain/models/delivery_man_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/review_model.dart';

class DeliverymanService implements DeliverymanServiceInterface {
  final DeliverymanRepositoryInterface deliverymanRepositoryInterface;
  DeliverymanService({required this.deliverymanRepositoryInterface});

  @override
  Future<List<DeliveryManModel>?> getDeliveryManList() async {
    return await deliverymanRepositoryInterface.getList();
  }

  @override
  Future<bool> addDeliveryMan(DeliveryManModel deliveryMan, String pass, XFile? image, List<XFile> identities, String token, bool isAdd) async {
    return await deliverymanRepositoryInterface.addDeliveryMan(deliveryMan, pass, image, identities, token, isAdd);
  }

  @override
  Future<bool> deleteDeliveryMan(int? deliveryManID) async {
    return await deliverymanRepositoryInterface.delete(deliveryManID);
  }

  @override
  Future<bool> updateDeliveryManStatus(int? deliveryManID, int status) async {
    return await deliverymanRepositoryInterface.updateDeliveryManStatus(deliveryManID, status);
  }

  @override
  Future<List<ReviewModel>?> getDeliveryManReviews(int? deliveryManID) async {
    return await deliverymanRepositoryInterface.get(deliveryManID);
  }

  @override
  int identityTypeIndex(List<String> identityTypeList, String? identityType) {
    int index0 = 0;
    for(int index = 0; index < identityTypeList.length; index++) {
      if(identityTypeList[index] == identityType) {
        index0 = index;
        break;
      }
    }
    return index0;
  }

  @override
  Future<XFile?> pickImageFromGallery() async {
    XFile? pickImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickImage != null) {
      pickImage.length().then((value) {
        if (value > 2000000) {
          showCustomSnackBar('please_upload_lower_size_file'.tr);
        } else {
          return pickImage;
        }
      });
    }
    return pickImage;
  }

}