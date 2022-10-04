import 'package:flutter/material.dart';
import 'package:kin_app_sample/constants.dart';
import 'package:kin_app_sample/home-page.dart';
import 'package:kin_app_sample/kinetic_controller.dart';
import 'package:kin_app_sample/screens/widgets/seed_phrase.dart';
import 'package:provider/provider.dart';

class ShowSeed extends StatelessWidget {
  static const String pageId = "showSeed_page";

  const ShowSeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBcgrndColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Mnemonic",
          style: TextStyle(
              fontSize: 19, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
      backgroundColor: kBcgrndColor,
      body: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 45),
          child: Column(
            children: [
              const SizedBox(
                height: 36,
              ),
              const Text(
                "Store this phrase in a safe place, and don't share it with others",
                style: TextStyle(
                    color: kLighGrey,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 24,
              ),
              Consumer<KineticController>(builder: (_, kinneticController, __) {
                return GridView.builder(
                    shrinkWrap: true,
                    itemCount: kinneticController.kp != null
                        ? kinneticController.kp.length
                        : 0,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            // maxCrossAxisExtent: 200.0,
                            mainAxisSpacing: 12.0,
                            crossAxisSpacing: 12.0,
                            childAspectRatio: 2.5,
                            // mainAxisExtent: 0.0,
                            crossAxisCount: 3),
                    itemBuilder: (context, index) {
                      return SeedText(phrase: kinneticController.kp[index]);
                    });
              }),
              const Spacer(),
              SizedBox(
                width: MediaQuery.of(context).size.width - 50,
                height: 53,
                child: ElevatedButton(
                  style: OutlinedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  )),
                  onPressed: () async {
                    Navigator.pushNamed(context, MyHomePage.pageId);
                  },
                  child: Container(
                    width: 152,
                    height: 53,
                    decoration: const BoxDecoration(
                        color: kPurpleKin,
                        //  border: Border.all(width: 2.2, color: kPurpleKin),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: const Center(
                      child: Text(
                        "Continue",
                        style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
