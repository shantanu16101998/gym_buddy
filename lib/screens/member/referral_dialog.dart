import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/components/owner/loader.dart';
import 'package:gym_buddy/models/responses.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'package:gym_buddy/utils/ui_constants.dart';

class ReferralDialog extends StatefulWidget {
  const ReferralDialog({super.key});

  @override
  State<ReferralDialog> createState() => _ReferralDialogState();
}

class _ReferralDialogState extends State<ReferralDialog> {
  String inviteCode = "xxxxxx";

  bool apiDataLoaded = false;

  @override
  void initState() {
    super.initState();
    fetchCode();
  }

  fetchCode() async {
    GetInviteCodeResponse getInviteCodeResponse =
        GetInviteCodeResponse.fromJson(
            await backendAPICall('/referral/getReferralCode', {}, 'GET', true));

    setState(() {
      inviteCode = getInviteCodeResponse.referralCode;
      apiDataLoaded = true;
    });
  }

  String addSpacesToInviteCode(String inviteCode) {
    String codeToDisplay = '';
    for (int i = 0; i < inviteCode.length; i++) {
      codeToDisplay += inviteCode[i];
      if (i < inviteCode.length - 1) {
        codeToDisplay += '  ';
      }
    }
    return codeToDisplay;
  }

  @override
  Widget build(BuildContext context) {
    final displayCode = addSpacesToInviteCode(inviteCode);

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: CustomText(
                text: 'Refer and get 1 month of',
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: headingColor),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: CustomText(
                text: 'free gym subscription',
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: headingColor),
          ),
          Container(
            height: 200,
            width: getScreenWidth(context) * 0.8,
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xff9FA5B3)),
                borderRadius: BorderRadius.circular(24)),
            child: apiDataLoaded ? Center(
                child: CustomText(
              text: displayCode,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            )) : const Loader(),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 30),
            child: CustomText(
                text: 'Ask owner to write the code when',
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: CustomText(
                text: 'referee joins the gym',
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
