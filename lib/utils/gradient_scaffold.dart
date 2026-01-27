import 'package:flutter/material.dart';
import 'package:rajemployment/constants/colors.dart';

 class GradientScaffold extends StatelessWidget {
  final Widget body;
  final Widget? floatingActionButton;

  const GradientScaffold({
    super.key,
    required this.body,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration:  BoxDecoration(
          gradient: backgroundGradient5,
        ),
        child: body,
      ),
    );
  }
}
