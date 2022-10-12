import 'package:flutter/material.dart';

const Color kBcgrndColor = Color(0xff211d30);
const Color kPurpleKin = Color(0xff7546f6);
const Color kGrey = Color(0xff292638);
const Color kLighGrey = Color(0xffA7AEBF);
const Color kDarkGrey = Color(0xff272727);
showLoadingDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: SizedBox(
            height: 45,
            width: 45,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(kPurpleKin),
            ),
          ),
        );
      });
}

showErrorDialog(BuildContext context, String message) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: kGrey,
          title: Text(
            "Error\n $message",
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Colors.white),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Ok"))
          ],
        );
      });
}

showModalButtom(
    BuildContext context,
    double height,
    Function callback,
    String buttonTex,
    String headLine,
    TextEditingController xTEC,
    TextInputType inputType,
    {List<Widget>? widgets}) {
  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: height,
            decoration: BoxDecoration(
                color: kGrey,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(3, 8),
                    blurRadius: 8,
                    spreadRadius: 2,
                    color: Colors.black.withOpacity(0.3),
                  )
                ]),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 32, left: 24, right: 24, bottom: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      headLine,
                      style: const TextStyle(
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
                      controller: xTEC,
                      onChanged: (value) {},
                      keyboardType: inputType,
                      maxLines: null,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.only(left: 15, top: 4, bottom: 15),
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
                        floatingLabelAlignment: FloatingLabelAlignment.start,
                      ),
                    ),
                  ),
                  ...widgets!,
                  const Spacer(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 100,
                    height: 53,
                    child: ElevatedButton(
                      style: OutlinedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      )),
                      onPressed: () async {
                        callback();
                      },
                      child: Center(
                        child: Text(
                          buttonTex,
                          style: const TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      });
}
