import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_buddy/utils/ui_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  String ownerName = "User";
  @override
  void initState() {
    super.initState();
  }

  fetchOwnerName() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      ownerName = sharedPreferences.getString("ownerName") ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: getScreenHeight(context) * 0.12,
      padding: EdgeInsets.all(20),
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
                      child: Text(ownerName,
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
