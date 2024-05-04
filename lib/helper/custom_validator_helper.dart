import 'package:flutter/foundation.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class CustomValidatorHelper {

  static Future<PhoneValid> isPhoneValid(String number) async {
    String phone = number;
    bool isValid = false;
      try {
        PhoneNumber phoneNumber = PhoneNumber.parse(number);
        isValid = phoneNumber.isValid(type: PhoneNumberType.mobile);
        phone = phoneNumber.international;
      } catch (e) {
        debugPrint('Phone Number Parse Error: $e');
      }
    return PhoneValid(isValid: isValid, phone: phone);
  }

}

class PhoneValid {
  bool isValid;
  String phone;
  PhoneValid({required this.isValid, required this.phone});
}