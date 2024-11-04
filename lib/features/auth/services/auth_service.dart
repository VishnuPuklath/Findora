import 'dart:convert';
import 'package:alak/admin/screens/admin_screen.dart';
import 'package:alak/common/widgets/bottom_bar.dart';
import 'package:alak/constants/error_handling.dart';
import 'package:alak/constants/global_variables.dart';
import 'package:alak/constants/utilis.dart';
import 'package:alak/models/user.dart';
import 'package:alak/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  //signup
  void signupUser(
      {required String name,
      required String email,
      required String password,
      required BuildContext context}) async {
    try {
      User user = User(
          id: '',
          name: name,
          email: email,
          password: password,
          address: '',
          type: '',
          token: '',
          cart: []);
      final Response res = await http.post(Uri.parse('$uri/api/signup'),
          body: user.toJson(),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });

      httpErrorHandling(
          res: res,
          context: context,
          onSuccess: () {
            showSnackBar(
                context, 'Account created! Please signin with same credential');
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //signin

  void signin(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      final res = await http.post(Uri.parse('$uri/api/signin'),
          body: jsonEncode({"email": email, "password": password}),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      httpErrorHandling(
          res: res,
          context: context,
          onSuccess: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString(
                'X-auth-token', jsonDecode(res.body)['token']);
            context.read<UserProvider>().setUser(res.body);
            final user = context.read<UserProvider>().user;
            if (user.type == 'user') {
              Navigator.pushNamedAndRemoveUntil(
                context,
                BottomBar.routeName,
                (route) => false,
              );
            } else if (user.type == 'admin') {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AdminScreen.routeName,
                (route) => false,
              );
            }
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //Get the user data

  Future<void> getUserData(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('X-auth-token');

      if (token == null) {
        prefs.setString('X-auth-token', '');
      }

      var tokenRes = await http.post(
          Uri.parse(
            '$uri/isTokenValid',
          ),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'X-auth-token': token!
          });
      var response = jsonDecode(tokenRes.body);
      if (response == true) {
        http.Response userRes = await http.post(Uri.parse('$uri/'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'X-auth-token': token
            });
        context.read<UserProvider>().setUser(userRes.body);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
