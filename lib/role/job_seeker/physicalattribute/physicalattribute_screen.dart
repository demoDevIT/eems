import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/role/job_seeker/physicalattribute/provider/physicalattribute_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/global.dart';
import '../../../utils/user_new.dart';
import '../addphysicalattribute/addphysicalattribute_screen.dart';
import '../loginscreen/provider/locale_provider.dart';

class PhysicalattributeScreen extends StatefulWidget {
  const PhysicalattributeScreen({super.key});

  @override
  State<PhysicalattributeScreen> createState() =>
      _PhysicalattributeScreenState();
}

class _PhysicalattributeScreenState extends State<PhysicalattributeScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final provider =
      Provider.of<PhysicalattributeProvider>(context, listen: false);
      provider.clearData();
       provider.physicalattributeApi(context);
    });

  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
        appBar: commonAppBar2("Physical Attributes", context,
            localeProvider.currentLanguage, "", false, "", onTapClick: () {
              localeProvider.toggleLocale();
            }),

        body: Consumer<PhysicalattributeProvider>(builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Physical Attributes Summary",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
              provider.physicalattributeList.isEmpty
                  ? GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddphysicalattributeScreen(
                        isUpdate: false,
                        profilePhysicalAttributeData: null,
                      ),
                    ),
                  );
                  if (result != null) {
                    provider.physicalattributeApi(context);
                  }
                },
                child: DashedBorderContainer(
                  child: Container(
                    height: 80,
                    width: double.infinity,
                    margin: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/plus.svg',
                          height: 25,
                          width: 25,
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Update Physical Attributes",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              )
                  : const SizedBox(),


              provider.physicalattributeList.isEmpty ?  hSpace(20) : hSpace(0),
                // Card with physical attributes
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,

                    physics: const BouncingScrollPhysics(),
                    itemCount: provider.physicalattributeList.length,
                    itemBuilder: (context, index) {
                      final dataPhysical = provider.physicalattributeList[index];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 5,
                              spreadRadius: 2,
                            ),
                          ],
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      "Physical Details",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade50,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child:  Text(
                                        checkNullValue(dataPhysical.bloodGroupName.toString()),
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 10),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap:() async {
                                        final result = await  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>  AddphysicalattributeScreen(isUpdate: true,profilePhysicalAttributeData: provider.physicalattributeList[index],),
                                          ),
                                        );
                                        if (result != null) {
                                          provider.physicalattributeApi(context);
                                        }


                                      },
                                      child: SvgPicture.asset(
                                        'assets/icons/edit.svg',
                                        height: 20,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    InkWell(
                                      onTap: () {
                                        confirmAlertDialog(context, "Alert","Are you sure want to delete ?", (value) {
                                          if (value.toString() == "success") {
                                            provider.deleteDetailProfileApi(context,dataPhysical.physicalDetailID.toString());
                                          }
                                        },
                                        );
                                      },
                                      child: SvgPicture.asset(
                                        'assets/icons/trash.svg',
                                        height: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Left column
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:  [
                                      Text("Height: ${checkNullValue(dataPhysical.heightInCMS.toString())}" + "cm",
                                          style: TextStyle(
                                              fontSize: 12
                                          )
                                      ),
                                      SizedBox(height: 6),
                                      if (UserData().model.value.gENDER != "Female")
                                      Text("Chest :${checkNullValue(dataPhysical.chestInCMS.toString())}" + "cm",
                                          style: TextStyle(
                                              fontSize: 12
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:  [
                                      Text("Eye Sight: ${checkNullValue(dataPhysical.eyeSight.toString())}" + "cm",
                                          style: TextStyle(
                                              fontSize: 12
                                          )
                                      ),
                                      SizedBox(height: 6),
                                      Text("Pwd :${dataPhysical.isDisablity.toString() == "1" ? "yes" : "No"}",
                                          style: TextStyle(
                                              fontSize: 12
                                          )
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            ),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Left column

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:  [
                                      Text("Disability: ${checkNullValue(dataPhysical.disabilityName.toString())}",
                                          style: TextStyle(
                                              fontSize: 12
                                          )
                                      ),
                                      SizedBox(height: 6),
                                      Text("Percentage: ${checkNullValue(dataPhysical.disabilityPercentage.toString())}" + "%",
                                          style: TextStyle(
                                              fontSize: 12
                                          )
                                      ),
                                    ],
                                  ),
                                ),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:  [
                                      Text("Weight: ${checkNullValue(dataPhysical.weightInKG.toString())}",
                                          style: TextStyle(
                                              fontSize: 12
                                          )
                                      ),
                                      SizedBox(height: 6),
                                      // Text("Percentage: ${checkNullValue(dataPhysical.disabilityPercentage.toString())}" + "%",
                                      //     style: TextStyle(
                                      //         fontSize: 12
                                      //     )
                                      // ),
                                    ],
                                  ),
                                ),

                              ],
                            ),

                            const SizedBox(height: 12),

                          ],
                        ),
                      );
                    },
                  ),
                ),


              ],
            ),
          );
        }));


  }
}

class DashedBorderContainer extends StatelessWidget {
  final Widget child;

  const DashedBorderContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedRectPainter(),
      child: child,
    );
  }
}

class DashedRectPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 6.0;
    const dashSpace = 4.0;
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(12),
    );

    final path = Path()..addRRect(rect);
    final metrics = path.computeMetrics().first;

    double distance = 0.0;
    while (distance < metrics.length) {
      final segment = metrics.extractPath(
        distance,
        distance + dashWidth,
      );
      canvas.drawPath(segment, paint);
      distance += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
