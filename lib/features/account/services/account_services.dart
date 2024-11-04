import 'dart:convert';
import 'package:alak/constants/error_handling.dart';
import 'package:alak/constants/global_variables.dart';
import 'package:alak/constants/utilis.dart';
import 'package:alak/features/auth/screens/auth_screen.dart';
import 'package:alak/models/order.dart';
import 'package:alak/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountServices {
  Future<List<Order>> fetchMyOrders({
    required BuildContext context,
  }) async {
    final userProvider = context.read<UserProvider>().user;
    List<Order> orderList = [];
    try {
      http.Response res = await http
          .get(Uri.parse('$uri/api/orders/me'), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-auth-token': userProvider.token
      });
      print(res.body);
      httpErrorHandling(
          res: res,
          context: context,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              orderList.add(
                Order.fromJson(
                  jsonEncode(jsonDecode(res.body)[i]),
                ),
              );
            }
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return orderList;
  }

  void logOut(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('X-auth-token', '');
      Navigator.pushNamedAndRemoveUntil(
        context,
        AuthScreen.routeName,
        (route) => false,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
