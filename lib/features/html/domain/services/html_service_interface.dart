import 'package:get/get.dart';

abstract class HtmlServiceInterface {
  Future<Response> getHtmlText(bool isPrivacyPolicy);
}