import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/components/owner/text_box.dart';
import 'package:gym_buddy/components/owner/user_payment_form.dart';
import 'package:gym_buddy/screens/owner/profile.dart';
import 'package:gym_buddy/screens/owner/subscription.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'package:gym_buddy/utils/exercise_constant.dart';
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

  String duration = durations[0];

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

  onUpdatePressed() async {
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
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Profile(userId: widget.userId)));
      }
    }
  }

  _onPayNowPressed() async {
    if (validateForm()) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  UserPaymentForm(onButtonPressed: onUpdatePressed,buttonText: 'Renew Subscription')));
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
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
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
                padding: const EdgeInsets.only(
                    left: 30, top: 30, right: 30, bottom: 10),
                child: SizedBox(
                  width: 320,
                  child: LabeledTextField(
                      labelText: "Start Date",
                      controller: _startDateController,
                      readOnly: true,
                      onTap: () => {_selectDate(context, _startDateController)},
                      errorText: startDateError),
                )),
            // CustomText(text: 'Duration',fontSize: 16,fontWeight: FontWeight.bold,color: primaryColor,),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                child: DropdownButton2(
                  iconStyleData: const IconStyleData(
                      icon: RotatedBox(
                          quarterTurns: 3,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.black,
                              size: 15,
                            ),
                          ))),
                  underline: Container(
                    height: 1,
                    color: Colors.transparent,
                  ),
                  buttonStyleData: ButtonStyleData(
                      width: 320,
                      height: 60,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1,
                              color: endMonthError != null
                                  ? Colors.red
                                  : Colors.grey),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)))),
                  dropdownStyleData: const DropdownStyleData(
                      maxHeight: 400,
                      // width: 100,
                      decoration: BoxDecoration(color: Colors.white)),
                  value: duration,
                  onChanged: (value) {
                    setState(() {
                      duration = value!;
                      _endMonthController.text =
                          durations.indexOf(value).toString();
                    });
                  },
                  items:
                      durations.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Container(
                          child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: CustomText(
                          text: value,
                          fontSize: 17,
                        ),
                      )),
                    );
                  }).toList(),
                ),
              ),
            ),
            Align(
                alignment: Alignment.center,
                child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: SizedBox(
                      width: 320,
                      child: LabeledTextField(
                        textInputType: TextInputType.number,
                        labelText: "Charges",
                        controller: _chargesController,
                        textInputFormatter: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        errorText: chargesError,
                        prefixIcon: const Icon(
                          Icons.currency_rupee,
                          color: primaryColor,
                        ),
                      ),
                    ))),
            Align(
                alignment: Alignment.center,
                child: Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 30),
                    child: SizedBox(
                        height: 50,
                        width: 340,
                        child: OutlinedButton(
                            onPressed: _onPayNowPressed,
                            style: OutlinedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: primaryColor,
                            ),
                            child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text("Pay Now",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)))))))
          ]),
        ));
  }
}
