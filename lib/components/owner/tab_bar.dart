import 'package:flutter/material.dart';

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 180,
          height: 40,
          child: OutlinedButton(
            onPressed: () => {widget.setShouldShowCurrent(true)},
            style: OutlinedButton.styleFrom(
                backgroundColor: widget.showCurrentUsers
                    ? const Color(0xffD0D5DD)
                    : Colors.white,
                side: const BorderSide(width: 1.0, color: Color(0xffD0D5DD)),
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.horizontal(left: Radius.circular(10)),
                )),
            child: Text("Current (${widget.numberOfCurrentUsers})"),
          ),
        ),
        SizedBox(
          width: 180,
          height: 40,
          child: OutlinedButton(
            onPressed: () => {widget.setShouldShowCurrent(false)},
            style: OutlinedButton.styleFrom(
                backgroundColor:
                    widget.showCurrentUsers ? Colors.white : const Color(0xffD0D5DD),
                side: const BorderSide(width: 1.0, color: Color(0xffD0D5DD)),
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.horizontal(right: Radius.circular(10)),
                )),
            child: Text("Expired (${widget.numberOfExpiredUsers})"),
          ),
        )
      ],
    );
  }
}
