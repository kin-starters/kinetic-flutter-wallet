import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kin_app_sample/constants.dart';
import 'package:kin_app_sample/kinetic_controller.dart';
import 'package:kin_app_sample/screens/welcom.dart';
import 'package:kinetic/generated/lib/api.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  static const String pageId = "/home_page";
  const MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  KineticController controller = KineticController();
  TextEditingController fundTEC = TextEditingController();
  TextEditingController transferAmountTEC = TextEditingController();
  TextEditingController transferToTEC = TextEditingController();

  String balance = "";
  String publicKey = "";
  @override
  void initState() {
    _InitialiseHome();
    checkIsWalletAvailable();
    super.initState();
  }

  Future<void> checkIsWalletAvailable() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final available = prefs.getString("KEYPAIR");
      if (available != "" && available != null) {
      } else {
        Future.delayed(Duration.zero).then((value) {
          Navigator.pushReplacementNamed(
            context,
            Welcom.pageId,
          );
        });
      }
    } catch (e) {}
  }

  _InitialiseHome() async {
    await controller.getBalance().then((_) {
      if (mounted) {
        setState(() {
          balance = (int.parse(controller.balanceResponse!.balance) / 100000)
              .toString();

          publicKey = controller.publicKey!.publicKey;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBcgrndColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Home",
          style: TextStyle(
              fontSize: 19, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
      backgroundColor: kBcgrndColor,
      body: Center(child:
          Consumer<KineticController>(builder: (_, kineticController, __) {
        return Column(children: [
          SizedBox(
            height: 36,
            width: 357,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.exit_to_app_outlined),
                    onPressed: () async {
                      _handleExitButton(() async {
                        showLoadingDialog(context);
                        try {
                          final delete = await kineticController.deleteWallet();
                          if (delete == true) {
                            Future.delayed(Duration.zero).then((value) {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, Welcom.pageId, (route) => false);
                            });
                          } else {
                            Future.delayed(Duration.zero).then((value) {
                              showErrorDialog(context, 'Error deleting wallet');
                            });
                          }
                        } catch (e) {
                          showErrorDialog(context, e.toString());
                        }
                      });
                    },
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              Container(
                height: 100,
                width: 327,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xff96C9F0).withOpacity(0.8),
                        const Color(0xffB2CEDD).withOpacity(0.8),
                        const Color(0xffFDD9A7).withOpacity(0.8),
                        const Color(0xffF3DBB0).withOpacity(0.8),
                        const Color(0xffD78691).withOpacity(0.8),
                        const Color(0xffB1357B).withOpacity(0.8),
                        const Color(0xffB1357B).withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(5, 10),
                        blurRadius: 10,
                        spreadRadius: 0,
                        color: Colors.black,
                      )
                    ]),
              ),
              Positioned.fill(
                child: Container(
                  height: 100,
                  width: 327,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    color: Colors.white.withOpacity(0.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12, left: 19),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "KIN Balance\n",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Roboto',
                              color: kDarkGrey),
                        ),
                        Text(
                          _parseBalence(kineticController.balanceResponse),
                          style: const TextStyle(
                              fontSize: 35.0,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Roboto',
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          SizedBox(
            width: 327,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                MaterialButton(
                  padding: EdgeInsets.zero,
                  highlightColor: kBcgrndColor,
                  splashColor: kBcgrndColor,
                  onPressed: () {
                    showModalButtom(context, 250, () async {
                      showLoadingDialog(context);
                      await kineticController
                          .fund(int.parse(fundTEC.text.toString()))
                          .then((_) {
                        setState(() {
                          fundTEC = TextEditingController();
                        });
                        if (kineticController.requestAirdropResponse != null) {
                          Future.delayed(Duration.zero).then((value) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          });
                        } else {
                          Future.delayed(Duration.zero).then((value) {
                            showErrorDialog(
                                context, "Error requesting Air drop");
                          });
                        }
                      });
                    }, "Confirm", "Amount", fundTEC, TextInputType.number,
                        widgets: []);
                  },
                  child: Container(
                    height: 80,
                    width: 140,
                    decoration: BoxDecoration(
                        color: kGrey,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(3, 8),
                            blurRadius: 8,
                            spreadRadius: 2,
                            color: Colors.black.withOpacity(0.3),
                          )
                        ]),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 12, left: 12),
                      child: Text(
                        "Fund Wallet",
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                MaterialButton(
                  highlightColor: kBcgrndColor,
                  splashColor: kBcgrndColor,
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    showModalButtom(context, 400, () async {
                      showLoadingDialog(context);
                      await kineticController
                          .transfer(
                              int.parse(transferAmountTEC.text.toString()),
                              transferToTEC.text.toString())
                          .then((_) {
                        if (kineticController.currentTransaction != null) {
                          setState(() {
                            transferAmountTEC = TextEditingController();
                            transferToTEC = TextEditingController();
                          });
                          Future.delayed(Duration.zero).then((value) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          });
                        } else {
                          Future.delayed(Duration.zero).then((value) {
                            showErrorDialog(
                                context, "Error requesting Air drop");
                          });
                        }
                      });
                    }, "Confirm", "Transfer to", transferToTEC,
                        TextInputType.text,
                        widgets: [
                          const SizedBox(
                            height: 18,
                          ),
                          const Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Transfer amount",
                              style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                            ),
                            child: TextFormField(
                              enabled: true,
                              controller: transferAmountTEC,
                              onChanged: (value) {},
                              keyboardType: TextInputType.number,
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
                                  borderSide: const BorderSide(
                                      color: kPurpleKin, width: 1),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: kPurpleKin, width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: kPurpleKin, width: 1),
                                ),
                                floatingLabelAlignment:
                                    FloatingLabelAlignment.start,
                              ),
                            ),
                          ),
                        ]);
                  },
                  child: Container(
                    height: 80,
                    width: 140,
                    decoration: BoxDecoration(
                        color: kGrey,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(3, 8),
                            blurRadius: 8,
                            spreadRadius: 2,
                            color: Colors.black.withOpacity(0.3),
                          )
                        ]),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 12, left: 12),
                      child: Text(
                        "Transfer",
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 70,
          ),
          publicKey != ""
              ? InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: publicKey));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                        "Text copied to Clipboard",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      backgroundColor: kGrey,
                    ));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.copy,
                        color: kLighGrey,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        publicKey,
                        style: const TextStyle(color: kLighGrey, fontSize: 12),
                      ),
                    ],
                  ),
                )
              : const SizedBox()
        ]);
      })),
    );
  }

  _parseBalence(BalanceResponse? thisBalance) {
    if (thisBalance == null) {
      if (balance != "") {
        if (balance[0] != '0') {
          return (double.parse(balance)).toString();
        }
      }
      return balance;
    } else {
      if (thisBalance.balance[0] != '0') {
        return (double.parse(thisBalance.balance) / 100000).toString();
      } else {
        return thisBalance.balance;
      }
    }
  }

  _handleExitButton(Function callback) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: kGrey,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            title: const Text(
              "Wallet Exit",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            actions: [
              const Center(
                child: Text(
                  "Are you sure you want to exit your wallet?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      onPressed: () {
                        callback();
                      },
                      child: const Text("Exit Wallet",
                          style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w600,
                              color: kPurpleKin))),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel",
                        style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600,
                            color: kPurpleKin)),
                  ),
                ],
              )
            ],
          );
        });
  }
}
