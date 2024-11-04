import 'package:alak/admin/screens/add_product_screen.dart';
import 'package:alak/admin/services/admin_services.dart';
import 'package:alak/common/widgets/loader.dart';
import 'package:alak/constants/global_variables.dart';
import 'package:alak/features/account/widgets/single_product.dart';
import 'package:alak/models/product.dart';
import 'package:flutter/material.dart';

class PostsScreen extends StatefulWidget {
  static const String routeName = '/post-screen';
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List<Product>? products;
  final AdminServices adminServices = AdminServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAllProducts();
  }

  void navigateToAddProduct() {
    Navigator.pushNamed(context, AddProductScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: products == null
          ? const Loader()
          : GridView.builder(
              itemCount: products!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) {
                final productData = products![index];
                return Column(
                  children: [
                    SizedBox(
                      height: 140,
                      child: SingleProduct(image: productData.images[0]),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                            child: Text(
                          productData.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        )),
                        IconButton(
                            onPressed: () {
                              deleteProduct(product: productData, index: index);
                            },
                            icon: const Icon(Icons.delete_outline_outlined))
                      ],
                    )
                  ],
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        shape: const StadiumBorder(),
        tooltip: 'Add a product',
        onPressed: navigateToAddProduct,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void fetchAllProducts() async {
    products = await adminServices.fetchAllProduct(context);
    setState(() {});
  }

  void deleteProduct({required Product product, required int index}) {
    adminServices.deleteProduct(
        context: context,
        product: product,
        onSuccess: () {
          setState(() {
            products!.removeAt(index);
          });
        });
  }
}
