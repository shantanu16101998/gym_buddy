import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Header extends StatefulWidget {
  final String ownerName;

  const Header({super.key,required this.ownerName});

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
              Container(
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
              Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 17, bottom: 3),
                      child: Text(widget.ownerName,
                          style: GoogleFonts.inter(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Color(0xff344054),
                              decoration: TextDecoration.none,
                            ),
                          ))),
                  
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