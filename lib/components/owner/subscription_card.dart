import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return InkWell(
        onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Profile(userId: widget.userId)))
            },
        child: Container(
          width: 360,
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: widget.experience == 'Beginner' ? subscriptionCardNewbie : const Color(0xffDBDDE2)),
              color: widget.experience == 'Beginner' ? subscriptionCardNewbie.withOpacity(0.15) : Colors.white,
              borderRadius: BorderRadius.circular(12)),
          child: IntrinsicHeight(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                          backgroundImage: widget.profilePic == null
                              ? const AssetImage(
                                      "assets/images/profile_default.png")
                                  as ImageProvider<Object>
                              : NetworkImage(widget.profilePic ??
                                  "https://appcraft.s3.ap-south-1.amazonaws.com/profile_default"),
                          radius: 50),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 20,
                          ),
                          SizedBox(
                            width: 200,
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(widget.name,
                                      style: GoogleFonts.inter(
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22,
                                              color: headingColor))),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 8,
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
                          const SizedBox(
                            height: 10,
                          ),
                          widget.expiredDay != null
                              ? Align(
                                  alignment: Alignment.center,
                                  child: OutlinedButton(
                                      onPressed: () {
                                        showModalBottomSheet<void>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return SubscriptionDialog(
                                              userId: widget.userId,
                                            );
                                          },
                                        );
                                      },
                                      style: OutlinedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          side: const BorderSide(
                                              width: 1.0,
                                              color: Color(0xffD0D5DD)),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                      child: Text("Update Subscription",
                                          style: GoogleFonts.inter(
                                              textStyle: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14,
                                                  color: headingColor)))),
                                )
                              : const SizedBox(),
                          const Divider(
                            height: 20,
                            thickness: 5,
                            indent: 20,
                            endIndent: 0,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                widget.expiredDay != null || widget.expiringDay != null
                    ? const Divider(
                        height: 1,
                        thickness: 1,
                        indent: 10,
                        endIndent: 10,
                        color: Color(0xffDBDDE2),
                      )
                    : const SizedBox(),
                widget.expiredDay != null || widget.expiringDay != null
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  launchUrl(Uri.parse("tel:${widget.phone}")),
                              child: const Icon(Icons.phone_outlined,
                                  color: Color(0xff667085), size: 30),
                            ),
                            GestureDetector(
                              onTap: _openWhatsappLink,
                              child: const Icon(FontAwesomeIcons.whatsapp,
                                  color: Color(0xff667085), size: 30),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox()
              ],
            ),
          ),
        ));
  }
}
