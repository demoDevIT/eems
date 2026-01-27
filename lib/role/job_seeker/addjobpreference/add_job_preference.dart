import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/job_seeker/addjobpreference/provider/add_job_preference_provider.dart';

import '../../../utils/dropdown.dart';
import '../../../utils/global.dart';
import '../../../utils/textfeild.dart';
import '../../../utils/textstyles.dart';
import '../jobpreference/modal/job_preference_modal.dart';
import '../loginscreen/provider/locale_provider.dart';

class AddJobPreferenceScreen extends StatefulWidget {
  bool isUpdate;
  JobPreferenceData? jobPreferenceData;
  AddJobPreferenceScreen({super.key, required this.isUpdate,required this.jobPreferenceData});

  @override
  State<AddJobPreferenceScreen> createState() => _AddJobPreferenceScreenState(isUpdate,jobPreferenceData);
}

class _AddJobPreferenceScreenState extends State<AddJobPreferenceScreen> {
  bool isUpdate;
  JobPreferenceData? jobPreferenceData;
  _AddJobPreferenceScreenState(this.isUpdate,this.jobPreferenceData);

  String _formatRupee(double v) {
    int n = v.round();
    final s = n.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      buffer.write(s[i]);
      count++;
      if (count == 3 && i != 0) {
        buffer.write(',');
        count = 0;
      }
    }
    return '₹' + buffer.toString().split('').reversed.join();
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<AddJobPreferenceProvider>(context, listen: false);
      provider.clearData();
      provider.ncoCodeApi(context,isUpdate,jobPreferenceData);

    });
  }


  @override
  Widget build(BuildContext context) {
    const double fieldSpacing = 18;
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final provider = Provider.of<AddJobPreferenceProvider>(context, listen: false);

    return Scaffold(
        appBar: commonAppBar2(isUpdate == true ? "Update Job-Preference" : "Add Job-Preference", context,
            localeProvider.currentLanguage, "", false, "", onTapClick: () {
              localeProvider.toggleLocale();
            }),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 0, bottom: 10),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              if(provider.preferredLocationIdController.text.isEmpty){
                showAlertError("Please select preferred location", context);

              }
              else{
                confirmAlertDialog(context, "Alert","Are you sure want to submit ?", (value) {
                  if (value.toString() == "success") {
                    provider.saveJobPreferenceApi(context,isUpdate,jobPreferenceData != null ? jobPreferenceData!.jobPreferenceID.toString():"" );
                  }
                },
                );
              }

            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            ),
            child:  Text(isUpdate == true ? 'Update' : 'Add', style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ),
      ),

        body: Consumer<AddJobPreferenceProvider>(builder: (context, provider, child) {
          return  SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Kindly choose a job preference that matches your qualification or work experience.",
                      style: Styles.mediumTextStyle(size: 12,color: kRedColor),),
                    const SizedBox(height: 14),


                    // Sector
                    labelWithStar('Sector'),
                    const SizedBox(height: 8),
                    IgnorePointer(

                      ignoring: false,
                      child: buildDropdownWithBorderField(
                        items: provider.sectorList,
                        controller: provider.sectorNameController,
                        idController: provider.sectorIdController,
                        hintText: "--Select Option--",
                        height: 50,
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        onChanged: (value) {

                        },
                      ),
                    ),


                    SizedBox(height: fieldSpacing),

                    // Preferred Location
                    labelWithStar('Preferred Location',required: true),
                    const SizedBox(height: 8),
                    IgnorePointer(

                      ignoring: false,
                      child: buildDropdownWithBorderField(
                        items: provider.preferredLocationList,
                        controller: provider.preferredLocationNameController,
                        idController: provider.preferredLocationIdController,
                        hintText: "--Select Option--",
                        height: 50,
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        onChanged: (value) {

                        },
                      ),
                    ),

                    SizedBox(height: fieldSpacing),

                    // Desired Employment Type
                    labelWithStar('Desired Employment Type'),
                    const SizedBox(height: 8),

                    IgnorePointer(

                      ignoring: false,
                      child: buildDropdownWithBorderField(
                        items: provider.employmentTypeList,
                        controller: provider.employmentTypeNameController,
                        idController: provider.employmentTypeIdController,
                        hintText: "--Select Option--",
                        height: 50,
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        onChanged: (value) {

                        },
                      ),
                    ),

                    SizedBox(height: fieldSpacing),

                    // Desired Job Type (text field)
                    labelWithStar('Desired Job Type'),
                    const SizedBox(height: 8),
                    IgnorePointer(

                      ignoring: false,
                      child: buildDropdownWithBorderField(
                        items: provider.jobTypeList,
                        controller: provider.jobTypeNameController,
                        idController: provider.jobTypeIdController,
                        hintText: "--Select Option--",
                        height: 50,
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        onChanged: (value) {

                        },
                      ),
                    ),



                    SizedBox(height: fieldSpacing),

                    // Salary range (RangeSlider)
                    Text('Expected Salary Range (Monthly)', style: Styles.semiBoldTextStyle(
                        color: kBlackColor, size: 14),),
                    const SizedBox(height: 12),
                    RangeSlider(
                      values: provider.salaryRange,
                      min: 5000,
                      max: 200000,
                      divisions: 90,
                      labels: RangeLabels(_formatRupee(provider.salaryRange.start), _formatRupee(provider.salaryRange.end)),
                      activeColor: const Color(0xFF2563EB),
                      onChanged: (RangeValues newRange) {
                        setState(() => provider.salaryRange = newRange);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_formatRupee(provider.salaryRange.start), style: Styles.semiBoldTextStyle(
                              color: kBlackColor, size: 14),),
                          Text(_formatRupee(provider.salaryRange.end), style:Styles.semiBoldTextStyle(
                              color: kBlackColor, size: 14),),
                        ],
                      ),
                    ),
                    const SizedBox(height: fieldSpacing),

                    // Shift
                    labelWithStar('Shift'),
                    const SizedBox(height: 8),

                    IgnorePointer(

                      ignoring: false,
                      child: buildDropdownWithBorderField(
                        items: provider.shiftList,
                        controller: provider.shiftNameController,
                        idController: provider.shiftIdController,
                        hintText: "--Select Option--",
                        height: 50,
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        onChanged: (value) {

                        },
                      ),
                    ),

                    SizedBox(height: fieldSpacing),

                    // NCO Code with red star required
                    labelWithStar('NCO Code', required: true),
                    const SizedBox(height: 8),
                    IgnorePointer(
                      ignoring: false,
                      child: buildDropdownWithBorderField(
                        items: provider.ncoCodeList,
                        controller: provider.ncoCodeNameController,
                        idController: provider.ncoCodeIdController,
                        hintText: "--Select Option--",
                        height: 50,
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        onChanged: (value) {

                        },
                      ),
                    ),
                    Text("Please select the NCO code based on your Job Preference.",
                      style: Styles.mediumTextStyle(size: 12,color: kRedColor),),

                    const SizedBox(height:8),

                    // International jobs radio
                    Text('Are you interested in International Jobs?', style: Styles.regularTextStyle(color: kBlackColor, size: 14),),
                    const SizedBox(height: 8),
                    Row(
                      children: ['Yes', 'No'].map((opt) {
                        final bool selected = provider.international == opt;
                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Row(
                            children: [
                              Radio<String>(
                                value: opt,
                                groupValue: provider.international,
                                activeColor: const Color(0xFF2563EB),
                                onChanged: (v) => setState(() => provider.international = v ?? provider.international),
                              ),
                              Text(opt, style: Styles.regularTextStyle(
                                  color:  selected ? Colors.black : Colors.black87, size: 14), ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 8), // spacing so content doesn't hide behind button


                    provider.international == "Yes" ? labelWithStar('Preferred Region', required: true) : SizedBox(),
                    provider.international == "Yes" ? const SizedBox(height: 8) : SizedBox(),
                    provider.international == "Yes" ? IgnorePointer(

                      ignoring: false,
                      child: buildDropdownWithBorderField(
                        items: provider.preferredRegionList,
                        controller: provider.preferredRegionNameController,
                        idController: provider.preferredRegionIdController,
                        hintText: "--Select Option--",
                        height: 50,
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        onChanged: (value) {

                        },
                      ),
                    ) : SizedBox(),


                    provider.international == "Yes" ? labelWithStar('Foreign Language Known', required: false) : SizedBox(),
                    provider.international == "Yes" ? const SizedBox(height: 8) : SizedBox(),
                    provider.international == "Yes" ? IgnorePointer(
                      ignoring: false,
                      child: buildDropdownWithBorderField(
                        items: provider.languageKnownList,
                        controller: provider.languageKnownNameController,
                        idController: provider.languageKnownIdController,
                        hintText: "--Select Option--",
                        height: 50,
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        onChanged: (value) {

                        },
                      ),
                    ) : SizedBox(),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          );
        }));



  }
}
