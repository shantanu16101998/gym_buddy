import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/utils/custom.dart';

class IdentityCard extends StatefulWidget {
  final String gymName;
  final String startDate;
  final String memberName;
  final String validTillInMonths;
  final String gymContact;
  final String profileUrl;

  const IdentityCard(
      {super.key,
      required this.gymContact,
      required this.startDate,
      required this.gymName,
      required this.memberName,
      required this.validTillInMonths,
      required this.profileUrl});

  @override
  State<IdentityCard> createState() => _IdentityCardState();
}

// iVBORw0KGgoAAAANSUhEUgAAAAgAAAAIAQMAAAD+wSzIAAAABlBMVEX///+/v7+jQ3Y5AAAADklEQVQI12P4AIX8EAgALgAD/aNpbtEAAAAASUVORK5CYII

// /9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAIBAQEBAQIBAQECAgICAgQDAgICAgUEBAMEBgUGBgYFBgYGBwkIBgcJBwYGCAsICQoKCgoKBggLDAsKDAkKCgr/2wBDAQICAgICAgUDAwUKBwYHCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgr/wAARCAUAA8ADASIAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwDuU8D2Uc

class _IdentityCardState extends State<IdentityCard> {
  Uint8List bytes = base64.decode(const Base64Codec().normalize(
      'iVBORw0KGgoAAAANSUhEUgAAAAgAAAAIAQMAAAD+wSzIAAAABlBMVEX///+/v7+jQ3Y5AAAADklEQVQI12P4AIX8EAgALgAD/aNpbtEAAAAASUVORK5CYII'));

  String dueDate = '';

  @override
  void initState() {

    dueDate = addValidTillToCurrDate(
        widget.startDate, int.parse(widget.validTillInMonths));

    super.initState();
  }

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
                      padding: const EdgeInsets.only(left: 20, right: 20),
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
                      padding: const EdgeInsets.only(left: 19),
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                          image: DecorationImage(
                            image:

                                // widget.profilePicB64 != null
                                // ?

                                AssetImage('assets/images/profile_default.png')
                                    as ImageProvider<
                                        Object>, // Use AssetImage for local assets
                            fit: BoxFit
                                .cover, // You can adjust the fit as per your requirement
                          ),
                        ),
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
                                  text: dueDate,
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
