import 'package:flutter/material.dart';
import 'package:kin_app_sample/constants.dart';
import 'package:kin_app_sample/home-page.dart';
import 'package:kin_app_sample/kinetic_controller.dart';
import 'package:kin_app_sample/screens/fill_up_seed.dart';
import 'package:kin_app_sample/screens/view_seed.dart';
import 'package:kin_app_sample/screens/welcom.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(ChangeNotifierProvider(
      create: (context) => KineticController(), child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  KineticController controller = KineticController();

  bool? isWalletAvailable;
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
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: const MaterialColor(0xff6F41E7, <int, Color>{
              50: kPurpleKin,
              100: kPurpleKin,
              200: kPurpleKin,
              300: kPurpleKin,
              400: kPurpleKin,
              500: kPurpleKin,
              600: kPurpleKin,
              700: kPurpleKin,
              800: kPurpleKin,
              900: kPurpleKin,
            }),
            fontFamily: 'NeueHaasDisplayBold'),
        routes: {
          MyHomePage.pageId: (_) => const MyHomePage(),
          Welcom.pageId: (_) => const Welcom(),
          ShowSeed.pageId: (_) => const ShowSeed(),
          FillUpSeed.pageId: (_) => FillUpSeed(),
        },
        initialRoute: MyHomePage.pageId);
  }
}
