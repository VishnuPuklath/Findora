import 'package:alak/common/widgets/loader.dart';
import 'package:alak/constants/global_variables.dart';
import 'package:alak/features/account/services/account_services.dart';
import 'package:alak/features/account/widgets/single_product.dart';
import 'package:alak/features/ordered_details/screens/ordered_detail_screen.dart';
import 'package:alak/models/order.dart';
import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List<Order>? orders;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchOrders();
  }

  AccountServices accountServices = AccountServices();
  void fetchOrders() async {
    orders = await accountServices.fetchMyOrders(context: context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return orders == null
        ? const Loader()
        : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      'Your Orders',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 15),
                    child: Text(
                      'see all',
                      style:
                          TextStyle(color: GlobalVariables.selectedNavBarColor),
                    ),
                  ),
                ],
              ),
              Container(
                height: 170,
                padding: const EdgeInsets.only(left: 15, top: 20, right: 0),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: orders!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                            context, OrderedDetailScreen.routeName,
                            arguments: orders![index]);
                      },
                      child: SingleProduct(
                          image: orders![index].products[0].images[0]),
                    );
                  },
                ),
              )
            ],
          );
  }
}
