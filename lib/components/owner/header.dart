import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_buddy/constants/environment.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'package:gym_buddy/utils/enums.dart';
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
      height: 80 + getStatusBarHeight(context),
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
                    padding: const EdgeInsets.only(left: 20),
                    child: Center(
                    
                        child: SizedBox(
                          child: Text(appEnvironment == AppEnvironment.owner ? 'Gymania AI' : 'Gymania',
                              overflow: TextOverflow.clip,
                              style: GoogleFonts.inter(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: primaryColor,
                                  decoration: TextDecoration.none,
                                ),
                              )),
                        )),
                  ),
                ],
              ),
            ],
          ),
          InkWell(
            onTap: () => {Scaffold.of(context).openDrawer()},
            child: const Padding(
                padding: EdgeInsets.only(right: 20),

                child: Icon(
                  Icons.menu,
                  size: 30,
                  color: headerColor,
                )),
          ),
        ],
      ),
    );
  }
}
