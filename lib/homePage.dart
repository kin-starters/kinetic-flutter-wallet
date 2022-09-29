import 'package:flutter/material.dart';
import 'package:kin_app_sample/kinetic_controller.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({required this.kineticController, Key? key}) : super(key: key);
  KineticController kineticController;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child:
          Consumer<KineticController>(builder: (_, kineticController, __) {
        return Column(
          children: [
            MaterialButton(
              color: Colors.yellow,
              onPressed: () {
                kineticController.createAccount();
              },
              child: const Text("create account"),
            ),
            MaterialButton(
              color: Colors.green,
              onPressed: () {
                kineticController.getBalance();
              },
              child: const Text("get Balance"),
            ),
            Text(kineticController.balanceResponse != null
                ? kineticController.balanceResponse!.balance
                : "undefined"),
            MaterialButton(
              color: Colors.pink,
              onPressed: () {
                kineticController.fund(10);
              },
              child: const Text("fund (10)"),
            ),
            Text(kineticController.requestAirdropResponse != null
                ? kineticController.requestAirdropResponse!.signature
                : "undefined"),
            MaterialButton(
              color: Colors.red.withOpacity(0.4),
              onPressed: () {
                kineticController.transfer(10);
              },
              child: const Text("transfer (10)"),
            ),
            Text(kineticController.currentTransaction != null
                ? kineticController.currentTransaction!.createdAt.toString()
                : "undefined"),
          ],
        );
      })),
    );
  }
}
