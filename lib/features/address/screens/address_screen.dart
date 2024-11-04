import 'package:alak/common/widgets/custom_textfield.dart';
import 'package:alak/constants/global_variables.dart';
import 'package:alak/constants/utilis.dart';
import 'package:alak/features/address/services/address_services.dart';
import 'package:alak/payment_configurations.dart';
import 'package:alak/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  final String totalAmount;
  static const String routeName = '/address-screen';
  const AddressScreen({super.key, required this.totalAmount});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final AddressServices addressServices = AddressServices();
  final TextEditingController _flatBuildingController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  void onGooglePayResult(res) {
    if (context.read<UserProvider>().user.address.isEmpty) {
      addressServices.saveUserAddress(
          context: context, address: addressToBeUsed);
    }
    addressServices.placeOrder(
        context: context,
        address: addressToBeUsed,
        totalSum: double.parse(widget.totalAmount));
  }

  void payPressed(String addressFromProvider) {
    addressToBeUsed = "";
    bool isForm = _flatBuildingController.text.isNotEmpty ||
        _areaController.text.isNotEmpty ||
        _pincodeController.text.isNotEmpty ||
        _cityController.text.isNotEmpty;
    if (isForm) {
      if (_addressFormKey.currentState!.validate()) {
        addressToBeUsed =
            '${_flatBuildingController.text},${_areaController.text},${_cityController.text},${_pincodeController.text}';
      } else {
        throw Exception('Please enter all fields');
      }
    } else if (addressFromProvider.isNotEmpty) {
      addressToBeUsed = addressFromProvider;
    } else {
      showSnackBar(context, 'Error');
    }
  }

  List<PaymentItem> paymentItems = [];
  String addressToBeUsed = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    paymentItems.add(PaymentItem(
      amount: widget.totalAmount,
      label: 'Total Amount',
      status: PaymentItemStatus.final_price,
    ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _flatBuildingController.dispose();
    _areaController.dispose();
    _pincodeController.dispose();
    _pincodeController.dispose();
    _cityController.dispose();
  }

  final _addressFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var address = context.watch<UserProvider>().user.address;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            flexibleSpace: Container(
              decoration:
                  const BoxDecoration(gradient: GlobalVariables.appBarGradient),
            ),
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (address.isNotEmpty)
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          address,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'OR',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              Form(
                  key: _addressFormKey,
                  child: Column(
                    children: [
                      CustomTextfield(
                        hintText: 'Flat,House No,Building',
                        controller: _flatBuildingController,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextfield(
                        hintText: 'Area,Street',
                        controller: _areaController,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextfield(
                        hintText: 'Pincode',
                        controller: _pincodeController,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextfield(
                        hintText: 'Town/city',
                        controller: _cityController,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  )),
              GooglePayButton(
                  onPressed: () {
                    payPressed(address);
                  },
                  type: GooglePayButtonType.buy,
                  margin: const EdgeInsets.only(top: 15),
                  loadingIndicator: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  height: 50,
                  onPaymentResult: onGooglePayResult,
                  paymentConfiguration:
                      PaymentConfiguration.fromJsonString(defaultGooglePay),
                  paymentItems: paymentItems)
            ],
          ),
        ),
      ),
    );
  }
}
