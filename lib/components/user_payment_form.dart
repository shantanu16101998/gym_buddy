import 'package:flutter/material.dart';
import 'package:gym_buddy/components/custom_text.dart';
import 'package:gym_buddy/components/qr_code_pic.dart';
import 'package:gym_buddy/screens/subscription.dart';
import 'package:gym_buddy/utils/ui_constants.dart';

class UserPaymentForm extends StatefulWidget {
  final Function onPageToShowChange;
  const UserPaymentForm({super.key, required this.onPageToShowChange});

  @override
  State<UserPaymentForm> createState() => _UserPaymentFormState();
}

// BackdropFilter(
//       filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
//       child:

class _UserPaymentFormState extends State<UserPaymentForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: getScreenWidth(context) * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromARGB(255, 85, 84, 84).withOpacity(0.95),
      ),
      child: Column(
        children: [
          const Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomText(
              text: "Please verify your upi id",
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: QrCodePic(qrColor: Colors.white),
                )),
          ),
          const Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomText(
              text: "UPI ID",
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 20),
            child: CustomText(
              text: "shantanu16101998@okhdfcbank",
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Align(
              alignment: Alignment.center,
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 50, top: 30),
                  child: SizedBox(
                      height: 50,
                      width: 178,
                      child: ElevatedButton(
                          onPressed: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Subscription()))
                              },
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: const Color(0xFFD9D9D9)),
                          child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Text("Sign up",
                                  style: TextStyle(
                                      color: Color(0xff004576),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)))))))
        ],
      ),
    );
  }
}
