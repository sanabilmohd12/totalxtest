import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:totalxtest/features/login/presentation/provider/loginprovider.dart';

class otpPage extends StatelessWidget {
  String mobile;

  otpPage({super.key, required this.mobile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<Loginprovider>(builder: (context, logpro, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 100,
            ),

            Text(
              "Enter the verification code we just sent to your number +91 *******${mobile.substring(
                7,
              )}",
              style: const TextStyle(color: Colors.black, fontSize: 12),
            ),
            const SizedBox(
              height: 40,
            ),

            Pinput(
              controller: logpro.otpcontroller,
              length: 6,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              defaultPinTheme: PinTheme(
                  textStyle:
                      const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.transparent,
                          blurRadius: 2.0, // soften the shadow
                          spreadRadius: 1.0, //extend the shadow
                        ),
                      ],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        width: 2,
                        color: const Color(0xFF6B526B),
                      ))),
              onCompleted: (pin) {
                logpro.verifyOTP(context, logpro.otpcontroller.text);
              },
            ),

            // Center(
            //   child: Text(
            //     "59 sec",
            //     style: TextStyle(fontSize:14 ,color: Colors.red),
            //   ),
            // ),
            //
            // Center(
            //   child: RichText(
            //     text: TextSpan(
            //       style: TextStyle(
            //           color: Colors.black,
            //           fontSize: 14,
            //           fontWeight: FontWeight.w400),
            //       children: [
            //         TextSpan(text: "Don't Get OTP? "),
            //         TextSpan(
            //           text: 'Resend',
            //           style: TextStyle(
            //               decoration: TextDecoration.underline,
            //               color: Colors.blue),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            const SizedBox(height: 60.0),

            Center(
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                    fixedSize: const Size(300, 60),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60))),
                child: const Text(
                  'Verify',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
