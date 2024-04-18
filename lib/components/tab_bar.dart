import 'package:flutter/material.dart';

class CustomTabBar extends StatefulWidget {
  final Function setShouldShowCurrent;
  final bool showCurrentUsers;
  const CustomTabBar({super.key, required this.setShouldShowCurrent,required this.showCurrentUsers});

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
          Container(
            width: 170,
            height: 40,
            child: OutlinedButton(
              onPressed: () => {widget.setShouldShowCurrent(true)},
              child: Text("Current"),
              style: OutlinedButton.styleFrom(
                  backgroundColor: widget.showCurrentUsers ? Color(0xffD0D5DD) : Colors.white ,
                  side: BorderSide(width: 1.0, color: Color(0xffD0D5DD)),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.horizontal(left: Radius.circular(10)),
                  )),
            ),
          ),
          Container(
            width: 170,
            height: 40,
            child: OutlinedButton(
              onPressed: () => {widget.setShouldShowCurrent(false)},
              child: Text("Expired"),
              style: OutlinedButton.styleFrom(
                  backgroundColor: widget.showCurrentUsers ? Colors.white : Color(0xffD0D5DD),
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
