import 'package:flutter/material.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/components/owner/qr_code_pic.dart';
import 'package:gym_buddy/components/owner/text_box.dart';
import 'package:gym_buddy/models/responses.dart';
import 'package:gym_buddy/screens/owner/owner.dart';
import 'package:gym_buddy/screens/owner/subscription.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'package:gym_buddy/utils/custom.dart';
import 'package:gym_buddy/utils/enums.dart';
import 'package:gym_buddy/utils/ui_constants.dart';
import 'package:gym_buddy/utils/validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class UserPaymentForm extends StatefulWidget {
  final Function onPageToShowChange;
  final PaymentFormPastWidget paymentFormPastWidget;
  final String profilePageUserId;

  const UserPaymentForm(
      {super.key,
      required this.onPageToShowChange,
      required this.paymentFormPastWidget,
      required this.profilePageUserId});

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

  void onSignUpButtonClicked() async {
    var sharedPreferences = await SharedPreferences.getInstance();

    var memberName = sharedPreferences.getString("memberName") ?? "";
    var userEmail = sharedPreferences.getString("userEmail") ?? "";
    var userContact = sharedPreferences.getString("userContact") ?? "";
    var userAddress = sharedPreferences.getString("userAddress") ?? "";
    var startDate = sharedPreferences.getString("startDate") ?? "";
    var validTillString = sharedPreferences.getString("validTill");
    var chargesString = sharedPreferences.getString("charges");
    var profilePic = sharedPreferences.getString('profilePic');
    var mentorId = sharedPreferences.getString('mentorId');
    var goal = sharedPreferences.getString('goal');
    var experience = sharedPreferences.getString('experience');
    sharedPreferences.remove('profilePic');

    int? validTill = tryParseInt(validTillString);
    int? charges = tryParseInt(chargesString);

    RegisterCustomerResponse _ =
        RegisterCustomerResponse.fromJson(await backendAPICall(
            '/customer/registerCustomer',
            {
              'name': capitalizeFirstLetter(memberName).trim(),
              'email': userEmail.trim(),
              'contact': userContact.trim(),
              'address': userAddress.trim(),
              'currentBeginDate': startDate.trim(),
              'validTill': validTill ?? 0,
              'charges': charges ?? 0,
              'profilePic': profilePic,
              if (mentorId != null) 'mentorId': mentorId,
              'goal': goal,
              'experience': experience
            },
            "POST",
            true));

    if (sharedPreferences.getString('referralCode') != '') {
      backendAPICall(
          '/verifyReferralCode/${sharedPreferences.getString('referralCode')}',
          {},
          'POST',
          true);
    }

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Subscription()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(children: [
          Container(
            height: getEffectiveScreenHeight(context) / 2,
            color: Color(0xff00BDF1),
          ),
          Container(
            height: getEffectiveScreenHeight(context) / 2,
            color: Color(0xff172B76),
          )
        ]),
        Container(
          height: getEffectiveScreenHeight(context),
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  height: 520,
                  width: 320,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
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
                              padding:
                                  const EdgeInsets.only(top: 40, bottom: 19),
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
                                decoration: BoxDecoration(
                                    color: Color(0xffD4F0FD),
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(0),
                                        bottom: Radius.circular(12))),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: CustomText(
                                              text: "UPI ID",
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
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
                                                      errorText: upiError))
                                              : SizedBox(
                                                  child: FittedBox(
                                                    fit: BoxFit.fitWidth,
                                                    child: Text(
                                                      _upiController.text,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                baseColor:
                                    const Color.fromARGB(255, 255, 255, 255),
                                highlightColor:
                                    const Color.fromARGB(255, 227, 227, 226),
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
                              onPressed: onSignUpButtonClicked,
                              style: OutlinedButton.styleFrom(
                                  elevation: 0, backgroundColor: Colors.white),
                              child: const Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Text("Sign up and share Gym Card",
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)))))))
            ],
          ),
        ),
      ],
    );
  }
}
