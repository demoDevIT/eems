import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/counselor/role/provider/role_provider.dart';
import 'package:rajemployment/utils/gradient_scaffold.dart';
import 'package:rajemployment/utils/size_config.dart';
import 'package:rajemployment/utils/utility_class.dart';

import '../../job_seeker/janadhaarflowpage/janadhaarflowpage_screen.dart';

class RoleScreen extends StatefulWidget {
  const RoleScreen({Key? key}) : super(key: key);

  RoleScreenState createState() => RoleScreenState();
 }
class RoleScreenState extends State<RoleScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return PopScope(
      canPop: true,
      child: Scaffold(
        key: _scaffoldKey,
          body: Container(
            decoration:  BoxDecoration(
              gradient: backgroundGradient5,
            ),
            child: Consumer<RoleProvider>(builder: (context, provider, child) {
              return SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(child: const Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                                size: 28,
                              ),),
                              Expanded(
                                flex: 10,
                                child: Container(
                                  alignment: Alignment.topCenter,
                                  padding: const EdgeInsets.only(right: 40),
                                  child: Text(
                                    "Select Your Role",
                                    style: UtilityClass.poppins(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: kthemecolor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),


                        SizedBox(height: SizeConfig.screenHeight! * 0.01),
                        roleCard(
                          title: "Government Employee",
                          description:
                          "A job seeker is an individual who is actively looking for employment opportunities.",
                          imagePath: "assets/images/employee.png",
                          onTap: () {

                          },
                        ),
                        SizedBox(height: SizeConfig.screenHeight! * 0.01),
                        roleCard(
                          title: "Private / Other  Employee",
                          description:
                          "A job seeker is an individual who is actively looking for employment opportunities.",
                          imagePath: "assets/images/counselor.png",
                          onTap: () {

                          },
                        ),
                      ],
                    ),
                  ),
                ),

              );
            }),
          )));

  }

  Widget roleCard({
    required String title,
    required String description,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color:kTextColor1,
        borderRadius: BorderRadius.circular(12),

      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                imagePath,
                height: 60,
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.01),
            Text(
              title,
              style: UtilityClass.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color:kthemecolor,
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.01),
            Text(
              description,
              style: UtilityClass.poppins(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color:kthemecolor,
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.02),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex:9,
                      child: Container(
                        padding: EdgeInsets.only(left: SizeConfig.screenWidth! * 0.10),
                        alignment: Alignment.topCenter,
                        child:Text(
                            "Register",
                          style: UtilityClass.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color:kWhite,
                        ),
                        ),
                      ),
                    ),
                    Expanded(
                        flex:1,
                        child: Image.asset("assets/icons/right_arrow.png", color: Colors.white, width: 20,height: 20,)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
