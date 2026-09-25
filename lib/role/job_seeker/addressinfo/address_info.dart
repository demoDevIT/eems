import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/job_seeker/addressinfo/modal/district_modal.dart';
import 'package:rajemployment/role/job_seeker/addressinfo/provider/address_info_provider.dart';
import 'package:rajemployment/utils/size_config.dart';
import 'package:rajemployment/utils/user_new.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/dropdown.dart';
import '../../../utils/global.dart';
import '../../../utils/textfeild.dart';
import '../../../utils/textstyles.dart';
import '../../department/dept_join_attendance_list/dept_join_attendance_list.dart';
import '../../department/register_form/modal/block_modal.dart';
import '../../department/register_form/modal/gp_modal.dart';
import '../../department/register_form/modal/village_modal.dart';
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
        appBar: commonAppBar2(AppLocalizations.of(context)!.addressInfo, context,
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
                Text(
                  AppLocalizations.of(context)!.perAddAsPerJanadhar,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                hSpace(4),
                Text(
                  AppLocalizations.of(context)!.ifAnyChanges,
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
                          labelWithStar(AppLocalizations.of(context)!.district,required: false),

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
                                AppLocalizations.of(context)!.selectDistrict,
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
                          labelWithStar(AppLocalizations.of(context)!.city,required: false),
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
                                AppLocalizations.of(context)!.selectCity,
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
                          labelWithStar(AppLocalizations.of(context)!.ward,required: false),
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
                                AppLocalizations.of(context)!.selectWard,
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
                          labelWithStar(AppLocalizations.of(context)!.territoryType,required: false),
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
                              Text(AppLocalizations.of(context)!.rural),
                              SizedBox(width: 10), // Add space between the radio buttons
                              Radio<String>(
                                value: "Urban",
                                groupValue:  provider.territoryType,
                                //onChanged: (val) => setState(() =>  provider.territoryType = val!),
                                onChanged: null,
                                visualDensity: VisualDensity.compact, // reduce space inside
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              Text(AppLocalizations.of(context)!.urban),
                            ],

                          )

                        ],
                      ),
                    ),
                  ],
                ),

                hSpace(4),

                labelWithStar(AppLocalizations.of(context)!.address,required: false),
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
                    AppLocalizations.of(context)!.address,
                    MediaQuery.of(context).size.width,
                    80,
                    TextInputType.emailAddress,
                    maxLine: 20,
                    //isEnabled: provider.sameAsAbove == false ? true : false
                      isEnabled: false
                  ),
                ),

                hSpace(4),

                labelWithStar(AppLocalizations.of(context)!.pincode,required: false),
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
                    AppLocalizations.of(context)!.pincode,
                    MediaQuery.of(context).size.width,
                    50,
                    TextInputType.number,
                    // isEnabled: provider.sameAsAbove == false ? true : false
                      isEnabled: false
                  ),
                ),

                hSpace(4),

                /// Communication Address
                /// Communication Address

                Row(
                  children: [
                    labelWithStar(
                      AppLocalizations.of(context)!.communicationAdd,
                      required: false,
                    ),

                    const SizedBox(width: 10),

                    Row(
                      children: [
                        Checkbox(
                          value: provider.sameAsAbove,
                          onChanged: (value) {
                            if (value == null) return;

                            provider.setSameAsAbove(context, value);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          side: const BorderSide(
                            color: kDartGrayColor,
                            width: 2,
                          ),
                          activeColor: kPrimaryColor,
                          checkColor: Colors.white,
                        ),
                        Text(
                          AppLocalizations.of(context)!.sameAsAbove,
                        ),
                      ],
                    ),
                  ],
                ),

                hSpace(12),

// ======================================================
// DISTRICT
// ======================================================

                labelWithStar(
                  AppLocalizations.of(context)!.district,
                  required: false,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: IgnorePointer(
                    ignoring: provider.sameAsAbove,
                    child: Opacity(
                      opacity: provider.sameAsAbove ? 0.6 : 1,
                      child: buildDropdownWithBorderField(
                        items: provider.cDistrictList,
                        controller: provider.cDistrictNameController,
                        idController: provider.cDistrictIdController,

                        getName: (item) {
                          final locale =
                              AppLocalizations.of(context)!.localeName;

                          return locale == 'hi'
                              ? (item.nameHi ?? item.name ?? '')
                              : (item.name ?? '');
                        },

                        hintText:
                        AppLocalizations.of(context)!.selectDistrict,

                        height: 50,
                        color: Colors.transparent,
                        width: double.infinity,
                        borderRadius: BorderRadius.circular(8),

                        onChanged: (value) {
                          final id = provider.cDistrictIdController.text;

                          if (id.isEmpty) return;

                          provider.getCityMasterApi(
                            context,
                            id,
                            true,
                          );

                          // provider.assemblyListApi(
                          //   context,
                          //   id,
                          // );

                          provider.getBlockApi(
                            context,
                            id,
                          );
                        },
                      ),
                    ),
                  ),
                ),

                hSpace(8),

// ======================================================
// TERRITORY TYPE
// ======================================================

                labelWithStar(
                  AppLocalizations.of(context)!.territoryType,
                  required: false,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Radio<String>(
                        value: "Rural",
                        groupValue: provider.cTerritoryType,
                        onChanged: provider.sameAsAbove
                            ? null
                            : (value) {
                          if (value == null) return;

                          provider.setCommunicationTerritoryType(
                            context,
                            value,
                          );
                        },
                      ),

                      Text(
                        AppLocalizations.of(context)!.rural,
                      ),

                      const SizedBox(width: 10),

                      Radio<String>(
                        value: "Urban",
                        groupValue: provider.cTerritoryType,
                        onChanged: provider.sameAsAbove
                            ? null
                            : (value) {
                          if (value == null) return;

                          provider.setCommunicationTerritoryType(
                            context,
                            value,
                          );
                        },
                      ),

                      Text(
                        AppLocalizations.of(context)!.urban,
                      ),
                    ],
                  ),
                ),

                hSpace(8),


          if (provider.cTerritoryType == "Urban") ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width * 0.90 / 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            labelWithStar(AppLocalizations.of(context)!.city,
                                required: false),
                            IgnorePointer(
                              ignoring: provider.sameAsAbove, //true - disables all taps/interactions
                              child: Opacity(
                                opacity: provider.sameAsAbove ? 0.6 : 1,
                                // optional: visually indicate it's disabled
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 5),
                                  child: buildDropdownWithBorderField(
                                    items: provider.cCityList,
                                    controller: provider.cCityNameController,
                                    idController: provider.cCityIdController,
                                    getName: (item) {
                                      final locale =
                                          AppLocalizations.of(context)!
                                              .localeName;

                                      return locale == 'hi'
                                          ? (item.nameHi ?? item.name ?? '')
                                          : (item.name ?? '');
                                    },
                                    hintText: AppLocalizations.of(context)!
                                        .selectCity,
                                    height: 50,
                                    color: Colors.transparent,
                                    width: MediaQuery.of(context).size.width *
                                        0.90 /
                                        2,
                                    borderRadius: BorderRadius.circular(8),
                                    onChanged: (value) {
                                      final id = provider.cCityIdController.text;

                                      if (id.isEmpty) return;

                                      provider.getWardMasterApi(
                                        context,
                                        id,
                                        true,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width * 0.90 / 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            labelWithStar(AppLocalizations.of(context)!.ward,
                                required: false),
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
                              ignoring: provider.sameAsAbove, // disables all interactions
                              child: Opacity(
                                opacity: provider.sameAsAbove ? 0.6 : 1,
                                // optional: visually indicate it's disabled
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 5),
                                  child: buildDropdownWithBorderField(
                                    items: provider.cWardList,
                                    controller: provider.cWardNameController,
                                    idController: provider.cWardIdController,
                                    getName: (item) {
                                      final locale =
                                          AppLocalizations.of(context)!
                                              .localeName;

                                      return locale == 'hi'
                                          ? (item.nameHi ?? item.name ?? '')
                                          : (item.name ?? '');
                                    },
                                    hintText: AppLocalizations.of(context)!
                                        .selectWard,
                                    height: 50,
                                    color: Colors.transparent,
                                    width: MediaQuery.of(context).size.width *
                                        0.90 /
                                        2,
                                    borderRadius: BorderRadius.circular(8),
                                    onChanged: (value) {
                                      // This will not be called because IgnorePointer is true
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],

          if (provider.cTerritoryType == "Rural") ...[
// ======================================================
// BLOCK
// ======================================================

            labelWithStar(
              "Block",
              required: false,
            ),

            provider.isBlockLoading
                ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
                : IgnorePointer(
              ignoring: provider.sameAsAbove,
              child: Opacity(
                opacity: provider.sameAsAbove ? 0.6 : 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child:
                  buildDropdownWithBorderFieldOnlyThisPage<BlockData>(
                    items: provider.blockList,
                    controller: provider.blockNameController,
                    idController: provider.blockIdController,
                    hintText: "--Select Block--",
                    height: 50,
                    selectedValue: provider.selectedBlock,
                    getLabel: (e) => e.nameEng ?? "",
                    onChanged: (value) {
                      if (value == null) return;

                      provider.selectedBlock = value;

                      provider.blockNameController.text =
                          value.nameEng ?? "";

                      provider.blockIdController.text =
                          value.iD?.toString() ?? "";

                      provider.getGpApi(
                        context,
                        value.code!,
                      );

                      provider.notifyListeners();
                    },
                  ),
                ),
              ),
            ),

            hSpace(8),

// ======================================================
// GRAM PANCHAYAT
// ======================================================

            labelWithStar(
              "Gram Panchayat",
              required: false,
            ),

            provider.isGpLoading
                ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
                : IgnorePointer(
              ignoring: provider.sameAsAbove,
              child: Opacity(
                opacity: provider.sameAsAbove ? 0.6 : 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child:
                  buildDropdownWithBorderFieldOnlyThisPage<
                      GramPanchayatData>(
                    items: provider.gpList,
                    controller: provider.gpNameController,
                    idController: provider.gpIdController,
                    hintText: "--Select Gram Panchayat--",
                    height: 50,
                    selectedValue: provider.selectedGp,
                    getLabel: (e) => e.nameEng ?? "",
                    onChanged: (value) {
                      if (value == null) return;

                      provider.selectedGp = value;

                      provider.gpNameController.text =
                          value.nameEng ?? "";

                      provider.gpIdController.text =
                          value.iD?.toString() ?? "";

                      provider.getVillageApi(
                        context,
                        value.code!,
                      );

                      provider.notifyListeners();
                    },
                  ),
                ),
              ),
            ),

            hSpace(8),

// ======================================================
// VILLAGE
// ======================================================

            labelWithStar(
              "Village",
              required: false,
            ),

            provider.isVillageLoading
                ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
                : IgnorePointer(
              ignoring: provider.sameAsAbove,
              child: Opacity(
                opacity: provider.sameAsAbove ? 0.6 : 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child:
                  buildDropdownWithBorderFieldOnlyThisPage<
                      VillageData>(
                    items: provider.villageList,
                    controller: provider.villageNameController,
                    idController: provider.villageIdController,
                    hintText: "--Select Village--",
                    height: 50,
                    selectedValue: provider.selectedVillage,
                    getLabel: (e) => e.nameEng ?? "",
                    onChanged: (value) {
                      if (value == null) return;

                      provider.selectedVillage = value;

                      provider.villageNameController.text =
                          value.nameEng ?? "";

                      provider.villageIdController.text =
                          value.iD?.toString() ?? "";

                      provider.notifyListeners();
                    },
                  ),
                ),
              ),
            ),

            hSpace(8),
          ],

                // ======================================================
// ADDRESS
// ======================================================

                labelWithStar(
                  AppLocalizations.of(context)!.address,
                  required: false,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: buildTextWithBorderField(
                    provider.cAddressController,
                    AppLocalizations.of(context)!.address,
                    MediaQuery.of(context).size.width,
                    80,
                    TextInputType.emailAddress,
                    maxLine: 20,
                    isEnabled: !provider.sameAsAbove,
                  ),
                ),

                hSpace(4),

// ======================================================
// PINCODE
// ======================================================

                labelWithStar(
                  AppLocalizations.of(context)!.pincode,
                  required: false,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: buildTextWithBorderField(
                    provider.cPinCodeController,
                    AppLocalizations.of(context)!.pincode,
                    MediaQuery.of(context).size.width,
                    50,
                    TextInputType.number,
                    isEnabled: !provider.sameAsAbove,
                  ),
                ),

               //  hSpace(4),
               //  labelWithStar(AppLocalizations.of(context)!.address,required: false),
               // /* Padding(
               //    padding:
               //    const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
               //    child: Align(
               //      alignment: Alignment.topLeft,
               //      child: Text( "Address",
               //          style: Styles.mediumTextStyle(
               //              color: kBlackColor, size: 14)),
               //    ),
               //  ),*/
               //
               //
               //  Padding(
               //    padding:
               //    const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
               //    child: buildTextWithBorderField(
               //      provider.cAddressController,
               //      AppLocalizations.of(context)!.address,
               //      MediaQuery.of(context).size.width,
               //      80,
               //      maxLine: 20,
               //      //isEnabled: provider.sameAsAbove == true ? false : true,
               //      isEnabled: false,
               //      TextInputType.emailAddress,
               //    ),
               //  ),
               //
               //  hSpace(4),
               //  labelWithStar(AppLocalizations.of(context)!.pincode,required: false),
               // /* Padding(
               //    padding:
               //    const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
               //    child: Align(
               //      alignment: Alignment.topLeft,
               //      child: Text( "Pin Code",
               //          style: Styles.mediumTextStyle(
               //              color: kBlackColor, size: 14)),
               //    ),
               //  ),*/
               //  Padding(
               //    padding:
               //    const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
               //    child: buildTextWithBorderField(
               //      provider.cPinCodeController,
               //      AppLocalizations.of(context)!.pincode,
               //      MediaQuery.of(context).size.width,
               //      50,
               //      TextInputType.number,
               //      //isEnabled: provider.sameAsAbove == true ? false : true,
               //      isEnabled: false,
               //    ),
               //  ),

                hSpace(4),
                /// Constituency
              /*  labelWithStar('Select Constituency',required: false),

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

                hSpace(4), */

                /// Save button
                SizedBox(

                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (provider.cDistrictIdController.text.isEmpty) {
                        showAlertError(
                          AppLocalizations.of(context)!.plzSelectDistrict,
                          context,
                        );
                      }
                      else if (provider.cTerritoryType.isEmpty) {
                        showAlertError(
                          AppLocalizations.of(context)!.plzSelectTeriType,
                          context,
                        );
                      }
// ==================== URBAN VALIDATION ====================
                      else if (provider.cTerritoryType == "Urban" &&
                          provider.cCityIdController.text.isEmpty) {
                        showAlertError(
                          AppLocalizations.of(context)!.plzSelectCity,
                          context,
                        );
                      }
                      else if (provider.cTerritoryType == "Urban" &&
                          provider.cWardIdController.text.isEmpty) {
                        showAlertError(
                          AppLocalizations.of(context)!.plzSelectWard,
                          context,
                        );
                      }
// ==================== RURAL VALIDATION ====================
                      else if (provider.cTerritoryType == "Rural" &&
                          provider.blockIdController.text.isEmpty) {
                        showAlertError(
                          "Please select Block",
                          context,
                        );
                      }
                      else if (provider.cTerritoryType == "Rural" &&
                          provider.gpIdController.text.isEmpty) {
                        showAlertError(
                          "Please select Gram Panchayat",
                          context,
                        );
                      }
                      else if (provider.cTerritoryType == "Rural" &&
                          provider.villageIdController.text.isEmpty) {
                        showAlertError(
                          "Please select Village",
                          context,
                        );
                      }
// ==================== COMMON VALIDATION ====================
                      else if (provider.cAddressController.text.trim().isEmpty) {
                        showAlertError(
                          AppLocalizations.of(context)!.plzEnterAddress,
                          context,
                        );
                      }
                      else if (provider.cPinCodeController.text.trim().isEmpty) {
                        showAlertError(
                          AppLocalizations.of(context)!.plzEnterPincode,
                          context,
                        );
                      }
                      else if (int.tryParse(provider.cPinCodeController.text.trim()) == null) {
                        showAlertError(
                          "Pincode should be a number",
                          context,
                        );
                      }
                      else {
                        confirmAlertDialog(
                          context,
                          AppLocalizations.of(context)!.alert,
                          AppLocalizations.of(context)!.areYouSureSubmitForm,
                              (value) {
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
                    child: Text(
                      AppLocalizations.of(context)!.save,
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
