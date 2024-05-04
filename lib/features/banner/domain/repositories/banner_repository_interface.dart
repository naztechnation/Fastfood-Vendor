import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/interface/repository_interface.dart';

abstract class BannerRepositoryInterface extends RepositoryInterface {
  Future<dynamic> addBanner(String title, String url, XFile image);
  Future<dynamic> updateBanner(int? bannerID, String title, String url, XFile? image);
}