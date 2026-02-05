import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/employer/emp_profile/provider/exchange_name_provider.dart';
import 'package:rajemployment/utils/textstyles.dart';
import '../../../utils/textfeild.dart';

class ExchangeNameDetail extends StatefulWidget {
  const ExchangeNameDetail({super.key});

  @override
  State<ExchangeNameDetail> createState() =>
      _ExchangeNameDetailState();
}

class _ExchangeNameDetailState extends State<ExchangeNameDetail> {

 // final TextEditingController exchangeNameCtrl = TextEditingController();
  @override
  void initState() {
    super.initState();

    final provider =
    Provider.of<ExchangeNameProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {

      provider.setExchangeNameData();

      // final data = provider.userModel;
      // debugPrint("userModel => $data");

    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Exchange Name / District Employment Office",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<ExchangeNameProvider>(
          builder: (context, provider, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  _label("Exchange Name"),
                  _field(provider.exchangeNameCtrl, "Enter exchange name"),

                  const SizedBox(height: 30),
                ],
              ),
            );
          },),
    );
  }


  /// ===== Label =====
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 6),
      child: Text(
        text,
        style: Styles.mediumTextStyle(size: 14, color: kBlackColor),
      ),
    );
  }

  /// ===== Disabled Text Field =====
  Widget _field(
      TextEditingController controller,
      String hint,
      ) {
    return buildTextWithBorderField(
      controller,
      hint,
      MediaQuery.of(context).size.width,
      50,
      TextInputType.text,
      isEnabled: false,
    );
  }
}
