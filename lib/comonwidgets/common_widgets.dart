import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../../l10n/app_localizations.dart';

class CommonWidgets {
  static PreferredSizeWidget Appbar(
      {required String title,
      required VoidCallback callback,
      List<Widget>? actions}) {
    return AppBar(
      title:
          Text(title, style: const TextStyle(color: kTextColor1, fontSize: 12)),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/backgrounds/HeaderBG.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      leading: IconButton(
        onPressed: callback,
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kPrimaryDark),
      ),
      actions: actions,
    );
  }

  static PreferredSizeWidget Appbarnavi(
      {required String title,
      required VoidCallback callback,
      List<Widget>? actions}) {
    return AppBar(
      title:
          Text(title, style: const TextStyle(color: kTextColor1, fontSize: 16)),
      backgroundColor: kBlackColor,
      iconTheme: const IconThemeData(color: kTextColor1),
      actions: actions,
    );
  }

  static PreferredSizeWidget Appbarnavi2({
    required String title,
    required VoidCallback callback,
    List<Widget>? actions,
    required BuildContext context,
  }) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(250), // Set app_en.arb bar height
      child: Container(
        height: 250,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/backgrounds/HeaderBG.png'), // Background image
            fit: BoxFit.cover, // Fit the image to the app bar size
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: callback,
                      child: Image.asset('assets/icons/Iconmenu.png',
                          width: 30, height: 30, color: kPrimaryDark),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ...?actions, // Add custom actions
                  ],
                ),
                const SizedBox(height: 16),

                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/logos/MahilaNidhiwhit.png',
                        width: 80,
                        height: 80,
                      ),
                      const SizedBox(width: 17),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Text(
                            //   AppLocalizations.of(context)!
                            //       .rajasthan_mahila_nidhi,
                            //   style: const TextStyle(
                            //     fontSize: 12,
                            //     color: kPrimaryDark,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                            // Text(
                            //   AppLocalizations.of(context)!.credit_co_Operative,
                            //   style: const TextStyle(
                            //     fontSize: 8,
                            //     color: kTextColor1,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                            // Text(
                            //   AppLocalizations.of(context)!.department_of_Rural,
                            //   style: const TextStyle(
                            //     fontSize: 8,
                            //     color: kTextColor1,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: Image.asset(
                          "assets/logos/ashok_stambh.png",
                          width: 75,
                          height: 55,
                          fit: BoxFit.fill,
                        ),
                      )
                    ],
                  ),
                )
                // Add additional widgets if required
              ],
            ),
          ),
        ),
      ),
    );
  }

  static PreferredSizeWidget Appbarnavi3({
    required String title,
    required VoidCallback callback,
    List<Widget>? actions,
    required BuildContext context,
  }) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(250), // Set app_en.arb bar height
      child: Container(
        height: 250,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/backgrounds/HeaderBG.png'), // Background image
            fit: BoxFit.cover, // Fit the image to the app bar size
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: callback,
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                        color: kTextColor1,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ...?actions, // Add custom actions
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/logos/MahilaNidhiwhit.png',
                        width: 100,
                        height: 80,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(
                            //   AppLocalizations.of(context)!
                            //       .rajasthan_mahila_nidhi,
                            //   style: const TextStyle(
                            //     fontSize: 15,
                            //     color: kTextColor1,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                            // Text(
                            //   AppLocalizations.of(context)!.credit_co_Operative,
                            //   style: const TextStyle(
                            //     fontSize: 10,
                            //     color: kTextColor1,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                            // Text(
                            //   AppLocalizations.of(context)!.department_of_Rural,
                            //   style: const TextStyle(
                            //     fontSize: 10,
                            //     color: kTextColor1,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                // Add additional widgets if required
              ],
            ),
          ),
        ),
      ),
    );
  }

  static PreferredSizeWidget AppbarJanAadhar({
    required String title,
    required VoidCallback callback,
    List<Widget>? actions,
    required BuildContext context,
  }) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(250), // Set app_en.arb bar height
      child: Container(
        height: 250,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/backgrounds/HeaderBG.png'), // Background image
            fit: BoxFit.cover, // Fit the image to the app bar size
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ...?actions, // Add custom actions
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/logos/MahilaNidhiwhit.png',
                        width: 80,
                        height: 80,
                      ),
                      const SizedBox(width: 17),
                      // Expanded(
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Text(
                      //         AppLocalizations.of(context)!
                      //             .rajasthan_mahila_nidhi,
                      //         style: const TextStyle(
                      //           fontSize: 12,
                      //           color: kPrimaryDark,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      //       Text(
                      //         AppLocalizations.of(context)!.credit_co_Operative,
                      //         style: const TextStyle(
                      //           fontSize: 8,
                      //           color: kTextColor1,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      //       Text(
                      //         AppLocalizations.of(context)!.department_of_Rural,
                      //         style: const TextStyle(
                      //           fontSize: 8,
                      //           color: kTextColor1,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      const SizedBox(width: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: Image.asset(
                          "assets/logos/ashok_stambh.png",
                          width: 75,
                          height: 55,
                          fit: BoxFit.fill,
                        ),
                      )
                    ],
                  ),
                )
                // Add additional widgets if required
              ],
            ),
          ),
        ),
      ),
    );
  }

  static PreferredSizeWidget AppbarJanAadharback({
    required String title,
    required VoidCallback callback,
    List<Widget>? actions,
    required BuildContext context,
  }) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(250), // Set app_en.arb bar height
      child: Container(
        height: 250,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/backgrounds/HeaderBG.png'), // Background image
            fit: BoxFit.cover, // Fit the image to the app bar size
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: callback,
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                        color: kTextColor1,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ...?actions, // Add custom actions
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/logos/MahilaNidhiwhit.png',
                        width: 80,
                        height: 80,
                      ),
                      const SizedBox(width: 17),
                      // Expanded(
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Text(
                      //         AppLocalizations.of(context)!
                      //             .rajasthan_mahila_nidhi,
                      //         style: const TextStyle(
                      //           fontSize: 12,
                      //           color: kPrimaryDark,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      //       Text(
                      //         AppLocalizations.of(context)!.credit_co_Operative,
                      //         style: const TextStyle(
                      //           fontSize: 8,
                      //           color: kTextColor1,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      //       Text(
                      //         AppLocalizations.of(context)!.department_of_Rural,
                      //         style: const TextStyle(
                      //           fontSize: 8,
                      //           color: kTextColor1,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      const SizedBox(width: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: Image.asset(
                          "assets/logos/ashok_stambh.png",
                          width: 75,
                          height: 55,
                          fit: BoxFit.fill,
                        ),
                      )
                    ],
                  ),
                )
                // Add additional widgets if required
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget NameAndRoleInfo(
      {required String fullName,
      required String userId,
      required String roleName,
      double? defaultSize}) {
    return Padding(
      padding: EdgeInsets.only(left: defaultSize!),
      child: Column(
        children: [
          Row(
            children: [
              Row(
                children: [
                  Text('Name:',
                      style: TextStyle(
                          fontSize: defaultSize! * 1.8,
                          color: kBlackColor,
                          fontWeight: FontWeight.bold)),
                  SizedBox(width: defaultSize),
                  Text('$fullName ($userId)',
                      style: TextStyle(
                          fontSize: defaultSize * 1.8,
                          color: kBlackColor,
                          fontWeight: FontWeight.bold)),
                ],
              )
            ],
          ),
          Row(
            children: [
              Text('Role:',
                  style: TextStyle(
                      fontSize: defaultSize * 1.8,
                      color: kBlackColor,
                      fontWeight: FontWeight.bold)),
              SizedBox(width: defaultSize * 2.2),
              Text('$roleName',
                  style: TextStyle(
                      fontSize: defaultSize * 1.8,
                      color: kBlackColor,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
