import 'package:flutter/material.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/components/owner/qr_code_pic.dart';
import 'package:gym_buddy/components/owner/text_box.dart';
import 'package:gym_buddy/models/responses.dart';
import 'package:gym_buddy/screens/owner/owner.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'package:gym_buddy/utils/custom.dart';
import 'package:gym_buddy/utils/ui_constants.dart';
import 'package:gym_buddy/utils/validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPaymentForm extends StatefulWidget {
  final Function onPageToShowChange;
  const UserPaymentForm({super.key, required this.onPageToShowChange});

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
        MaterialPageRoute(builder: (context) => const OwnerScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getScreenWidth(context) * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black),
        color: Colors.white,
      ),
      child: !isAPIDataLoaded
          ? const SizedBox()
          : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CustomText(
                    text: "Please verify your UPI Id",
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: QrCodePic(
                            qrColor: Colors.black,
                            upiIntentLink:
                                generateUPIDeeplink(_upiController, charges)),
                      )),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CustomText(
                    text: "UPI ID",
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8, bottom: 20, left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isOwnerEditingUPIId
                          ? SizedBox(
                              width: getScreenWidth(context) * 0.6,
                              child: LabeledTextField(
                                  labelText: "UPI Id",
                                  controller: _upiController,
                                  errorText: upiError))
                          : Flexible(
                              child: CustomText(
                                text: _upiController.text,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      const SizedBox(width: 5),
                      InkWell(
                        onTap: isOwnerEditingUPIId
                            ? onTickIconClicked
                            : onEditIconClicked,
                        child: Icon(
                          isOwnerEditingUPIId ? Icons.check : Icons.edit,
                        ),
                      )
                    ],
                  ),
                ),
                Align(
                    alignment: Alignment.center,
                    child: Padding(
                        padding: const EdgeInsets.only(bottom: 50, top: 30),
                        child: SizedBox(
                            height: 50,
                            width: 278,
                            child: ElevatedButton(
                                onPressed: onSignUpButtonClicked,
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    side: BorderSide(color: headingColor)),
                                child: const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text("Sign up and share Id",
                                        style: TextStyle(
                                            color: headingColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)))))))
              ],
            ),
    );
  }
}
