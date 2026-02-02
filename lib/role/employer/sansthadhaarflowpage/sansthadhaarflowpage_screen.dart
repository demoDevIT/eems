import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/utils/gradient_scaffold.dart';
import 'package:rajemployment/utils/size_config.dart';
import 'package:rajemployment/utils/utility_class.dart';
import '../../../utils/textfeild.dart';
import '../empotr_form/empotr_form.dart';
import 'provider/sansthadhaarflow_provider.dart';
import 'package:flutter/services.dart';

class SansthaAadhaarFlowPage extends StatefulWidget {
  final String ssoId;
  final String userID;

  const SansthaAadhaarFlowPage({
    super.key,
    required this.ssoId,
    required this.userID,
  });

  @override
  State<SansthaAadhaarFlowPage> createState() =>
      _SansthaAadhaarFlowPageState();
}

class _SansthaAadhaarFlowPageState extends State<SansthaAadhaarFlowPage> {

  @override
  void initState() {
    super.initState();

    // Reset provider when page is (re)opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SansthaAadhaarFlowProvider>().clearData();
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: backgroundGradient5,
        ),
        child: Consumer<SansthaAadhaarFlowProvider>(
          builder: (context, provider, child) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  const SizedBox(height: 60),

                  /// Logo
                  Center(
                    child: Image.asset(
                      "assets/logos/logo.png",
                      height: 100,
                    ),
                  ),

                  SizedBox(height: SizeConfig.screenHeight! * 0.04),

                  /// Main Card
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Heading
                          Center(
                            child: Text(
                              "Enter Sanstha Aadhaar / BRN Number",
                              textAlign: TextAlign.center,
                              style: UtilityClass.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),

                          SizedBox(height: SizeConfig.screenHeight! * 0.03),

                          /// Radio Question
                          Text(
                            "Do you have a BRN Number?",
                            style: UtilityClass.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),

                          Row(
                            children: [
                              Radio<bool>(
                                value: true,
                                groupValue: provider.hasBrn,
                                onChanged: (value) {
                                  provider.setHasBrn(value!);
                                },
                              ),
                              const Text("Yes"),
                              Radio<bool>(
                                value: false,
                                groupValue: provider.hasBrn,
                                onChanged: (value) {
                                  // provider.setHasBrn(value!);
                                  provider.clearData();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EmpOTRFormScreen(
                                        ssoId: widget.ssoId,
                                        userID: widget.userID,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const Text("No"),
                            ],
                          ),

                          SizedBox(height: SizeConfig.screenHeight! * 0.02),

                          /// Input Field
                          buildTextWithBorderField(
                            provider.sansthaAadhaarController,
                            "Enter Sanstha Aadhaar",
                            MediaQuery.of(context).size.width,
                            50,
                            TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,   // ✅ only numbers
                              LengthLimitingTextInputFormatter(16),     // ✅ max 16 digits
                            ],
                          ),

                          SizedBox(height: SizeConfig.screenHeight! * 0.03),

                          /// Submit Button
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryDark,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                provider.submitSansthaAadhaarApi(
                                  context,
                                  widget.ssoId,
                                  widget.userID,
                                );
                              },
                              child: Text(
                                "Submit",
                                style: UtilityClass.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
