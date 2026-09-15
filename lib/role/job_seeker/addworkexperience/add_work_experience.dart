import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/job_seeker/addworkexperience/provider/add_work_experience_provider.dart';
import 'package:rajemployment/utils/textfeild.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/dropdown.dart';
import '../../../utils/global.dart';
import '../../../utils/textstyles.dart';
import '../loginscreen/provider/locale_provider.dart';
import '../workexperience/modal/delete_work_experience_list_modal.dart';
import 'modal/city_modal.dart';
import 'modal/district_modal.dart';
import 'modal/state_modal.dart';

class AddWorkExperienceScreen extends StatefulWidget {
  bool isUpdate;
  WorkExperienceListData? workExperienceListData;
  final bool hideExperienceQuestion; // new
  final List<WorkExperienceListData> existingExperiences;

  AddWorkExperienceScreen(
      {super.key,
      required this.isUpdate,
      required this.workExperienceListData,
      this.hideExperienceQuestion = false,
        required this.existingExperiences
      });

  @override
  State<AddWorkExperienceScreen> createState() =>
      _AddWorkExperienceScreenState(isUpdate, workExperienceListData);
}

class _AddWorkExperienceScreenState extends State<AddWorkExperienceScreen> {
  bool isUpdate;
  WorkExperienceListData? workExperienceListData;

  _AddWorkExperienceScreenState(this.isUpdate, this.workExperienceListData);

  @override
  void initState() {
    super.initState();

    final provider =
        Provider.of<AddWorkExperienceProvider>(context, listen: false);

    // if (widget.hideExperienceQuestion || widget.isUpdate) {
    //   provider.experienceTypes = "Yes";
    //   provider.employedInPastController.text = "Yes";
    //   provider.employmentFilterList();
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     setState(() {});
    //   });
    // }

    SchedulerBinding.instance.addPostFrameCallback((_) async {

      if (workExperienceListData != null) {
        debugPrint(
          "WorkExperienceListData => ${workExperienceListData.toString()}",
        );
      }

      provider.clearData();

      // Call only 1st API
      await provider.initWorkExperienceApis(
        context,
        widget.isUpdate,
        widget.workExperienceListData,
        hideExperienceQuestion: widget.hideExperienceQuestion || widget.isUpdate,
      );
      //setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    return Scaffold(
        appBar: commonAppBar2(
            isUpdate == true ? AppLocalizations.of(context)!.updateWorkExp : AppLocalizations.of(context)!.addWorkExp,
            context,
            localeProvider.currentLanguage,
            "",
            false,
            "", onTapClick: () {
          localeProvider.toggleLocale();
        }),
        body: Consumer<AddWorkExperienceProvider>(
            builder: (context, provider, child) {
              bool showWorkForm =
                  provider.experienceTypes == "Yes" &&
                      provider.employmentTypeIdController.text.isNotEmpty &&
                      !(provider.employmentTypeIdController.text == "6" &&
                          provider.employedInPastController.text == "No");

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!widget.hideExperienceQuestion) ...[
                    const SizedBox(height: 10),
                    labelWithStar(AppLocalizations.of(context)!.areYouExp,
                        required: true),
                    Row(
                      children: provider.experienceTypesList.map((type) {
                        return Row(
                          children: [
                            Radio<String>(
                              value: type,
                              groupValue: provider.experienceTypes,
                              onChanged: (val) {
                                provider.experienceTypes =
                                    val ?? provider.experienceTypes;
                                // CLEAR selection BEFORE filtering
                                provider.employmentTypeNameController.clear();
                                provider.employmentTypeIdController.clear();
                                provider.employmentFilterList();
                                if (val == "No") {
                                  provider.employedInPastController.text = "No";
                                  //provider.employmentTypeIdController.text = "";
                                }
                                setState(() {});
                              },
                            ),
                            Text(
                              type,
                              style: Styles.mediumTextStyle(
                                  color: kBlackColor, size: 14),
                            ),
                            const SizedBox(width: 12),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                  hSpace(10),
                  labelWithStar(AppLocalizations.of(context)!.empType, required: true),
                  IgnorePointer(
                    ignoring: false,
                    child: buildDropdownWithBorderField(
                      items: provider.employmentTypesList,
                      controller: provider.employmentTypeNameController,
                      idController: provider.employmentTypeIdController,
                      hintText: AppLocalizations.of(context)!.selOption,
                      height: 50,
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                  provider.experienceTypes == "Yes" &&
                          provider.employmentTypeIdController.text == "6"
                      ? hSpace(20)
                      : hSpace(0),
                  provider.experienceTypes == "Yes" &&
                          provider.employmentTypeIdController.text == "6"
                      ? labelWithStar(AppLocalizations.of(context)!.haveYouEmpPast,
                          required: true)
                      : SizedBox(),
                  provider.experienceTypes == "Yes" &&
                          provider.employmentTypeIdController.text == "6"
                      ? Row(
                          children: provider.experienceTypesList.map((type) {
                            return Row(
                              children: [
                                Radio<String>(
                                  value: type,
                                  groupValue:
                                      provider.employedInPastController.text,
                                  onChanged: (val) {
                                    provider.employedInPastController.text =
                                        val ??
                                            provider
                                                .employedInPastController.text;
                                    print("-experienceTypes--> " +
                                        provider.experienceTypes);
                                    print("-TypeId--> " +
                                        provider
                                            .employmentTypeIdController.text);
                                    print("-Past--> " +
                                        provider.employedInPastController.text);
                                    setState(() {});
                                  },
                                ),
                                Text(
                                  type,
                                  style: Styles.mediumTextStyle(
                                      color: kBlackColor, size: 14),
                                ),
                                SizedBox(width: 12),
                              ],
                            );
                          }).toList(),
                        )
                      : SizedBox(),
                  hSpace(20),

              showWorkForm ? Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  labelWithStar(AppLocalizations.of(context)!.addWorkExp),

                                  hSpace(10),
                                  labelWithStar(AppLocalizations.of(context)!.jobTitle, required: true),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 5),
                                    child: buildTextWithBorderField(
                                      provider.jobTitleNameController,
                                      AppLocalizations.of(context)!.enterJobTitle,
                                      MediaQuery.of(context).size.width,
                                      50,
                                      TextInputType.text,
                                    ),
                                  ),

                                  hSpace(10),
                                  labelWithStar(AppLocalizations.of(context)!.companyName, required: true),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 5),
                                    child: buildTextWithBorderField(
                                      provider.companyNameController,
                                      AppLocalizations.of(context)!.enterCompanyName,
                                      MediaQuery.of(context).size.width,
                                      50,
                                      TextInputType.text,
                                    ),
                                  ),

                                  labelWithStar(
                                      AppLocalizations.of(context)!.areYouWorkComp,
                                      required: true),
                                  Row(
                                    children:
                                        provider.workingCompanyList.map((type) {
                                      return Row(
                                        children: [
                                          Radio<String>(
                                            value: type,
                                            groupValue: provider.workingCompanyType,
                                            onChanged: (val) {
                                              setState(() {
                                                provider.workingCompanyType =
                                                    val ?? provider.workingCompanyType;

                                                // ✅ If still working, clear "To" date
                                                if (provider.workingCompanyType == "Yes") {
                                                  provider.toDateController.clear();
                                                }
                                              });
                                            },
                                          ),

                                          Text(
                                            type,
                                            style: Styles.mediumTextStyle(
                                                color: kBlackColor, size: 14),
                                          ),
                                          const SizedBox(width: 12),
                                        ],
                                      );
                                    }).toList(),
                                  ),

                                  hSpace(10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.90 /
                                                2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            labelWithStar(AppLocalizations.of(context)!.fromDate,
                                                required: true),
                                            InkWell(
                                              onTap: () {
                                                FocusScope.of(context)
                                                    .requestFocus(
                                                        new FocusNode());
                                                showDatePickerDialog(
                                                  context,
                                                  provider.fromDateController,
                                                  DateTime.now(), // initialDate
                                                  DateTime(DateTime.now().year -
                                                      1), // firstDate
                                                  DateTime.now(), // lastDate
                                                ).then((_) {
                                                  setState(() {});
                                                }).catchError((error) {
                                                  setState(() {});
                                                });
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0,
                                                        vertical: 5),
                                                child: buildTextWithBorderField(
                                                    provider.fromDateController,
                                                    AppLocalizations.of(context)!.selFrom,
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                    50,
                                                    TextInputType.text,
                                                    isEnabled: false,
                                                    postfixIcon: Icon(
                                                      Icons.calendar_month,
                                                      color: kDartGrayColor,
                                                    )),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.90 /
                                                2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            labelWithStar(AppLocalizations.of(context)!.endDate,
                                                required: true),
                                            InkWell(
                                              onTap: provider.workingCompanyType == "Yes"
                                                  ? null
                                                  : () {
                                                FocusScope.of(context).requestFocus(FocusNode());
                                                showDatePickerDialog(
                                                  context,
                                                  provider.toDateController,
                                                  DateTime.now(),
                                                  DateTime(DateTime.now().year - 1),
                                                  DateTime.now(),
                                                ).then((_) {
                                                  setState(() {});
                                                }).catchError((error) {
                                                  setState(() {});
                                                });
                                              },

                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0,
                                                        vertical: 5),
                                                child: buildTextWithBorderField(
                                                    provider.toDateController,
                                                    AppLocalizations.of(context)!.selectTo,
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                    50,
                                                    TextInputType.text,
                                                    isEnabled: false,
                                                    postfixIcon: Icon(
                                                      Icons.calendar_month,
                                                      color: kDartGrayColor,
                                                    )),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  hSpace(20),

                                  Text(
                                    AppLocalizations.of(context)!.location,
                                    style: Styles.mediumTextStyle(
                                      color: kBlackColor,
                                      size: 16,
                                      //fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  hSpace(10),
                                  labelWithStar(AppLocalizations.of(context)!.state, required: true),
                                  IgnorePointer(
                                    ignoring: false,
                                    child:
                                        buildDropdownWithBorderFieldOnlyThisPage<
                                            StateData>(
                                      items: provider.stateList,
                                      controller: provider.stateNameController,
                                      idController: provider.stateIdController,
                                      hintText: AppLocalizations.of(context)!.selState,
                                      height: 50,
                                      selectedValue: provider.selectedState,
                                      // ✅
                                      onChanged: (value) {
                                        provider.selectedState = value;

                                        provider.stateNameController.text =
                                            value?.name ?? "";
                                        provider.stateIdController.text =
                                            value?.iD.toString() ?? "";

                                        provider.districtList.clear();
                                        provider.selectedDistrict = null;
                                        provider.districtNameController.clear();
                                        provider.districtIdController.clear();

                                        provider.locationList.clear();
                                        provider.selectedCity = null;
                                        provider.locationNameController.clear();
                                        provider.locationIdController.clear();

                                        provider.getDistrictApi(
                                            context, value!.iD!);
                                        provider.notifyListeners(); // ✅
                                      },
                                    ),
                                  ),

                                  hSpace(10),
                                  labelWithStar(AppLocalizations.of(context)!.district, required: true),

                                  provider.isDistrictLoading
                                      ? const Center(
                                          child: CircularProgressIndicator())
                                      : IgnorePointer(
                                          ignoring:
                                              provider.districtList.isEmpty,
                                          child:
                                              buildDropdownWithBorderFieldOnlyThisPage<
                                                  DistrictData>(
                                            items: provider.districtList,
                                            controller:
                                                provider.districtNameController,
                                            idController:
                                                provider.districtIdController,
                                            hintText: AppLocalizations.of(context)!.selectDistrict,
                                            height: 50,
                                            selectedValue:
                                                provider.selectedDistrict,
                                            onChanged: (value) {
                                              provider.selectedDistrict = value;

                                              provider.districtNameController
                                                  .text = value?.name ?? "";
                                              provider.districtIdController
                                                      .text =
                                                  value?.iD.toString() ?? "";

                                              // ✅ MUST CLEAR CITY SELECTION FIRST
                                              provider.selectedCity = null;
                                              provider.locationList.clear();
                                              provider.locationNameController
                                                  .clear();
                                              provider.locationIdController
                                                  .clear();

                                              provider.getCityApi(
                                                  context, value!.code!);

                                              provider.notifyListeners();
                                            },
                                          ),
                                        ),

                                  hSpace(10),
                                  labelWithStar(AppLocalizations.of(context)!.city, required: true),
                                  // Padding(
                                  //   padding:
                                  //   const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                                  //   child: buildTextWithBorderField(
                                  //     provider.locationController,
                                  //     "Enter Location ",
                                  //     MediaQuery.of(context).size.width,
                                  //     50,
                                  //     TextInputType.text,
                                  //   ),
                                  // ),

                                  IgnorePointer(
                                    ignoring: false,
                                    child:
                                        buildDropdownWithBorderFieldOnlyThisPage<
                                            CityData>(
                                      items: provider.locationList,
                                      controller:
                                          provider.locationNameController,
                                      idController:
                                          provider.locationIdController,
                                      hintText: AppLocalizations.of(context)!.selLocation,
                                      height: 50,
                                      selectedValue: provider.selectedCity,
                                      onChanged: (value) {
                                        provider.selectedCity = value;

                                        provider.locationNameController.text =
                                            value?.nameEng ?? "";
                                        provider.locationIdController.text =
                                            value?.iD.toString() ?? "";

                                        provider.notifyListeners();
                                      },
                                    ),
                                  ),

                                  hSpace(10),
                                  labelWithStar(AppLocalizations.of(context)!.jobbType, required: true),
                                  IgnorePointer(
                                    ignoring: false,
                                    child: buildDropdownWithBorderField(
                                      items: provider.jobTypeList,
                                      controller:
                                          provider.jobTypeNameController,
                                      idController:
                                          provider.jobTypeIdController,
                                      hintText: AppLocalizations.of(context)!.selOption,
                                      height: 50,
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                      onChanged: (value) {},
                                    ),
                                  ),

                                  hSpace(10),
                                  labelWithStar(AppLocalizations.of(context)!.natureEmp,
                                      required: true),
                                  IgnorePointer(
                                    ignoring: false,
                                    child: buildDropdownWithBorderField(
                                      items: provider.natureEmploymentList,
                                      controller: provider
                                          .employmentNatureNameController,
                                      idController:
                                          provider.employmentNatureIdController,
                                      hintText: AppLocalizations.of(context)!.selOption,
                                      height: 50,
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                      onChanged: (value) {},
                                    ),
                                  ),

                                  hSpace(10),
                                  labelWithStar(AppLocalizations.of(context)!.ncoCode, required: true),
                                  IgnorePointer(
                                    ignoring: false,
                                    child: buildDropdownWithBorderField(
                                      items: provider.ncoCodeList,
                                      controller: provider.ncoNameController,
                                      idController: provider.ncoIdController,
                                      hintText: AppLocalizations.of(context)!.selOption,
                                      height: 50,
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                      onChanged: (value) {},
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),
                  hSpace(30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: () {
                        if (validateWorkExperienceForm(context, provider)) {
                          confirmAlertDialog(
                            context,
                            AppLocalizations.of(context)!.alert,
                            AppLocalizations.of(context)!.areYouSureSubmitForm,
                            (value) {
                              if (value.toString() == "success") {
                                provider.saveWorkExperienceApi(
                                    context,
                                    isUpdate,
                                    workExperienceListData != null
                                        ? workExperienceListData!.employmentID
                                            .toString()
                                        : "");
                              }
                            },
                          );
                        }
                      },
                      child: Text(
                        isUpdate == true ? AppLocalizations.of(context)!.update : AppLocalizations.of(context)!.add,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }));
  }

  bool isDateRangeConflicting(
      DateTime newFrom,
      DateTime newTo,
      List<WorkExperienceListData> existingList,
      {String? currentEmploymentId} // for update case
      ) {
    for (final exp in existingList) {

      // Skip same record during update
      if (currentEmploymentId != null &&
          exp.employmentID.toString() == currentEmploymentId) {
        continue;
      }

      if (exp.jobStartDate == null || exp.jobEndDate == null) continue;

      DateTime existingFrom = DateTime.parse(exp.jobStartDate!);

      DateTime existingTo =
      exp.jobEndDate == "Present"
          ? DateTime.now()
          : DateTime.parse(exp.jobEndDate!);

      // 🔴 OVERLAP CHECK
      if (newFrom.isBefore(existingTo.add(Duration(days: 1))) &&
          newTo.isAfter(existingFrom.subtract(Duration(days: 1)))) {
        return true;
      }
    }
    return false;
  }


  bool validateWorkExperienceForm(BuildContext context, provider) {
    // ---------------------------------------------
    // 1. Experience Type Required
    // ---------------------------------------------
    if (provider.experienceTypes.isEmpty) {
      showAlertError(AppLocalizations.of(context)!.plzSelExpNot, context);
      return false;
    }

    // ---------------------------------------------
    // 2. Employment Type Required
    // ---------------------------------------------
    if (provider.employmentTypeIdController.text.isEmpty) {
      showAlertError(AppLocalizations.of(context)!.plzSelEmpType, context);
      return false;
    }

    // ---------------------------------------------
    // 3. If Experience = Yes AND EmploymentType = 6
    //    → Ask Have You Been Employed in Past?
    // ---------------------------------------------
    if (provider.experienceTypes == "Yes" &&
        provider.employmentTypeIdController.text == "6" &&
        provider.employedInPastController.text.isEmpty) {
      showAlertError(AppLocalizations.of(context)!.plzSelEmpPast, context);
      return false;
    }

    // If Past = No and Type = 6 → No further validations
    if (provider.experienceTypes == "Yes" &&
        provider.employmentTypeIdController.text == "6" &&
        provider.employedInPastController.text == "No") {
      return true;
    }

    // ---------------------------------------------
    // 4. If Experience = Yes AND (Past = Yes OR Other Employment Type)
    //    → Validate Work Experience Fields
    // ---------------------------------------------
    if (provider.experienceTypes == "Yes") {
      // Job Title
      if (provider.jobTitleNameController.text.isEmpty) {
        showAlertError(AppLocalizations.of(context)!.plzEnterJobTitle, context);
        return false;
      }

      // Company Name
      if (provider.companyNameController.text.isEmpty) {
        showAlertError(AppLocalizations.of(context)!.plzEnterCompName, context);
        return false;
      }

      // Working in Company?
      if (provider.workingCompanyType.isEmpty) {
        showAlertError(AppLocalizations.of(context)!.plzSelStillWork, context);
        return false;
      }

      // From Date
      if (provider.fromDateController.text.isEmpty) {
        showAlertError(AppLocalizations.of(context)!.plzSelFromDate, context);
        return false;
      }

      // To Date
      if (provider.workingCompanyType == "No" &&
          provider.toDateController.text.isEmpty) {
        showAlertError(AppLocalizations.of(context)!.plzSelToDate, context);
        return false;
      }

      // Date Comparison
      if (provider.toDateController.text.isNotEmpty) {
        DateTime from = DateTime.parse(provider.fromDateController.text);
        DateTime to = DateTime.parse(provider.toDateController.text);

        if (to.isBefore(from)) {
          showAlertError(AppLocalizations.of(context)!.toDateEarlierFromDate, context);
          return false;
        }
      }

      // ---------------------------------------------
//  DATE RANGE CONFLICT CHECK
// ---------------------------------------------
      DateTime fromDate = DateTime.parse(provider.fromDateController.text);
      DateTime toDate = provider.workingCompanyType == "Yes"
          ? DateTime.now()
          : DateTime.parse(provider.toDateController.text);

      bool hasConflict = isDateRangeConflicting(
        fromDate,
        toDate,
        widget.existingExperiences,
        currentEmploymentId: widget.isUpdate
            ? widget.workExperienceListData?.employmentID.toString()
            : null,
      );

      if (hasConflict) {
        showAlertError(
          AppLocalizations.of(context)!.thisDateRangeUsed,
          context,
        );
        return false;
      }


      // Location
      // if (provider.locationController.text.isEmpty) {
      //   showAlertError("Please enter Location",context);
      //   return false;
      // }

      if (provider.stateIdController.text.isEmpty) {
        showAlertError(AppLocalizations.of(context)!.plzSelectState, context);
        return false;
      }

      if (provider.districtIdController.text.isEmpty) {
        showAlertError(AppLocalizations.of(context)!.plzSelectDistrict, context);
        return false;
      }

      if (provider.locationIdController.text.isEmpty) {
        showAlertError(AppLocalizations.of(context)!.plzSelLocation, context);
        return false;
      }

      if (provider.stateIdController.text.isEmpty) {
        showAlertError(AppLocalizations.of(context)!.plzSelectState, context);
        return false;
      }

      if (provider.districtIdController.text.isEmpty) {
        showAlertError(AppLocalizations.of(context)!.plzSelectDistrict, context);
        return false;
      }

      // Job Type
      if (provider.jobTypeIdController.text.isEmpty) {
        showAlertError(AppLocalizations.of(context)!.plzSelJobType, context);
        return false;
      }

      // Nature of Employment
      if (provider.employmentNatureIdController.text.isEmpty) {
        showAlertError(AppLocalizations.of(context)!.plzSelNatureEmp, context);
        return false;
      }

      // NCO Code
      if (provider.ncoIdController.text.isEmpty) {
        showAlertError(AppLocalizations.of(context)!.plzSelNCOCode, context);
        return false;
      }
    }

    return true;
  }
}

Widget buildDropdownWithBorderFieldOnlyThisPage<T>({
  required List<T> items,
  required TextEditingController controller,
  required TextEditingController idController,
  required String hintText,
  required double height,
  BorderRadius? borderRadius,
  Color? color,
  required ValueChanged<T?> onChanged,
  T? selectedValue, // ✅ ADD THIS
}) {
  return Container(
    height: height,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      borderRadius: borderRadius,
      border: Border.all(color: Colors.grey),
      color: color ?? Colors.white,
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<T>(
        isExpanded: true,
        value: items.contains(selectedValue) ? selectedValue : null,
        // ✅ VERY IMPORTANT
        hint: Text(hintText),
        items: items.map((item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(
              item is StateData
                  ? item.name ?? ""
                  : item is DistrictData
                      ? item.name ?? ""
                      : item is CityData
                          ? item.nameEng ?? ""
                          : item.toString(),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    ),
  );
}
