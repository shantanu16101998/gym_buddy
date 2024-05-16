import 'package:flutter/material.dart';
import 'package:gym_buddy/components/custom_text.dart';
import 'package:gym_buddy/components/qr_code_pic.dart';
import 'package:gym_buddy/components/text_box.dart';
import 'package:gym_buddy/models/responses.dart';
import 'package:gym_buddy/screens/subscription.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';
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

  onSignUpButtonClicked() async {
    var sharedPreferences = await SharedPreferences.getInstance();

    await backendAPICall(
        '/customer/registerCustomer',
        {
          'customerName': capitalizeFirstLetter(
              sharedPreferences.getString("userName") ?? ""),
          'email': sharedPreferences.getString("userEmail"),
          'contact': sharedPreferences.getString("userContact"),
          'gymName': sharedPreferences.getString("gymName"),
          'address': sharedPreferences.getString("userAddress"),
          'age': int.parse(sharedPreferences.getString("age") ?? "0"),
          'gender': sharedPreferences.getString("gender"),
          'currentBeginDate': sharedPreferences.getString("startDate"),
          'bloodGroup': sharedPreferences.getString("bloodGroup"),
          'validTill':
              int.parse(sharedPreferences.getString("validTill") ?? "0"),
          'charges': int.parse(sharedPreferences.getString("charges") ?? "0"),
          'profilePic': sharedPreferences.getString('profilePic') ?? ""
        },
        "POST",
        true);

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Subscription()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getScreenWidth(context) * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromARGB(255, 85, 84, 84).withOpacity(0.95),
      ),
      child: !isAPIDataLoaded
          ? const SizedBox()
          : Column(
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
                        child: QrCodePic(
                            qrColor: Colors.white,
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
                    color: Colors.white,
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
                                color: Colors.white,
                              ),
                            ),
                      const SizedBox(width: 5),
                      InkWell(
                        onTap: isOwnerEditingUPIId
                            ? onTickIconClicked
                            : onEditIconClicked,
                        child: Icon(
                          isOwnerEditingUPIId ? Icons.check : Icons.edit,
                          color: Colors.white,
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
                            width: 178,
                            child: ElevatedButton(
                                onPressed: onSignUpButtonClicked,
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
