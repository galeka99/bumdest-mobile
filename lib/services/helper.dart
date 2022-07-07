import 'package:bumdest/components/alert.dart';
import 'package:flutter/material.dart';

class Helper {
  static void toast(BuildContext context, String message, { bool isError = false }) {
    ScaffoldMessenger.of(context).showSnackBar(Alert(message, isError: isError));
  }
}