import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_buddy/constants/environment.dart';
import 'package:gym_buddy/screens/member/profile.dart';
import 'package:gym_buddy/utils/enums.dart';

class Header extends StatefulWidget {
  final String userName;

  const Header({super.key, required this.userName});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (appEnvironment == AppEnvironment.member) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Profile()));
                  }
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/logo-modified.png"),
                      fit: BoxFit.fill,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 17, bottom: 3,right: 10),
                      child: Container(
                        width: 250,
                        child: Text('Hi ${widget.userName}',
                            overflow: TextOverflow.clip,
                            style: GoogleFonts.inter(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Color(0xff344054),
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
            child: const Icon(Icons.menu),
          ),
        ],
      ),
    );
  }
}
