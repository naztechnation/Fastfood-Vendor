import 'package:sixam_mart_store/features/store/domain/models/attr.dart';
import 'package:flutter/material.dart';

class AttributeModel {
  Attr attribute;
  bool active;
  TextEditingController controller;
  List<String> variants;

  AttributeModel({required this.attribute, required this.active, required this.controller, required this.variants});
}