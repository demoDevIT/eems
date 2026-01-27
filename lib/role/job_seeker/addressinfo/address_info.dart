import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/job_seeker/addressinfo/modal/district_modal.dart';
import 'package:rajemployment/role/job_seeker/addressinfo/provider/address_info_provider.dart';
import 'package:rajemployment/utils/size_config.dart';
import 'package:rajemployment/utils/user_new.dart';

import '../../../utils/dropdown.dart';
import '../../../utils/global.dart';
import '../../../utils/textfeild.dart';
import '../../../utils/textstyles.dart';
import '../loginscreen/provider/locale_provider.dart';

class AddressInfoScreen extends StatefulWidget {
  const AddressInfoScreen({super.key});

  @override
  State<AddressInfoScreen> createState() => _AddressInfoScreenState();
}

class _AddressInfoScreenState extends State<AddressInfoScreen> {




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final addressInfoProvider = Provider.of<AddressInfoProvider>(context, listen: false);
      addressInfoProvider.clearData();
      addressInfoProvider.getDistrictMasterApi(context);
    });
  }


  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    return Scaffold(
        appBar: commonAppBar2("Address Info", context,
            localeProvider.currentLanguage, "", false, "", onTapClick: () {
              localeProvider.toggleLocale();
            }),

        body: Consumer<AddressInfoProvider>(builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header
                const Text(
                  "Permanent Address: As Per Jan Aadhar",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                hSpace(4),
                const Text(
                  "(If Any changes, please update on Jan Aadhar)",
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
                hSpace(16),

                /// Permanent Address Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width  * 0.90/ 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          labelWithStar('District ',required: false),

                         /* Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text( "District",
                                  style: Styles.mediumTextStyle(
                                      color: kBlackColor, size: 14)),
                            ),
                          ),*/
                         /* IgnorePointer(
                            ignoring: provider.sameAsAbove,
                            child: buildDropdownWithBorderField(
                              items: provider.districtList,
                              controller: provider.districtNameController,
                              idController: provider.districtIdController,
                              hintText:"Select District",
                              height: 50,
                              color: Colors.transparent,
                              width: MediaQuery.of(context).size.width * 0.90 / 2,
                              borderRadius: BorderRadius.circular(8),
                              onChanged: (value) {
                                final id = provider.districtIdController.text;
                                if (id.isEmpty) return;
                                try {
                                  final selectedRole = provider.districtList.firstWhere((item) => item.dropID.toString() == id);
                                  provider.getCityMasterApi(context, selectedRole.dropID.toString(),false);
                                  provider.assemblyListApi(context, selectedRole.dISTRICTID.toString());
                                  setState(() {});
                                } catch (e) {
                                  debugPrint("Error finding selected role: $e");
                                }

                                },
                            ),
                          ),*/
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                            child: buildTextWithBorderField(
                                provider.districtNameController,
                                "Select District",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.emailAddress,
                                isEnabled: false
                            ),
                          ),


                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width  * 0.90/ 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          labelWithStar('City ',required: false),
                          /*Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text( "City",
                                  style: Styles.mediumTextStyle(
                                      color: kBlackColor, size: 14)),
                            ),
                          ),*/


                          /*IgnorePointer(
                            ignoring: provider.sameAsAbove,
                            child: buildDropdownWithBorderField(
                              items: provider.cityList,
                              controller: provider.cityNameController,
                              idController: provider.cityIdController,
                              hintText:"Select City",
                              height: 50,
                              color: Colors.transparent,
                              width: MediaQuery.of(context).size.width * 0.90 / 2,
                              borderRadius: BorderRadius.circular(8),
                              onChanged: (value) {
                                final id = provider.cityIdController.text;
                                if (id.isEmpty) return;
                                try {
                                  final selectedRole = provider.cityList.firstWhere((item) => item.dropID.toString() == id);
                                  provider.getWardMasterApi(context, selectedRole.dropID.toString(),false);
                                  setState(() {});
                                } catch (e) {
                                  debugPrint("Error finding selected role: $e");
                                }
                              },
                            ),
                          ),*/

                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                            child: buildTextWithBorderField(
                                provider.cityNameController,
                                "Select City",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.emailAddress,
                                isEnabled:  false
                            ),
                          ),


                        ],
                      ),
                    ),
                  ],
                ),

                hSpace(4),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width  * 0.90/ 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          labelWithStar('Ward ',required: false),
                          /*Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text( "Ward",
                                  style: Styles.mediumTextStyle(
                                      color: kBlackColor, size: 14)),
                            ),
                          ),*/
                       /*   IgnorePointer(
                            ignoring: provider.sameAsAbove, // set to false to re-enable
                            child: buildDropdownWithBorderField(
                              items: provider.wardList,
                              controller: provider.wardNameController,
                              idController: provider.wardIdController,
                              hintText:"Select Ward",
                              height: 50,
                              color: Colors.transparent,
                              width: MediaQuery.of(context).size.width * 0.90 / 2,
                              borderRadius: BorderRadius.circular(8),
                              isEnable: false,
                              onChanged: (value) {
                                setState(() {

                                });
                              },
                            ),
                          ),*/
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                            child: buildTextWithBorderField(
                                provider.wardNameController,
                                "Select Ward",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.emailAddress,
                                isEnabled: false
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width  * 0.90/ 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          labelWithStar('Territory Type ',required: false),
                         /* Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text( "Territory Type",
                                  style: Styles.mediumTextStyle(
                                      color: kBlackColor, size: 14)),
                            ),
                          ),*/






                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Radio<String>(
                                value: "Rural",
                                groupValue:  provider.territoryType,
                               // onChanged: (val) => setState(() =>  provider.territoryType = val!),
                                onChanged: null,
                                visualDensity: VisualDensity.compact, // reduce space inside
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              const Text("Rural"),
                              SizedBox(width: 10), // Add space between the radio buttons
                              Radio<String>(
                                value: "Urban",
                                groupValue:  provider.territoryType,
                                //onChanged: (val) => setState(() =>  provider.territoryType = val!),
                                onChanged: null,
                                visualDensity: VisualDensity.compact, // reduce space inside
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              const Text("Urban"),
                            ],

                          )

                        ],
                      ),
                    ),
                  ],
                ),

                hSpace(4),

                labelWithStar('Address',required: false),
               /* Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text( "Address",
                        style: Styles.mediumTextStyle(
                            color: kBlackColor, size: 14)),
                  ),
                ),*/
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  child: buildTextWithBorderField(
                    provider.addressController,
                    "Address",
                    MediaQuery.of(context).size.width,
                    80,
                    TextInputType.emailAddress,
                    maxLine: 20,
                    //isEnabled: provider.sameAsAbove == false ? true : false
                      isEnabled: false
                  ),
                ),

                hSpace(4),

                labelWithStar('Pin Code',required: false),
               /* Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text( "Pin Code",
                        style: Styles.mediumTextStyle(
                            color: kBlackColor, size: 14)),
                  ),
                ),*/
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  child: buildTextWithBorderField(
                    provider.pinCodeController,
                    "Pin Code",
                    MediaQuery.of(context).size.width,
                    50,
                    TextInputType.number,
                    // isEnabled: provider.sameAsAbove == false ? true : false
                      isEnabled: false
                  ),
                ),

                hSpace(4),

                /// Communication Address
                Row(
                  children: [

                    labelWithStar('Communication Address',required: false),


                    Row(

                      children: [
                        Checkbox(
                          value:  provider.sameAsAbove,
                          onChanged: null,
                          // onChanged: (value) {
                          //   provider.sameAsAbove = value!;
                          //  // print(value);
                          //   if(value == true){
                          //     provider.cDistrictIdController.text = provider.districtIdController.text;
                          //     provider.cDistrictNameController.text = provider.districtNameController.text;
                          //     provider.cCityNameController.text = provider.cityNameController.text;
                          //     provider.cCityIdController.text =  provider.cityIdController.text;
                          //     provider.cWardIdController.text = provider.wardIdController.text;
                          //     provider.cWardNameController.text =  provider.wardNameController.text;
                          //     provider.cTerritoryType = provider.territoryType;
                          //     provider.cTerritoryTypeID = provider.territoryTypeID;
                          //     provider.cAddressController.text = provider.addressController.text;
                          //     provider.cPinCodeController.text = provider.pinCodeController.text;
                          //   }
                          //   else{
                          //     provider.cDistrictIdController.text =  "";
                          //     provider.cDistrictNameController.text =  "";
                          //     provider.cCityNameController.text =  "";
                          //     provider.cCityIdController.text =  "";
                          //     provider.cWardIdController.text =  "";
                          //     provider.cWardNameController.text =  "";
                          //     provider.cTerritoryType = "";
                          //     provider.cTerritoryTypeID = "";
                          //     provider.cAddressController.text = "";
                          //     provider.cPinCodeController.text = "";
                          //   }
                          //   setState(() {
                          //   });
                          // },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6), // adjust radius
                          ),
                          side: const BorderSide(color:kDartGrayColor, width: 2,), // border color
                          activeColor: kPrimaryColor,
                          checkColor: Colors.white,
                          fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                              if (states.contains(MaterialState.selected)) {
                                return kPrimaryColor;
                              }
                              return kTextColor1;
                            },
                          ),
                        ),

                        const Text("Same As Above"),
                      ],
                    ),





                  ],
                ),
                hSpace(4),


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width  * 0.90/ 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          labelWithStar('District',required: false),
                        /*  Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text( "District",
                                  style: Styles.mediumTextStyle(
                                      color: kBlackColor, size: 14)),
                            ),
                          ),*/
                          IgnorePointer(
                            //ignoring: provider.sameAsAbove,
                            ignoring: true,
                            child: Padding(
                              padding:  const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                              child: buildDropdownWithBorderField(
                                items: provider.cDistrictList,
                                controller: provider.cDistrictNameController,
                                idController: provider.cDistrictIdController,
                                hintText:"Select District",
                                height: 50,
                                color: Colors.transparent,
                                width: MediaQuery.of(context).size.width * 0.90 / 2,
                                borderRadius: BorderRadius.circular(8),
                                onChanged: (value) {
                                  final id = provider.cDistrictIdController.text;
                                  if (id.isEmpty) return;
                                  try {
                                    final selectedRole = provider.cDistrictList.firstWhere((item) => item.dropID.toString() == id);
                                    provider.getCityMasterApi(context, selectedRole.dropID.toString(),true);
                                    provider.assemblyListApi(context, selectedRole.dISTRICTID.toString());

                                    setState(() {});
                                  } catch (e) {
                                    debugPrint("Error finding selected role: $e");
                                  }

                                },
                              ),
                            ),
                        )



                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width  * 0.90/ 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          labelWithStar('City',required: false),
                        /*  Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text( "City",
                                  style: Styles.mediumTextStyle(
                                      color: kBlackColor, size: 14)),
                            ),
                          ),
*/
                      IgnorePointer(
                        ignoring: true, // disables all taps/interactions
                        child: Opacity(
                          opacity: 0.6, // optional: visually indicate it's disabled
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                            child: buildDropdownWithBorderField(
                              items: provider.cCityList,
                              controller: provider.cCityNameController,
                              idController: provider.cCityIdController,
                              hintText: "Select City",
                              height: 50,
                              color: Colors.transparent,
                              width: MediaQuery.of(context).size.width * 0.90 / 2,
                              borderRadius: BorderRadius.circular(8),
                              onChanged: (value) {
                                // Won't be called because IgnorePointer is true
                              },
                            ),
                          ),
                        ),
                      ),

                          // provider.sameAsAbove == false ?  Padding(
                          //   padding:  const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                          //   child: buildDropdownWithBorderField(
                          //     items: provider.cCityList,
                          //     controller: provider.cCityNameController,
                          //     idController: provider.cCityIdController,
                          //     hintText:"Select City",
                          //     height: 50,
                          //     color: Colors.transparent,
                          //     width: MediaQuery.of(context).size.width * 0.90 / 2,
                          //     borderRadius: BorderRadius.circular(8),
                          //     onChanged: (value) {
                          //       final id = provider.cCityIdController.text;
                          //       if (id.isEmpty) return;
                          //       try {
                          //         final selectedRole = provider.cCityList.firstWhere((item) => item.dropID.toString() == id);
                          //         provider.getWardMasterApi(context, selectedRole.dropID.toString(),true);
                          //         setState(() {});
                          //       } catch (e) {
                          //         debugPrint("Error finding selected role: $e");
                          //       }
                          //     },
                          //   ),
                          //  : Padding(
                          //   padding:
                          //   const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                          //   child: buildTextWithBorderField(
                          //     provider.cCityNameController,
                          //     "Select City",
                          //     MediaQuery.of(context).size.width,
                          //     50,
                          //     isEnabled: provider.sameAsAbove == true ? false : true,
                          //     TextInputType.emailAddress,
                          //     postfixIcon: Icon(Icons.arrow_drop_down,color: fontGrayColor,)
                          //
                          //   ),),

                        ],
                      ),
                    ),
                  ],
                ),


                hSpace(4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width  * 0.90/ 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          labelWithStar('Ward',required: false),
                         /* Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text( "Ward",
                                  style: Styles.mediumTextStyle(
                                      color: kBlackColor, size: 14)),
                            ),
                          ),*/

                          IgnorePointer(
                            ignoring: true, // disables all interactions
                            child: Opacity(
                              opacity: 0.6, // optional: visually indicate it's disabled
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                                child: buildDropdownWithBorderField(
                                  items: provider.cWardList,
                                  controller: provider.cWardNameController,
                                  idController: provider.cWardIdController,
                                  hintText: "Select Ward",
                                  height: 50,
                                  color: Colors.transparent,
                                  width: MediaQuery.of(context).size.width * 0.90 / 2,
                                  borderRadius: BorderRadius.circular(8),
                                  onChanged: (value) {
                                    // This will not be called because IgnorePointer is true
                                  },
                                ),
                              ),
                            ),
                          ),

                          // provider.sameAsAbove == false ? Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                          //   child: buildDropdownWithBorderField(
                          //     items: provider.cWardList,
                          //     controller: provider.cWardNameController,
                          //     idController: provider.cWardIdController,
                          //     hintText:"Select Ward",
                          //     height: 50,
                          //     color: Colors.transparent,
                          //     width: MediaQuery.of(context).size.width * 0.90 / 2,
                          //     borderRadius: BorderRadius.circular(8),
                          //     onChanged: (value) {
                          //       },
                          //   ),
                          // ) :  Padding(
                          //   padding:
                          //   const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                          //   child: buildTextWithBorderField(
                          //     provider.cWardNameController,
                          //     "Select Ward",
                          //     MediaQuery.of(context).size.width,
                          //     50,
                          //     isEnabled: provider.sameAsAbove == true ? false : true,
                          //     TextInputType.emailAddress,
                          //     postfixIcon: Icon(Icons.arrow_drop_down,color: fontGrayColor,)
                          //   ),),

                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width  * 0.90/ 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          labelWithStar('Territory Type',required: false),
                        /*  Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text( "Territory Type",
                                  style: Styles.mediumTextStyle(
                                      color: kBlackColor, size: 14)),
                            ),
                          ),*/

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Radio<String>(
                                  value: "Rural",
                                  groupValue:  provider.cTerritoryType,
                                  onChanged: null,
                                 // onChanged: (val) =>
                                  //    setState(() =>  provider.cTerritoryType = val!),
                                  visualDensity: VisualDensity.compact, // reduce space inside
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                const Text("Rural"),
                                SizedBox(width: 10), // Add space between the radio buttons
                                Radio<String>(
                                  value: "Urban",
                                  groupValue:  provider.cTerritoryType,
                                  onChanged: null,
                                  // onChanged: (val) =>
                                  //     setState(() =>  provider.cTerritoryType = val!),
                                  visualDensity: VisualDensity.compact, // reduce space inside
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                const Text("Urban"),
                              ],

                            ),
                          )

                        ],
                      ),
                    ),
                  ],
                ),

                hSpace(4),
                labelWithStar('Address',required: false),
               /* Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text( "Address",
                        style: Styles.mediumTextStyle(
                            color: kBlackColor, size: 14)),
                  ),
                ),*/
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  child: buildTextWithBorderField(
                    provider.cAddressController,
                    "Address",
                    MediaQuery.of(context).size.width,
                    80,
                    maxLine: 20,
                    //isEnabled: provider.sameAsAbove == true ? false : true,
                    isEnabled: false,
                    TextInputType.emailAddress,
                  ),
                ),

                hSpace(4),
                labelWithStar('Pin Code',required: false),
               /* Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text( "Pin Code",
                        style: Styles.mediumTextStyle(
                            color: kBlackColor, size: 14)),
                  ),
                ),*/
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  child: buildTextWithBorderField(
                    provider.cPinCodeController,
                    "Pin Code",
                    MediaQuery.of(context).size.width,
                    50,
                    TextInputType.number,
                    //isEnabled: provider.sameAsAbove == true ? false : true,
                    isEnabled: false,
                  ),
                ),

                hSpace(4),
                /// Constituency
                labelWithStar('Select Constituency',required: false),

                hSpace(16),


                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                     // alignment: Alignment.centerLeft,
                      //width: MediaQuery.of(context).size.width  * 0.92/ 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          labelWithStar('Assembly Constituency',required: false),
                          /*Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text( "Assembly Constituency",
                                  style: Styles.mediumTextStyle(
                                      color: kBlackColor, size: 14)),
                            ),
                          ),*/
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: buildDropdownWithBorderFieldForOnlyTwo(
                              items: provider.assemblyList,
                              controller: provider.assemblyNameController,
                              idController: provider.assemblyIDController,
                              hintText:"Select Assembly Constituency",
                              height: 50,
                              color: Colors.transparent,
                              width: double.infinity,
                              borderRadius: BorderRadius.circular(8),
                              enabled: false,
                              onChanged: (value) {
                                final id = provider.assemblyIDController.text;
                                if (id.isEmpty) return;

                                try{
                                final selectedRole = provider.districtList.firstWhere((item) => item.dropID.toString() == provider.districtIdController.text);
                                provider.getParliamentListApi(context, provider.assemblyIDController.text,selectedRole.dISTRICTID.toString(),"","");
                                setState(() {});
                                } catch (e) {
                                  debugPrint("Error finding selected role: $e");
                                }
                              },
                            ),


                            // child: buildDropdownWithBorderField(
                            //   items: provider.cDistrictList,
                            //   controller: provider.cDistrictNameController,
                            //   idController: provider.cDistrictIdController,
                            //   hintText:"Select District",
                            //   height: 50,
                            //   color: Colors.transparent,
                            //   width: MediaQuery.of(context).size.width * 0.90 / 2,
                            //   borderRadius: BorderRadius.circular(8),
                            //   onChanged: (value) {
                            //     final id = provider.cDistrictIdController.text;
                            //     if (id.isEmpty) return;
                            //     try {
                            //       final selectedRole = provider.cDistrictList.firstWhere((item) => item.dropID.toString() == id);
                            //       provider.getCityMasterApi(context, selectedRole.dropID.toString(),true);
                            //       provider.assemblyListApi(context, selectedRole.dISTRICTID.toString());
                            //
                            //       setState(() {});
                            //     } catch (e) {
                            //       debugPrint("Error finding selected role: $e");
                            //     }
                            //
                            //   },
                            // ),





                          ),

                        ],
                      ),
                    ),
                    Expanded(
                   //   alignment: Alignment.centerLeft,
                    //  width: MediaQuery.of(context).size.width  * 0.92/ 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          labelWithStar('Parliament Constituency',required: false),
                        /*  Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text( "Parliament Constituency",
                                  style: Styles.mediumTextStyle(
                                      color: kBlackColor, size: 14)),
                            ),
                          ),*/

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: buildDropdownWithBorderFieldForOnlyTwo(
                              items:provider.parliamentListDataList,
                              controller: provider.constituencyNameController,
                              idController: provider.constituencyIDController,
                              hintText:"Select Parliament Constituency",
                              height: 50,
                              color: Colors.transparent,
                              width: double.infinity,
                              borderRadius: BorderRadius.circular(8),
                              enabled: false,
                              onChanged: (value) {
                              },
                            ),
                          ),


                        ],
                      ),
                    ),
                  ],
                ),

                hSpace(4),

                /// Save button
                SizedBox(

                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                    if(provider.cDistrictIdController.text.isEmpty){
                      showAlertError("Please select district", context);
                    }
                    else if(provider.cCityIdController.text.isEmpty){
                      showAlertError("Please select city", context);
                    }
                    else if(provider.cWardIdController.text.isEmpty){
                      showAlertError("Please select ward", context);
                    }
                    else if(provider.cTerritoryType.isEmpty){
                      showAlertError("Please select territory type", context);
                    }
                    else if(provider.cAddressController.text.isEmpty){
                      showAlertError("Please enter address", context);
                    }
                    else if(provider.pinCodeController.text.isEmpty){
                      showAlertError("Please enter pincode", context);
                    }
                    else if(provider.assemblyIDController.text.isEmpty){
                      showAlertError("Please select assembly constituency", context);
                    }
                    else if(provider.constituencyIDController.text.isEmpty){
                      showAlertError("Please select parliament constituency", context);
                    }
                    else{
                      confirmAlertDialog(context, "Alert","Are you sure want to submit ?", (value) {
                        if (value.toString() == "success") {
                          provider.saveDataAddressApi(context);
                        }
                      },
                      );

                    }

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),

                ),
                SizedBox(height: SizeConfig.screenHeight! * 0.02),

              ],

            ),
          );
        }));



  }

 }

Widget buildDropdownWithBorderFieldForOnlyTwo({
  required List<dynamic> items,
  required TextEditingController controller,
  required TextEditingController idController,
  String? hintText,
  double? width,
  double? height,
  Color? color,
  Widget? postfixIcon,
  bool enabled = true, // 👈 control enable/disable
  Function(String?)? onChanged,
  BorderRadius? borderRadius,
}) {
  String? selectedValue =
  items.any((item) => item.name.toString() == controller.text)
      ? controller.text
      : null;

  return Container(
    width: width ?? double.infinity,
    height: height ?? 50.0,
    decoration: BoxDecoration(
      color: color ?? kWhite,
      borderRadius: borderRadius ?? BorderRadius.circular(10),
      border: Border.all(
        color: enabled ? borderColor : Colors.grey.shade400,
        width: 0.5,
      ),
    ),
    child: AbsorbPointer(
      absorbing: !enabled, // 👈 disables touch
      child: Opacity(
        opacity: enabled ? 1.0 : 0.5, // 👈 disabled look
        child: DropdownButton<String>(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          dropdownColor: kWhite,
          value: selectedValue,
          isExpanded: true,
          hint: Text(
            hintText ?? 'Select an option',
            style: Styles.regularTextStyle(
              size: 14,
              color: fontGrayColor,
            ),
          ),
          icon: postfixIcon ??
              const Icon(Icons.arrow_drop_down, color: fontGrayColor),
          style: Styles.regularTextStyle(
            size: 14,
            color: kBlackColor,
          ),
          underline: const SizedBox(),
          items: items.map((dynamic item) {
            return DropdownMenuItem<String>(
              value: item.name.toString(),
              child: Text(item.name.toString()),
            );
          }).toList(),
          onChanged: enabled
              ? (String? newValue) {
            if (newValue == null) return;

            final selectedItem = items.firstWhere(
                  (item) => item.name.toString() == newValue,
            );

            controller.text = newValue;
            idController.text = selectedItem.dropID.toString();

            if (onChanged != null) {
              onChanged(newValue);
            }
          }
              : null,
        ),
      ),
    ),
  );
}
