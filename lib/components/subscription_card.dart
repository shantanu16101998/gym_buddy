import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_buddy/components/subscription_dialog.dart';
import 'package:gym_buddy/screens/profile.dart';

class SubscriptionCard extends StatefulWidget {
  final String name;
  final String startDate;
  final String endDate;
  final int? expiringDay;
  final int? expiredDay;
  final int userId;
  const SubscriptionCard(
      {super.key,
      required this.name,
      required this.startDate,
      required this.endDate,
      required this.expiringDay,
      required this.expiredDay,
      required this.userId});

  @override
  State<SubscriptionCard> createState() => _SubscriptionCardState();
}

class _SubscriptionCardState extends State<SubscriptionCard> {
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
          padding: const EdgeInsets.all(24),
          // height: 140,
          width: 340,
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: const Color(0xffDBDDE2)),
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.name,
                  style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Color(0xff344054)))),
              Container(
                height: 8,
              ),
              Text("Subscription details",
                  style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                          color: Color(0xff344054)))),
              Container(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: Color(0xff667085),
                        size: 20,
                      ),
                      Container(
                        width: 5,
                      ),
                      Text(widget.startDate,
                          style: GoogleFonts.inter(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  color: Color(0xff344054)))),
                    ],
                  ),
                  Row(children: [
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
                                color: Color(0xff344054)))),
                  ])
                ],
              ),
              Container(
                height: 8,
              ),
              widget.expiringDay != null
                  ? Text("Expiring within ${widget.expiringDay} days",
                      style: GoogleFonts.inter(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: Color(0xff8C6A13))))
                  : const SizedBox(),
              widget.expiredDay != null
                  ? Text("Expired ${widget.expiredDay} days ago",
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
                                return SubscriptionDialog();
                              },
                            );
                          },
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: const BorderSide(
                                  width: 1.0, color: Color(0xffD0D5DD)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: Text("Update Subscription",
                              style: GoogleFonts.inter(
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: Color(0xff004576))))),
                    )
                  : const SizedBox(),
            ],
          ),
        ));
  }
}
