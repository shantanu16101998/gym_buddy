import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';

class IdentityCard extends StatefulWidget {
  final String gymName;
  final String memberName;
  final String dueDate;
  final String validTillInMonths;
  final String gymContact;

  const IdentityCard(
      {super.key,
      required this.dueDate,
      required this.gymContact,
      required this.gymName,
      required this.memberName,
      required this.validTillInMonths});

  @override
  State<IdentityCard> createState() => _IdentityCardState();
}

class _IdentityCardState extends State<IdentityCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 388,
      height: 250,
      decoration: const BoxDecoration(color: Color(0xff080831)),
      child: Center(
        child: Container(
          width: 340,
          height: 200,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Column(
            children: [
              Container(
                height: 70,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1, color: Colors.black),
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/logo-modified.png'))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomText(
                            text: '${widget.gymName} Member',
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          CustomText(
                            text: '+ 91 ${widget.gymContact}',
                            fontSize: 16,
                            color: const Color(0xff667085),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 9.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 19),
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: const BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.all(Radius.circular(40)),

                            image: DecorationImage(
                                image:
                                    AssetImage('assets/images/shantanu.jpeg'))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: widget.memberName,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: const Color(0xff344054),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const CustomText(
                                  text: 'Due:',
                                  fontSize: 14,
                                  color: Color(0xff667085)),
                              const SizedBox(width: 40),
                              CustomText(
                                  text: widget.dueDate,
                                  fontSize: 14,
                                  color: const Color(0xff667085))
                            ],
                          ),
                          Row(
                            children: [
                              const CustomText(
                                  text: 'Duration:',
                                  fontSize: 14,
                                  color: Color(0xff667085)),
                              const SizedBox(width: 12),
                              CustomText(
                                  text: '${widget.validTillInMonths} months',
                                  fontSize: 14,
                                  color: const Color(0xff667085))
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
