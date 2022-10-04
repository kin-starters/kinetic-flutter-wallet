import 'package:flutter/material.dart';
import 'package:kin_app_sample/constants.dart';

class Starter extends StatelessWidget {
  static const String pageId = "Starter_page";

  const Starter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBcgrndColor,
      body: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 45),
          child: Container()),
    );
  }
}
