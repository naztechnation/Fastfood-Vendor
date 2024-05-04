import 'package:flutter/material.dart';

class VariationModelBodyModel {
  TextEditingController? nameController;
  bool required;
  bool isSingle;
  TextEditingController? minController;
  TextEditingController? maxController;
  List<Option>? options;

  VariationModelBodyModel({this.nameController, this.required = false, this.isSingle = true, this.minController, this.maxController, this.options});
}

class Option {
  TextEditingController? optionNameController;
  TextEditingController? optionPriceController;

  Option({this.optionNameController, this.optionPriceController});
}