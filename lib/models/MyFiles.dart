import 'package:twiza/constants.dart';
import 'package:flutter/material.dart';

class CloudStorageInfo {
  final String? svgSrc, title, totalStorage;
  final int? numOfFiles, percentage;
  final Color? color;

  CloudStorageInfo({
    this.svgSrc,
    this.title,
    this.totalStorage,
    this.numOfFiles,
    this.percentage,
    this.color,
  });
}

List demoMyFiles = [
  CloudStorageInfo(
    title: "ملابس",
    numOfFiles: 1328,
    svgSrc: "assets/icons/clothes.svg",
    totalStorage: "1.9GB",
    color: Colors.purple,
    percentage: 35,
  ),
  CloudStorageInfo(
    title: "التعليم",
    numOfFiles: 1328,
    svgSrc: "assets/icons/education.svg",
    totalStorage: "2.9GB",
    color: Color(0xFFFFA113),
    percentage: 35,
  ),
  CloudStorageInfo(
    title: "الدم",
    numOfFiles: 1328,
    svgSrc: "assets/icons/blood.svg",
    totalStorage: "1GB",
    color: Colors.red,
    percentage: 10,
  ),
  CloudStorageInfo(
    title: "سيارة الإسعاف",
    numOfFiles: 5328,
    svgSrc: "assets/icons/ambulance.svg",
    totalStorage: "7.3GB",
    color: Color(0xFF007EE5),
    percentage: 78,
  ),
  CloudStorageInfo(
    title: "الإمدادات الغذائية",
    numOfFiles: 5328,
    svgSrc: "assets/icons/food.svg",
    totalStorage: "0.3GB",
    color: Colors.teal,
    percentage: 48,
  ),
  CloudStorageInfo(
    title: "دواء",
    numOfFiles: 5328,
    svgSrc: "assets/icons/pharmacy.svg",
    totalStorage: "1.3GB",
    color: Colors.green,
    percentage: 60,
  ),
];
