import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kin_app_sample/constants.dart';
import 'package:kin_app_sample/kinetic_controller.dart';
import 'package:kin_app_sample/screens/fill_up_seed.dart';
import 'package:kin_app_sample/screens/view_seed.dart';
import 'package:provider/provider.dart';

class Welcom extends StatelessWidget {
  static const String pageId = "/welcome_page";

  const Welcom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBcgrndColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 45),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: 414,
                height: 414,
                child: Align(
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    "assets/kin-logo-violet-aboveicon.svg",
                    color: kPurpleKin,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: RichText(
                    text: const TextSpan(children: [
                      TextSpan(
                        text: "Welcome to\n",
                        style: TextStyle(
                            fontSize: 36.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                      TextSpan(
                        text: "Kin",
                        style: TextStyle(
                            fontSize: 36.0,
                            fontWeight: FontWeight.w600,
                            color: kPurpleKin),
                      ),
                    ]),
                  ),
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 152,
                        height: 53,
                        child: ElevatedButton(
                          style: OutlinedButton.styleFrom(
                              backgroundColor: kBcgrndColor,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(13.3)),
                              )).copyWith(
                            side: MaterialStateProperty.resolveWith<BorderSide>(
                              (Set<MaterialState> states) {
                                return BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 1,
                                );
                              },
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, FillUpSeed.pageId);
                          },
                          child: const SizedBox(
                            width: 152,
                            height: 53,
                            child: Center(
                              child: Text(
                                "Import Wallet",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w500,
                                    color: kPurpleKin),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Consumer<KineticController>(
                          builder: (_, kinController, __) {
                        return SizedBox(
                          width: 152,
                          height: 53,
                          child: ElevatedButton(
                            style: OutlinedButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            )),
                            onPressed: () async {
                              showLoadingDialog(context);
                              try {
                                await kinController
                                    .createAccount()
                                    .then((trns) {
                                  if (trns != null) {
                                    Navigator.pushNamed(
                                        context, ShowSeed.pageId);
                                  }
                                });
                              } catch (e) {
                                Navigator.pop(context);
                                Future.delayed(const Duration(milliseconds: 20))
                                    .then((value) {
                                  showErrorDialog(context, e.toString());
                                });
                              }
                            },
                            child: const Center(
                              child: Text(
                                "Create Wallet",
                                style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              // Align(
              //   alignment: Alignment.bottomRight,
              //   child: SvgPicture.asset(
              //     "assets/Next.svg",
              //     height: 48,
              //     width: 48,
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
