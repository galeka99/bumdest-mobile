import 'package:bumdest/components/alert.dart';
import 'package:bumdest/models/user.dart';
import 'package:bumdest/services/api.dart';
import 'package:bumdest/services/store.dart';
import 'package:flutter/material.dart';

class Helper {
  static void toast(BuildContext context, String message, { bool isError = false }) {
    ScaffoldMessenger.of(context).showSnackBar(Alert(message, isError: isError));
  }

  static Future<void> getUserInfo(BuildContext context) async {
    try {
      Map<String, dynamic> data = await Api.get('/v1/user/info');
      UserModel user = UserModel.parse(data);
      store.user = user;
    } catch (e) {
      if (e is ApiError) {
        Helper.toast(context, e.message, isError: true); 
      } else {
        Helper.toast(context, 'Error while get user data', isError: true);
      }
    }
  }
}