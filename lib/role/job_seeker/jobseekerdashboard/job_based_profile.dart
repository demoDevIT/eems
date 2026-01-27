import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/textstyles.dart';
import 'package:rajemployment/utils/utility_class.dart';

import '../homescreen/modal/job_list_modal.dart';

class JobBasedProfile extends StatelessWidget {
  JobListData jobsData;
   JobBasedProfile({required this.jobsData,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0,right: 4.0),
      child: jobCard(jobsData.jobNameEn.toString(), jobsData.organizationName.toString(),
          jobsData.salary.toString(), jobsData.preferedLocation.toString(),
          jobsData.employmentType.toString(), jobsData.closingDate.toString(),context),
    );
  }

  Widget jobCard(String title, String company, String salary, String location,
      String jobType,String closingDate,BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.60,
                child: Text(checkNullValue(title),
                    overflow: TextOverflow.ellipsis,
                    style:Styles.semiBoldTextStyle(size: 16,color: kBlackColor),),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.20,
                height: 25,
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: kJobFlotBackColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(checkNullValue(jobType),
                  overflow: TextOverflow.ellipsis,
                  style:Styles.regularTextStyle(size: 11,color: kJobFontColor),
                   ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Container(
              alignment: Alignment.topLeft,
              width: MediaQuery.of(context).size.width * 0.41,
              child: Text("Salary:${checkNullValue(salary)}",
                overflow: TextOverflow.ellipsis,
                style:Styles.regularTextStyle(size: 11,color: kDartGrayColor),
              ),
            ),

            Container(
              alignment: Alignment.topRight,
              width: MediaQuery.of(context).size.width * 0.41,
              child: Text("Posted:${getFormattedDate(checkNullValue(closingDate))}",
                overflow: TextOverflow.ellipsis,
                style:Styles.regularTextStyle(size: 11,color: kDartGrayColor),
              ),
            ),

          ],),
          const SizedBox(height: 8),
          Divider(height: 1,color: kDartGrayColor,thickness: 0.8,),
          const SizedBox(height: 8),
          Row(
            children: [
              // Company Logo
              Container(
                width: 50,
                height: 50,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Image.asset(
                  "assets/logos/google.png",
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 16),
              // Company Name and Location
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      checkNullValue(company),
                      style:UtilityClass.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        color: kBlackColor
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          checkNullValue(location),
                          style:UtilityClass.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: kDartGrayColor
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Save Button/Icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: kIconsBackColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.bookmark_added_outlined, // Using a filled bookmark for the saved state
                  color: kIconsColor,
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}