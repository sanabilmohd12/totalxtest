import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totalxtest/features/home/presentation/view/home_screen.dart';
import 'package:totalxtest/features/login/presentation/view/otppage.dart';


class Loginprovider extends ChangeNotifier {
  TextEditingController loginnumber = TextEditingController();
  TextEditingController otpcontroller = TextEditingController();

  String VerificationId = "";

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  FirebaseAuth auth = FirebaseAuth.instance;

  bool loader = false;

  void clearLoginPageNumber() {
    loginnumber.clear();
    otpcontroller.clear();
  }

  void sendOTP(BuildContext context) async {
    loader = true;
    notifyListeners();
    await auth.verifyPhoneNumber(
      phoneNumber: "+91${loginnumber.text}",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.white,
          content: Text("Verification Completed ",
              style: TextStyle(
                color: Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              )),
          duration: Duration(milliseconds: 3000),
        ));
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == "invalid-phone-number") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Sorry, Verification Failed "),
            duration: Duration(milliseconds: 3000),
          ));
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        VerificationId = verificationId;
        loader = false;
        notifyListeners();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => otpPage(
                mobile: loginnumber.text,
              ),
            ));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Color(0xbd380038),
          content: Text("OTP sent to phone successfully",
              style: TextStyle(
                color: Color(0xffffffff),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              )),
          duration: Duration(milliseconds: 3000),
        ));
        log("Verification Id : $verificationId");
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      timeout: const Duration(seconds: 60),
    );
  }

  void verifyOTP(BuildContext context, String enteredOtp) async {
    if (enteredOtp.isNotEmpty) {
      try {
        final loginProvider =
            Provider.of<Loginprovider>(context, listen: false);
        loginProvider.setLoading(true);

        // Call verify method from loginProvider to verify OTP
        await loginProvider.verify(context, enteredOtp);

        if (FirebaseAuth.instance.currentUser != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('OTP verification failed, please try again.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Error verifying OTP. Please try again.')),
        );
      } finally {
        Provider.of<Loginprovider>(context, listen: false).setLoading(false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the OTP')),
      );
    }
  }

  Future<void> verify(BuildContext context, String enteredOtp) async {
    try {
      loader = true; // Show loading indicator
      notifyListeners();

      // OTP verification logic goes here (e.g., using Firebase)
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId:
            VerificationId, // Ensure you have a valid verification ID
        smsCode: enteredOtp,
      );
      await auth.signInWithCredential(credential); // Sign in with the OTP

      loader = false; // Hide loading indicator after verification
      notifyListeners();
    } catch (e) {
      loader = false;
      notifyListeners();
      print("Error during OTP verification: $e");
      throw Exception("Verification failed");
    }
  }
}
