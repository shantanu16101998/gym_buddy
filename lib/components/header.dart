import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/profile_pic.png"),
                fit: BoxFit.fill,
              ),
              shape: BoxShape.circle,
            ),
          ),
          Column(
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 17, bottom: 3),
                  child: Text("Murali M",
                      style: GoogleFonts.inter(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Color(0xff344054),
                          decoration: TextDecoration.none,
                        ),
                      ))),
              Text("Admin",
                  style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    color: Color(0xff344054),
                    decoration: TextDecoration.none,
                  )))
            ],
          )
        ],
      ),
    );
  }
}