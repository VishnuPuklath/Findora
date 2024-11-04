import 'dart:convert';

import 'package:alak/constants/error_handling.dart';
import 'package:alak/constants/global_variables.dart';
import 'package:alak/constants/utilis.dart';
import 'package:alak/models/product.dart';
import 'package:alak/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HomeServices {
  Future<List<Product>> fetchCategoryProducts(
      {required BuildContext context, required String category}) async {
    final userProvider = context.read<UserProvider>().user;
    List<Product> productList = [];
    try {
      print(category);
      http.Response res = await http.get(
          Uri.parse('$uri/api/products?category=$category'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'X-auth-token': userProvider.token
          });
      print(res.body);
      httpErrorHandling(
          res: res,
          context: context,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              productList.add(
                Product.fromJson(
                  jsonEncode(jsonDecode(res.body)[i]),
                ),
              );
            }
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return productList;
  }

  Future<Product> fetchDealOfDay({required BuildContext context}) async {
    final userProvider = context.read<UserProvider>().user;
    Product product = Product(
        name: '',
        description: '',
        quantity: 0,
        images: [],
        category: '',
        price: 0);
    try {
      http.Response res = await http
          .get(Uri.parse('$uri/api/deal-of-day'), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-auth-token': userProvider.token
      });
      print(res.body);
      httpErrorHandling(
          res: res,
          context: context,
          onSuccess: () {
            product = Product.fromJson(res.body);
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return product;
  }
}
