import 'dart:convert';
import 'package:alak/constants/error_handling.dart';
import 'package:alak/constants/global_variables.dart';
import 'package:alak/models/user.dart';
import 'package:alak/provider/user_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:alak/constants/utilis.dart';
import 'package:alak/models/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressServices {
  void saveUserAddress(
      {required BuildContext context, required String address}) async {
    final userProvider = context.read<UserProvider>();
    try {
      final http.Response res =
          await http.post(Uri.parse('$uri/api/save-user-address'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'X-auth-token': userProvider.user.token
              },
              body: jsonEncode({'address': address}));
      httpErrorHandling(
        res: res,
        context: context,
        onSuccess: () {
          User userModel = userProvider.user
              .copyWith(address: jsonDecode(res.body)['address']);
          userProvider.setUserFromMOdel(userModel);
        },
      );
    } catch (e) {
      print(e.toString());
      showSnackBar(context, e.toString());
    }
  }
  //get-all-products

  void placeOrder(
      {required BuildContext context,
      required String address,
      required double totalSum}) async {
    final userProvider = context.read<UserProvider>();
    List<Product> productList = [];
    try {
      http.Response res = await http.post(Uri.parse('$uri/api/order'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'X-auth-token': userProvider.user.token
          },
          body: jsonEncode({
            'cart': userProvider.user.cart,
            'address': address,
            'totalPrice': totalSum
          }));

      httpErrorHandling(
          res: res,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'your order have been placed');
            User user = userProvider.user.copyWith(cart: []);
            userProvider.setUserFromMOdel(user);
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //Delete product

  void deleteProduct(
      {required BuildContext context,
      required Product product,
      required VoidCallback onSuccess}) async {
    final userProvider = context.read<UserProvider>().user;
    try {
      http.Response res =
          await http.post(Uri.parse('$uri/admin/delete-products'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'X-auth-token': userProvider.token
              },
              body: jsonEncode({'id': product.id}));
      httpErrorHandling(
          res: res,
          context: context,
          onSuccess: () {
            onSuccess();
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
