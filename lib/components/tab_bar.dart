import 'package:flutter/material.dart';

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({super.key});

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 170,
            height: 40,
            child: OutlinedButton(
              onPressed: () => {},
              child: Text("Current"),
              style: OutlinedButton.styleFrom(
                  side: BorderSide(width: 1.0, color: Color(0xffD0D5DD)),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.horizontal(left: Radius.circular(10)),
                  )),
            ),
          ),
          SizedBox(
            width: 170,
            height: 40,
            child: OutlinedButton(
              
              onPressed: () => {},
              child: Text("Expired"),
              
              style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(width: 1.0, color: Color(0xffD0D5DD)),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.horizontal(right: Radius.circular(10)),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
