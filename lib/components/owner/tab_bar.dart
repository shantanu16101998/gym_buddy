import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';

class CustomTabBar extends StatefulWidget {
  final Function setShouldShowCurrent;
  final bool showCurrentUsers;
  final int numberOfCurrentUsers;
  final int numberOfExpiredUsers;
  const CustomTabBar(
      {super.key,
      required this.setShouldShowCurrent,
      required this.showCurrentUsers,
      required this.numberOfCurrentUsers,
      required this.numberOfExpiredUsers});

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => {widget.setShouldShowCurrent(true)},
            child: Padding(
              padding: const EdgeInsets.only(left: 66),
              child: Container(
                color: Colors.transparent,
                width: 100,
                height: 50,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: CustomText(
                      text: "Current (${widget.numberOfCurrentUsers})",
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: widget.showCurrentUsers
                          ? Color(0xff344054)
                          : Color(0xff344054).withOpacity(0.64)),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => {widget.setShouldShowCurrent(false)},
            child: Padding(
              padding: const EdgeInsets.only(right: 66),
              child: Container(
                color: Colors.transparent,
                width: 100,
                height: 50,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: CustomText(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: !widget.showCurrentUsers
                          ? Color(0xff344054)
                          : Color(0xff344054).withOpacity(0.64),
                      text: "Expired (${widget.numberOfExpiredUsers})"),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
