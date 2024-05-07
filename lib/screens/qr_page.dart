import 'package:flutter/material.dart';
import 'package:gym_buddy/components/app_scaffold.dart';
import 'package:gym_buddy/components/custom_text.dart';
import 'package:gym_buddy/components/qr_code_pic.dart';
import 'package:gym_buddy/utils/ui_constants.dart';
import 'package:google_fonts/google_fonts.dart';

class QrPage extends StatefulWidget {
  const QrPage({super.key});

  @override
  State<QrPage> createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        isApiDataLoaded: true,
        bodyColor: Color(0xff172B76),
        child: Stack(children: [
          Container(
            color: Color(0xff00BDF1),
            height: getEffectiveScreenHeight(context) * 0.5,
          ),
          Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: getEffectiveScreenHeight(context) * 0.2),
                  child: Container(
                    alignment: Alignment.center,
                    width: getScreenWidth(context) * 0.8,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(28)),
                    // height: getScreenHeight(context) * 0.2,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: getEffectiveScreenHeight(context) * 0.04 ,bottom: 10),
                          child: const CustomText(
                              text: "SCAN QR TO PAY",
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff344054)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 10, left: 20, right: 20, bottom: 20),
                          child: QrCodePic(qrColor: Colors.black,upiIntentLink: ""),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Color(0xffD4F0FD),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(28),
                                    bottomRight: Radius.circular(28))),
                            width: double.infinity,
                            child: const Padding(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  CustomText(
                                      text: "UPI ID",
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff344054)),
                                  CustomText(
                                    text: "shantanu@okhdfcbank",
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff000000),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: SizedBox(
                      height: 45,
                      width: 300,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xffF2F4F7),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 2, color: Color(0xffD0D5DD)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {},
                        child: Text('Update',
                            style: GoogleFonts.inter(
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: Color(0xff004576)))),
                      ),
                    )),
              ],
            ),
          ),
        ]));
  }
}
