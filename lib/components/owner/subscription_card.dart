import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/components/owner/subscription_dialog.dart';
import 'package:gym_buddy/screens/owner/profile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gym_buddy/utils/custom.dart';

class SubscriptionCard extends StatefulWidget {
  final String name;
  final String startDate;
  final String endDate;
  final int? expiringDay;
  final int? expiredDay;
  final String userId;
  final String? profilePic;
  final String phone;
  final String? experience;
  const SubscriptionCard(
      {super.key,
      required this.name,
      required this.startDate,
      required this.endDate,
      required this.expiringDay,
      required this.expiredDay,
      required this.userId,
      required this.phone,
      required this.profilePic,
      this.experience});

  @override
  State<SubscriptionCard> createState() => _SubscriptionCardState();
}

class _SubscriptionCardState extends State<SubscriptionCard> {
  _openWhatsappLink() async {
    await launchUrl(Uri(
        host: 'wa.me',
        path: '+91${widget.phone}',
        scheme: 'https',
        queryParameters: {'text': textToSend(widget.name)}));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        color: Colors.white,
        child: InkWell(
            splashColor: const Color.fromARGB(255, 235, 238, 241),
            onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Profile(userId: widget.userId)))
                },
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30, right: 20),
                      child: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: widget.profilePic == null
                              ? const AssetImage(
                                      "assets/images/profile_default.png")
                                  as ImageProvider<Object>
                              : NetworkImage(widget.profilePic ??
                                  "https://appcraft.s3.ap-south-1.amazonaws.com/profile_default"),
                          radius: 30),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(widget.name,
                                      style: GoogleFonts.inter(
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: primaryColor))),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                Text('Due',
                                    style: GoogleFonts.inter(
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14,
                                            color: Colors.black))),
                                Container(
                                  width: 15,
                                ),
                                const Icon(
                                  Icons.calendar_today,
                                  color: Color(0xff667085),
                                  size: 20,
                                ),
                                Container(
                                  width: 5,
                                ),
                                Text(widget.endDate,
                                    style: GoogleFonts.inter(
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14,
                                            color: Colors.black))),
                              ])
                            ],
                          ),
                          Container(
                            height: 8,
                          ),
                          widget.expiringDay != null
                              ? Text(
                                  "Expiring within ${widget.expiringDay} ${widget.expiringDay == 1 ? "day" : "days"} ",
                                  style: GoogleFonts.inter(
                                      textStyle: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          color: Color(0xff8C6A13))))
                              : const SizedBox(),
                          widget.expiredDay != null
                              ? Text(
                                  "Expired ${widget.expiredDay} ${widget.expiredDay == 1 ? "day" : "days"} ago",
                                  style: GoogleFonts.inter(
                                      textStyle: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          color: Color(0xffB01D1D))))
                              : const SizedBox(),
                        ],
                      ),
                    ),
                    if (widget.experience == 'Beginner')
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 0),
                          child: Container(
                              height: 25,
                              width: 50,
                              color: Color(0xffDCF2D8),
                              child: Center(
                                  child: CustomText(
                                text: 'New',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ))),
                        ),
                      )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
