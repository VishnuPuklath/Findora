import 'package:alak/admin/models/sales.dart';
import 'package:alak/admin/services/admin_services.dart';
import 'package:alak/admin/widgets/category_product_chart.dart';
import 'package:alak/common/widgets/loader.dart';
import 'package:flutter/material.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final AdminServices adminServices = AdminServices();
  int? totalSales;
  List<Sales>? earnings;

  @override
  void initState() {
    super.initState();
    getEarnings();
  }

  getEarnings() async {
    var earningData = await adminServices.getEarnings(context);
    totalSales = earningData['totalEarnings'];
    earnings = earningData['sales'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return earnings == null || totalSales == null
        ? const Loader()
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text('\$$totalSales'),
                  SizedBox(
                    height: 600,
                    child: CategoryProductsChart(
                      earnings: earnings!,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
