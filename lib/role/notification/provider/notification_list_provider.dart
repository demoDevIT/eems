import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/user_new.dart';

import '../../../../repo/common_repo.dart';

class NotificationListProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  NotificationListProvider({required this.commonRepo});

  final List<Map<String, String>> educationList = [
    {
      "name": "Techical Support Specialist",
      "type": "Part-time",
      "salary": "₹20,000 - ₹25,000",
      "collage": "Information Technology...",
      "address": "Jaipur, Raj....",

    },
    {
      "name": "Senior UX Designer",
      "type": "Full-Time",
      "salary": "₹20,000 - ₹25,000",
      "collage": "Synarion IT Solutions",
      "address": "Jaipur, Raj....",

    },


    {
      "name": "Techical Support Specialist",
      "type": "Part-time",
      "salary": "₹20,000 - ₹25,000",
      "collage": "Information Technology...",
      "address": "Jaipur, Raj....",

    },
    {
      "name": "Senior UX Designer",
      "type": "Full-Time",
      "salary": "₹20,000 - ₹25,000",
      "collage": "Synarion IT Solutions",
      "address": "Jaipur, Raj....",

    },
    {
      "name": "Techical Support Specialist",
      "type": "Part-time",
      "salary": "₹20,000 - ₹25,000",
      "collage": "Information Technology...",
      "address": "Jaipur, Raj....",

    },
    {
      "name": "Senior UX Designer",
      "type": "Full-Time",
      "salary": "₹20,000 - ₹25,000",
      "collage": "Synarion IT Solutions",
      "address": "Jaipur, Raj....",

    },
    {
      "name": "Techical Support Specialist",
      "type": "Part-time",
      "salary": "₹20,000 - ₹25,000",
      "collage": "Information Technology...",
      "address": "Jaipur, Raj....",

    },
    {
      "name": "Senior UX Designer",
      "type": "Full-Time",
      "salary": "₹20,000 - ₹25,000",
      "collage": "Synarion IT Solutions",
      "address": "Jaipur, Raj....",

    },
    {
      "name": "Techical Support Specialist",
      "type": "Part-time",
      "salary": "₹20,000 - ₹25,000",
      "collage": "Information Technology...",
      "address": "Jaipur, Raj....",

    },
    {
      "name": "Senior UX Designer",
      "type": "Full-Time",
      "salary": "₹20,000 - ₹25,000",
      "collage": "Synarion IT Solutions",
      "address": "Jaipur, Raj....",

    },
    {
      "name": "Techical Support Specialist",
      "type": "Part-time",
      "salary": "₹20,000 - ₹25,000",
      "collage": "Information Technology...",
      "address": "Jaipur, Raj....",

    },
    {
      "name": "Senior UX Designer",
      "type": "Full-Time",
      "salary": "₹20,000 - ₹25,000",
      "collage": "Synarion IT Solutions",
      "address": "Jaipur, Raj....",

    },
    {
      "name": "Techical Support Specialist",
      "type": "Part-time",
      "salary": "₹20,000 - ₹25,000",
      "collage": "Information Technology...",
      "address": "Jaipur, Raj....",

    },
    {
      "name": "Senior UX Designer",
      "type": "Full-Time",
      "salary": "₹20,000 - ₹25,000",
      "collage": "Synarion IT Solutions",
      "address": "Jaipur, Raj....",

    },
    {
      "name": "Techical Support Specialist",
      "type": "Part-time",
      "salary": "₹20,000 - ₹25,000",
      "collage": "Information Technology...",
      "address": "Jaipur, Raj....",

    },
    {
      "name": "Senior UX Designer",
      "type": "Full-Time",
      "salary": "₹20,000 - ₹25,000",
      "collage": "Synarion IT Solutions",
      "address": "Jaipur, Raj....",

    },


  ];




  @override
  void dispose() {
    super.dispose();
  }


}
