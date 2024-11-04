import 'dart:io';

import 'package:alak/admin/services/admin_services.dart';
import 'package:alak/common/widgets/custom_button.dart';
import 'package:alak/common/widgets/custom_textfield.dart';
import 'package:alak/common/widgets/loader.dart';
import 'package:alak/constants/global_variables.dart';
import 'package:alak/constants/utilis.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  static const String routeName = '/add-product';
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final AdminServices adminServices = AdminServices();
  final _addProductFormKey = GlobalKey<FormState>();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  bool isLoading = false;
  List<String> productCategories = [
    'Mobiles',
    'Essentials',
    'Appliances',
    'Books',
    'Fashion'
  ];
  String category = 'Mobiles';
  List<File> images = [];
  void selectImages() async {
    var res = await pickImages();
    setState(() {
      images = res;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _productNameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          centerTitle: true,
          flexibleSpace: Container(
            decoration:
                const BoxDecoration(gradient: GlobalVariables.appBarGradient),
          ),
          title: const Text(
            'Add a Product',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      body: isLoading == true
          ? const Loader()
          : SingleChildScrollView(
              child: Form(
                  key: _addProductFormKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        images.isNotEmpty
                            ? CarouselSlider(
                                items: images
                                    .map(
                                      (e) => Builder(
                                        builder: (BuildContext context) =>
                                            Image.file(
                                          e,
                                          fit: BoxFit.cover,
                                          height: 200,
                                        ),
                                      ),
                                    )
                                    .toList(),
                                options: CarouselOptions(
                                  viewportFraction: 1,
                                  height: 200,
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  selectImages();
                                },
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(10),
                                  dashPattern: const [10, 4],
                                  strokeCap: StrokeCap.round,
                                  child: Container(
                                    width: double.infinity,
                                    height: 150,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.folder_open,
                                          size: 40,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          'Select Product Images',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey[500]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                        const SizedBox(
                          height: 30,
                        ),
                        CustomTextfield(
                            controller: _productNameController,
                            hintText: 'Product name'),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextfield(
                            maxLines: 4,
                            controller: _descriptionController,
                            hintText: 'Description'),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextfield(
                          hintText: 'Price',
                          controller: _priceController,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextfield(
                          hintText: 'Quantity',
                          controller: _quantityController,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: DropdownButton<String>(
                            onChanged: (String? item) {
                              setState(() {
                                category = item!;
                              });
                            },
                            value: category,
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                            ),
                            items: productCategories
                                .map(
                                  (String e) => DropdownMenuItem<String>(
                                    child: Text(e),
                                    value: e,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomButton(
                          text: 'Sell',
                          onTap: () {
                            setState(() {
                              isLoading = true;
                            });
                            if (_addProductFormKey.currentState!.validate() &&
                                images.isNotEmpty) {
                              adminServices.sellProduct(
                                  context: context,
                                  name: _productNameController.text.trim(),
                                  description:
                                      _descriptionController.text.trim(),
                                  price: double.parse(
                                      _priceController.text.trim()),
                                  quantity: double.parse(
                                      _quantityController.text.trim()),
                                  category: category,
                                  images: images,
                                  onSuccess: () {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  });
                            }
                          },
                        )
                      ],
                    ),
                  )),
            ),
    );
  }
}
