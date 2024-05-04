import 'package:sixam_mart_store/interface/repository_interface.dart';

abstract class HtmlRepositoryInterface implements RepositoryInterface {
  Future<dynamic> getHtmlText(bool isPrivacyPolicy);
}