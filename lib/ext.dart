import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

extension ContextExt on BuildContext {
  bool get isMyanmar => locale.languageCode == "my";
}
