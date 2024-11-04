import 'dart:convert';

import 'package:alak/constants/error_handling.dart';
import 'package:alak/constants/global_variables.dart';
import 'package:alak/constants/utilis.dart';
import 'package:alak/models/product.dart';
import 'package:alak/models/user.dart';
import 'package:alak/provider/user_provider.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class CartServices {
  void removeFromCart({
    required BuildContext context,
    required Product product,
  }) async {
    final userProvider = context.read<UserProvider>();
    try {
      http.Response res = await http.delete(
        Uri.parse('$uri/api/remove-from-cart/${product.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'X-auth-token': userProvider.user.token
        },
      );

      httpErrorHandling(
          res: res,
          context: context,
          onSuccess: () {
            User user =
                userProvider.user.copyWith(cart: jsonDecode(res.body)['cart']);
            userProvider.setUserFromMOdel(user);
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
