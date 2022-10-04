import 'package:flutter/material.dart';
import 'package:kin_app_sample/constants.dart';
import 'package:kin_app_sample/home-page.dart';
import 'package:kin_app_sample/kinetic_controller.dart';
import 'package:provider/provider.dart';

class FillUpSeed extends StatelessWidget {
  static const String pageId = "FillUpSeed_page";

  FillUpSeed({Key? key}) : super(key: key);
  TextEditingController mnemonicTEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset= false,
      appBar: AppBar(
        backgroundColor: kBcgrndColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Fill Up Mnemonic",
          style: TextStyle(
              fontSize: 19, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
      backgroundColor: kBcgrndColor,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * 0.8),
          child: IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(
                  height: 36,
                ),
                Padding(
                    padding:
                        const EdgeInsets.only(left: 24, right: 24, bottom: 45),
                    child: Align(
                        alignment: Alignment.center,
                        child: TextFormField(
                          enabled: true,
                          controller: mnemonicTEC,
                          onChanged: (value) {
                            print("value");
                          },
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                                left: 15, top: 4, bottom: 15),
                            fillColor: kGrey,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: kPurpleKin, width: 1),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: kPurpleKin, width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: kPurpleKin, width: 1),
                            ),
                            floatingLabelAlignment:
                                FloatingLabelAlignment.start,
                          ),
                        ))),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 50,
                    height: 53,
                    child: Consumer<KineticController>(
                        builder: (_, kineticController, __) {
                      return ElevatedButton(
                        style: OutlinedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        )),
                        onPressed: () async {
                          if (mnemonicTEC.text.split(' ').length == 12 ||
                              mnemonicTEC.text.split(' ').length == 24) {
                            showLoadingDialog(context);
                            final kp = await kineticController
                                .generateKeyPairFromMnemonic(
                                    mnemonicTEC.text.toString());
                            if (kp != null) {
                              Future.delayed(Duration.zero).then((value) {
                                Navigator.pushNamed(context, MyHomePage.pageId);
                              });
                            }
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content:
                                  Text("Seed phrase must be 12 or 24 long"),
                            ));
                          }
                        },
                        child: Container(
                          width: 152,
                          height: 53,
                          decoration: const BoxDecoration(
                              color: kPurpleKin,
                              //  border: Border.all(width: 2.2, color: kPurpleKin),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: const Center(
                            child: Text(
                              "Import Wallet",
                              style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
