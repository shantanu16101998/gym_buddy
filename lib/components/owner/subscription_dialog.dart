import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_buddy/components/owner/text_box.dart';
import 'package:gym_buddy/screens/owner/subscription.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:gym_buddy/utils/validator.dart';
import 'package:flutter/services.dart';
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
          if (tryParseInt(_endMonthController.text) != null)
            'validTill': tryParseInt(_endMonthController.text),
          'charges': _chargesController.text
        },
        'PUT',
        true);
    if (mounted) {
      await Provider.of<SubscriptionProvider>(context, listen: false)
          .fetchSubscription();
      if (mounted) {
        Navigator.pop(context);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Subscription()));
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
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: formPrimaryColor,
              onPrimary: Colors.white,
              onSurface: formPrimaryColor,
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.white),
              titleMedium: TextStyle(color: Colors.white),
            ),
          ),
          child: child!,
        );
      },
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
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 33),
              child: Text("Renew Subscription",
                  style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: primaryColor))),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 30, top: 15, right: 30),
                child: SizedBox(
                  width: 340,
                  child: LabeledTextField.homepageText(
                      labelText: "Start Date",
                      controller: _startDateController,
                      readOnly: true,
                      onTap: () => {_selectDate(context, _startDateController)},
                      errorText: startDateError),
                )),
            Align(
              alignment: Alignment.center,
              child: Padding(
                  padding: const EdgeInsets.only(left: 30, top: 10, right: 30),
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
                              side: BorderSide(color: primaryColor),
                            ),
                            child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text("Pay Now",
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)))))))
          ]),
        ));
  }
}
