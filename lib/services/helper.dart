import 'package:bumdest/components/alert.dart';
import 'package:bumdest/models/user.dart';
import 'package:bumdest/services/api.dart';
import 'package:bumdest/services/store.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helper {
  static void toast(BuildContext context, String message,
      {bool isError = false}) {
    ScaffoldMessenger.of(context)
        .showSnackBar(Alert(message, isError: isError));
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

  static String formatNumber(dynamic amount) {
    return NumberFormat.decimalPattern('id').format(amount);
  }

  static String compactNumber(int amount, { String locale = 'en' }) {
    return NumberFormat.compact(locale: locale).format(amount);
  }

  static String toRupiah(dynamic amount) {
    String str = NumberFormat.decimalPattern('id').format(amount);
    return 'Rp $str';
  }

  static String formatDate(
    String timestamp, {
    String format = 'd MMM yyyy HH:mm',
    String locale = 'id',
  }) {
    String date;

    try {
      date = DateFormat(format, locale).format(DateTime.parse(timestamp));
      return date;
    } catch (e) {
      return 'Invalid Date Format';
    }
  }
}
