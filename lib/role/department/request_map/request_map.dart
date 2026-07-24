import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/utils/textstyles.dart';
import 'provider/request_map_provider.dart';
import '../../../utils/textfeild.dart';

class RequestMapScreen extends StatefulWidget {

  const RequestMapScreen({super.key});

  @override
  State<RequestMapScreen> createState() => _RequestMapScreenState();
}

class _RequestMapScreenState extends State<RequestMapScreen> {
  @override
  void initState() {
    super.initState();



    Future.microtask(() {
      final provider = context.read<RequestMapProvider>();
      provider.clearData();
      provider.getRequestMapDetails(context);
      provider.getDMapRequestStatus(context);

      // Provider.of<RequestMapProvider>(
      //   context,
      //   listen: false,
      // ).getRequestMapDetails(context);
      //
      // Provider.of<RequestMapProvider>(
      //   context,
      //   listen: false,
      // ).clearData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RequestMapProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: kWhite,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              "D-Map Request Form",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                if (provider.statusMessage.isNotEmpty)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      border: Border.all(color: Colors.orange),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      provider.statusMessage,
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                _label("SSOID"),
                _field(
                  provider.ssoIdController,
                  "SSOID",
                  isEnabled: false,
                ),

                _label("Name"),
                _field(
                  provider.nameController,
                  "Name",
                  isEnabled: false,
                ),

                _label("Mobile No."),
                _field(
                  provider.mobileController,
                  "Mobile No.",
                  isEnabled: false,
                ),

                _label("Name As Per Aadhar"),
                _field(
                  provider.aadhaarNameController,
                  "Name As Per Aadhar",
                  isEnabled: false,
                ),

                _label("Present Department"),
                _field(
                  provider.presentDeptController,
                  "Present Department",
                  isEnabled: false,
                ),

                _label("Internship Office Department"),
                _field(
                  provider.internshipDeptController,
                  "Internship Office Department",
                  isEnabled: false,
                ),

                _label("Remarks *"),
                TextField(
                  controller: provider.remarksController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Enter Remarks",
                    filled: true,
                    fillColor: fafafaColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: provider.isSubmitEnabled
                        ? () {
                      provider.submitRequest(context);
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 6),
      child: Text(
        text,
        style: Styles.mediumTextStyle(
          size: 14,
          color: kBlackColor,
        ).copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _field(
      TextEditingController controller,
      String hint, {
        bool isEnabled = true,
      }) {
    return buildTextWithBorderField(
      controller,
      hint,
      MediaQuery.of(context).size.width,
      50,
      TextInputType.text,
      isEnabled: isEnabled,
    );
  }
}