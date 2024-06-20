import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'package:gym_buddy/utils/ui_constants.dart';

class Header extends StatefulWidget {

  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(top: getStatusBarHeight(context) + 20, bottom: 20),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Column(
                children: [
                  Padding(
                      padding:
                          const EdgeInsets.only(left: 17, bottom: 3, right: 10),
                      child: SizedBox(
                        child: Text('Gym Buddy',
                            overflow: TextOverflow.clip,
                            style: GoogleFonts.inter(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: headingColor,
                                decoration: TextDecoration.none,
                              ),
                            )),
                      )),
                ],
              ),
            ],
          ),
          InkWell(
            onTap: () => {Scaffold.of(context).openDrawer()},
            child: const SizedBox(
                height: 40,
                width: 40,
                child: Icon(
                  Icons.more_vert,
                  color: headingColor,
                )),
          ),
        ],
      ),
    );
  }
}
