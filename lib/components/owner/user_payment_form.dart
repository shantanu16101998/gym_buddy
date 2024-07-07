import 'package:flutter/material.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/components/owner/header.dart';
import 'package:gym_buddy/components/owner/qr_code_pic.dart';
import 'package:gym_buddy/components/owner/side_bar.dart';
import 'package:gym_buddy/components/owner/text_box.dart';
import 'package:gym_buddy/models/responses.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'package:gym_buddy/utils/custom.dart';
import 'package:gym_buddy/utils/ui_constants.dart';
import 'package:gym_buddy/utils/validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class UserPaymentForm extends StatefulWidget {
  final Function onButtonPressed;
  final String? buttonText;

  const UserPaymentForm(
      {super.key, required this.onButtonPressed, this.buttonText});

  @override
  State<UserPaymentForm> createState() => _UserPaymentFormState();
}

class _UserPaymentFormState extends State<UserPaymentForm> {
  bool isAPIDataLoaded = false;
  bool isOwnerEditingUPIId = false;
  String charges = "0";
  String? upiError;
  OwnerDeeplinkResponse ownerDeeplinkResponse =
      const OwnerDeeplinkResponse(upiId: "");

  final TextEditingController _upiController = TextEditingController();

  fetchUPIIntentLink() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    charges = sharedPreferences.getString("charges") ?? "";
    var response = await backendAPICall("/owner/getUPIId", null, 'GET', true);
    setState(() {
      ownerDeeplinkResponse = OwnerDeeplinkResponse.fromJson(response);
      _upiController.text = ownerDeeplinkResponse.upiId;
      isAPIDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUPIIntentLink();
  }

  onEditIconClicked() {
    setState(() {
      isOwnerEditingUPIId = true;
    });
  }

  onTickIconClicked() {
    upiError = validateSimpleText(_upiController.text, "UPI Id");

    if (upiError == null) {
      setState(() {
        isOwnerEditingUPIId = false;
        _upiController.text = _upiController.text;
      });
      backendAPICall(
          '/owner/upiId', {'upiId': _upiController.text}, "PUT", true);
    } else {
      setState(() {
        upiError = validateUPIId(_upiController.text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(userName: ''),
      body: Column(
        children: [
          Header(),
          Stack(
            children: <Widget>[
              Column(children: [
                Container(
                  height: getEffectiveScreenHeight(context) / 2,
                  color: const Color(0xff00BDF1),
                ),
                Container(
                  height: getEffectiveScreenHeight(context) / 2,
                  color: const Color(0xff172B76),
                )
              ]),
              Container(
                height: getEffectiveScreenHeight(context),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        height: 530,
                        width: 320,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: isAPIDataLoaded
                            ? Column(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(top: 40),
                                    child: CustomText(
                                      text: "SCAN QR CODE TO PAY",
                                      fontSize: 22,
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 40, bottom: 19),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: QrCodePic(
                                          qrColor: Colors.black,
                                          upiIntentLink: generateUPIDeeplink(
                                              _upiController, charges)),
                                    ),
                                  ),
                                  Container(
                                      height: 140,
                                      decoration: const BoxDecoration(
                                          color: Color(0xffD4F0FD),
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(0),
                                              bottom: Radius.circular(12))),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 20),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 8.0),
                                                  child: CustomText(
                                                    text: "UPI ID",
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: InkWell(
                                                    onTap: isOwnerEditingUPIId
                                                        ? onTickIconClicked
                                                        : onEditIconClicked,
                                                    child: Icon(
                                                      isOwnerEditingUPIId
                                                          ? Icons.check
                                                          : Icons.edit,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15, left: 5, right: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                isOwnerEditingUPIId
                                                    ? SizedBox(
                                                        child: LabeledTextField(
                                                            labelText: "UPI Id",
                                                            controller:
                                                                _upiController,
                                                            errorText:
                                                                upiError))
                                                    : SizedBox(
                                                      width: 300,
                                                        child: FittedBox(
                                                          fit: BoxFit.scaleDown,
                                                          child: Text(
                                                            _upiController.text,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              )
                            : SizedBox(
                                child: Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Shimmer.fromColors(
                                      baseColor: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      highlightColor: const Color.fromARGB(
                                          255, 227, 227, 226),
                                      child: Container(
                                        height: 200,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: const Color(0xffDBDDE2)),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(12)),
                                        ),
                                      ),
                                    )),
                              ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                            padding: const EdgeInsets.only(bottom: 50, top: 30),
                            child: SizedBox(
                                height: 50,
                                width: 300,
                                child: OutlinedButton(
                                    onPressed: () {
                                      widget.onButtonPressed();
                                    },
                                    style: OutlinedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor: Colors.white),
                                    child: Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: Text(
                                            widget.buttonText != null
                                                ? widget.buttonText!
                                                : "Pay Now",
                                            style: const TextStyle(
                                                color: primaryColor,
                                                fontSize: 18,
                                                fontWeight:
                                                    FontWeight.bold)))))))
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
