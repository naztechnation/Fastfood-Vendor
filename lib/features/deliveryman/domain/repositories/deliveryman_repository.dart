import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/api/api_client.dart';
import 'package:sixam_mart_store/features/deliveryman/domain/models/delivery_man_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/review_model.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/features/deliveryman/domain/repositories/deliveryman_repository_interface.dart';

class DeliverymanRepository implements DeliverymanRepositoryInterface {
  final ApiClient apiClient;
  DeliverymanRepository({required this.apiClient});

  @override
  Future<List<DeliveryManModel>?> getList() async {
    List<DeliveryManModel>? deliveryManList;
    Response response = await apiClient.getData(AppConstants.dmListUri);
    if(response.statusCode == 200) {
      deliveryManList = [];
      response.body.forEach((deliveryMan) => deliveryManList!.add(DeliveryManModel.fromJson(deliveryMan)));
    }
    return deliveryManList;
  }

  @override
  Future<bool> addDeliveryMan(DeliveryManModel deliveryMan, String pass, XFile? image, List<XFile> identities, String token, bool isAdd) async {

    List<MultipartBody> multiParts = [];
    multiParts.add(MultipartBody('image', image));
    for(XFile file in identities) {
      multiParts.add(MultipartBody('identity_image[]', file));
    }

    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      'f_name': deliveryMan.fName!, 'l_name': deliveryMan.lName!, 'email': deliveryMan.email!, 'password': pass,
      'phone': deliveryMan.phone!, 'identity_type': deliveryMan.identityType!, 'identity_number': deliveryMan.identityNumber!,
    });

    Response response = await apiClient.postMultipartData(isAdd ? AppConstants.addDmUri : '${AppConstants.updateDmUri}${deliveryMan.id}', fields, multiParts);
    return (response.statusCode == 200);
  }

  @override
  Future<bool> delete(int? id) async {
    Response response = await apiClient.postData(AppConstants.deleteDmUri, {'_method': 'delete', 'delivery_man_id': id});
    return (response.statusCode == 200);
  }

  @override
  Future<bool> updateDeliveryManStatus(int? deliveryManID, int status) async {
    Response response = await apiClient.getData('${AppConstants.updateDmStatusUri}?delivery_man_id=$deliveryManID&status=$status');
    return (response.statusCode == 200);
  }

  @override
  Future<List<ReviewModel>?> get(int? id) async {
    List<ReviewModel>? dmReviewList;
    Response response = await apiClient.getData('${AppConstants.dmReviewUri}?delivery_man_id=$id');
    if(response.statusCode == 200) {
      dmReviewList = [];
      response.body['reviews'].forEach((review) => dmReviewList!.add(ReviewModel.fromJson(review)));
    }
    return dmReviewList;
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body) {
    throw UnimplementedError();
  }

}