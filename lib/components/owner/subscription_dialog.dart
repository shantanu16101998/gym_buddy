import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_buddy/components/owner/text_box.dart';
import 'package:gym_buddy/screens/owner/subscription.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:gym_buddy/utils/validator.dart';
import 'package:flutter/services.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/components/owner/qr_code_pic.dart';
import 'package:gym_buddy/utils/ui_constants.dart';
import 'package:gym_buddy/utils/custom.dart';
import 'package:gym_buddy/models/responses.dart';
import 'package:gym_buddy/providers/subscription_provider.dart';
import 'package:provider/provider.dart';

class SubscriptionDialog extends StatefulWidget {
  final String userId;
  const SubscriptionDialog({super.key, required this.userId});

  @override
  State<SubscriptionDialog> createState() => _SubscriptionDialogState();
}

class _SubscriptionDialogState extends State<SubscriptionDialog> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endMonthController = TextEditingController();
  final TextEditingController _chargesController = TextEditingController();
  final TextEditingController _upiController = TextEditingController();
  OwnerDeeplinkResponse ownerDeeplinkResponse =
      const OwnerDeeplinkResponse(upiId: "");

  bool isApiDataLoaded = false;

  String? startDateError;
  String? endMonthError;
  String? chargesError;
  String? upiError;

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

  onEditIconClicked() {
    setState(() {
      isOwnerEditingUPIId = true;
    });
  }

  bool showQR = false;
  bool isOwnerEditingUPIId = false;

  bool validateForm() {
    setState(() {
      startDateError =
          validateSimpleText(_startDateController.text, "Start Date");
      endMonthError = validateSimpleText(_endMonthController.text, "End Month");
      chargesError = chargeValidator(_chargesController.text);
    });
    if (startDateError != null ||
        endMonthError != null ||
        chargesError != null) {
      return false;
    }
    return true;
  }

  _onUpdatePressed() async {
    await backendAPICall(
        '/customer/updateSubscription/${widget.userId}',
        {
          'currentBeginDate': _startDateController.text,
          'validTill': _endMonthController.text,
          'charges': _chargesController.text
        },
        'PUT',
        true);
    if (mounted) {
      await Provider.of<SubscriptionProvider>(context, listen: false)
          .fetchSubscription();
      if (mounted) {
        Navigator.pop(context);
        Navigator.push(context,MaterialPageRoute(builder: (context) => Subscription()));
      }
    }
  }

  _onPayNowPressed() async {
    if (validateForm()) {
      showQR = true;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUPIIntentLink();
  }

  fetchUPIIntentLink() async {
    var response = await backendAPICall("/owner/getUPIId", null, 'GET', true);
    setState(() {
      ownerDeeplinkResponse = OwnerDeeplinkResponse.fromJson(response);
      _upiController.text = ownerDeeplinkResponse.upiId;
      isApiDataLoaded = true;
    });
  }

  _selectDate(
      BuildContext context, TextEditingController dateController) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        dateController.text = DateFormat("d MMM yyyy").format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: !showQR
          ? Container(
              width: double.infinity,
              color: Colors.white,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text("Update Subscription",
                      style: GoogleFonts.inter(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Color(0xff344054)))),
                ),
                Padding(
                    padding:
                        const EdgeInsets.only(left: 30, top: 15, right: 30),
                    child: SizedBox(
                      width: 340,
                      child: LabeledTextField.homepageText(
                          labelText: "Start Date",
                          controller: _startDateController,
                          readOnly: true,
                          onTap: () =>
                              {_selectDate(context, _startDateController)},
                          errorText: startDateError),
                    )),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                      padding:
                          const EdgeInsets.only(left: 30, top: 10, right: 30),
                      child: Text('Valid Till',
                          style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                            color: Color(0xff344054),
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                          )))),
                ),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 30, top: 15, bottom: 15, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                            onPressed: () => {
                                  setState(() {
                                    _endMonthController.text = "3";
                                  })
                                },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: _endMonthController.text == "3"
                                  ? const Color.fromARGB(255, 203, 203, 203)
                                  : Colors.white,
                              side: const BorderSide(
                                  width: 1.0, color: Color(0xffD0D5DD)),
                            ),
                            child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text("3",
                                    style: TextStyle(
                                        color: Color(0xff667085),
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal)))),
                        OutlinedButton(
                            onPressed: () => {
                                  setState(() {
                                    _endMonthController.text = "6";
                                  })
                                },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _endMonthController.text == "6"
                                  ? const Color.fromARGB(255, 203, 203, 203)
                                  : Colors.white,
                              elevation: 0,
                              side: const BorderSide(
                                width: 1.0,
                                color: Color(0xffD0D5DD),
                              ),
                            ),
                            child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text("6",
                                    style: TextStyle(
                                        color: Color(0xff667085),
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal)))),
                        OutlinedButton(
                            onPressed: () => {
                                  setState(() {
                                    _endMonthController.text = "12";
                                  })
                                },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: _endMonthController.text == "12"
                                  ? const Color.fromARGB(255, 203, 203, 203)
                                  : Colors.white,
                              side: const BorderSide(
                                width: 1.0,
                                color: Color(0xffD0D5DD),
                              ),
                            ),
                            child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text("12",
                                    style: TextStyle(
                                        color: Color(0xff667085),
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal)))),
                      ],
                    )),
                Align(
                    alignment: Alignment.center,
                    child: Padding(
                        padding: const EdgeInsets.all(1),
                        child: SizedBox(
                            width: 340,
                            child: LabeledTextField.homepageText(
                                labelText: "Add Month",
                                controller: _endMonthController,
                                onTap: () => {
                                      setState(() {
                                        _endMonthController.text = "";
                                      })
                                    },
                                errorText: endMonthError)))),
                Align(
                    alignment: Alignment.center,
                    child: Padding(
                        padding: const EdgeInsets.all(1),
                        child: SizedBox(
                          width: 340,
                          child: LabeledTextField.homepageText(
                            textInputType: TextInputType.number,
                            labelText: "Charges",
                            controller: _chargesController,
                            textInputFormatter: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            errorText: chargesError,
                            prefixIcon: const Icon(
                              Icons.currency_rupee,
                              color: Color(0xff667085),
                            ),
                          ),
                        ))),
                Align(
                    alignment: Alignment.center,
                    child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 20),
                        child: SizedBox(
                            height: 50,
                            width: 340,
                            child: OutlinedButton(
                                onPressed: _onPayNowPressed,
                                style: OutlinedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.white,
                                  side: BorderSide(color: headingColor),
                                ),
                                child: const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text("Pay Now",
                                        style: TextStyle(
                                            color: headingColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)))))))
              ]),
            )
          : isApiDataLoaded
              ? Container(
                  color: Colors.white,
                  width: double.infinity,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CustomText(
                          text: "Please verify your UPI Id",
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: QrCodePic(
                                  qrColor: Colors.black,
                                  upiIntentLink: generateUPIDeeplink(
                                      _upiController, _chargesController.text)),
                            )),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CustomText(
                          text: "UPI ID",
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            isOwnerEditingUPIId
                                ? SizedBox(
                                    width: getScreenWidth(context) * 0.6,
                                    child: LabeledTextField.homepageText(
                                        labelText: "UPI Id",
                                        controller: _upiController,
                                        errorText: upiError))
                                : CustomText(
                                    text: _upiController.text,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                            const SizedBox(width: 5),
                            InkWell(
                              onTap: isOwnerEditingUPIId
                                  ? onTickIconClicked
                                  : onEditIconClicked,
                              child: Icon(
                                isOwnerEditingUPIId ? Icons.check : Icons.edit,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 50, top: 30),
                              child: SizedBox(
                                  height: 50,
                                  width: 178,
                                  child: OutlinedButton(
                                      onPressed: _onUpdatePressed,
                                      style: OutlinedButton.styleFrom(
                                          elevation: 0,
                                          side: BorderSide(color: headingColor),
                                          backgroundColor: Colors.white),
                                      child: const Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Text("Update",
                                              style: TextStyle(
                                                  color: headingColor,
                                                  fontSize: 18,
                                                  fontWeight:
                                                      FontWeight.bold)))))))
                    ],
                  ),
                )
              : const SizedBox(),
    );
  }
}
