import 'package:alak/constants/global_variables.dart';
import 'package:alak/features/account/widgets/below_appbar.dart';
import 'package:alak/features/account/widgets/orders.dart';
import 'package:alak/features/account/widgets/top_buttons.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient:
                      LinearGradient(colors: [Colors.black12, Colors.white30])),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    alignment: Alignment.topLeft,
                    child: const Text(
                      'Findora',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Container(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Icon(Icons.notifications_outlined),
                      ),
                      Icon(Icons.search)
                    ],
                  ),
                )
              ],
            ),
          )),
      body: const Column(
        children: [
          BelowAppbar(),
          SizedBox(height: 10),
          TopButtons(),
          SizedBox(height: 20),
          Orders()
        ],
      ),
    );
  }
}
