import 'package:flutter/material.dart';
import 'package:kin_app_sample/constants.dart';

class SeedText extends StatelessWidget {
  const SeedText({Key? key, required this.phrase}) : super(key: key);
  final String phrase;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 43,
      width: 103,
      decoration: BoxDecoration(
          color: kBcgrndColor,
          border: Border.all(color: kPurpleKin.withOpacity(0.5), width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 2),
                blurRadius: 4,
                spreadRadius: 0,
                color: Colors.white.withOpacity(0.05))
          ]),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          phrase,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 17,
              color: Colors.white,
              fontFamily: 'NeueHaasDisplayBold'),
        ),
      ),
    );
  }
}
