import 'package:flutter/material.dart';
import 'package:kin_app_sample/homePage.dart';
import 'package:kin_app_sample/kinetic_controller.dart';
import 'package:kinetic/interfaces/kinetic_sdk_config.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  KineticController controller = KineticController();
  @override
  void initState() {
    initiateKin();
    super.initState();
  }

  initiateKin() {
    controller.initialize().then((_) {
      print("Kin initialized");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          // primarySwatch: Colors.black,
          ),
      home: ChangeNotifierProvider(
        create: (context) => KineticController(),
        child: MyHomePage(
          kineticController: controller,
        ),
      ),
    );
  }
}
