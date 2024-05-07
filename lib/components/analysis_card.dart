import 'package:flutter/material.dart';
import 'package:gym_buddy/components/custom_text.dart';
import 'package:gym_buddy/screens/expanded_analysis.dart';
import 'package:gym_buddy/utils/ui_constants.dart';

class AnalysisCard extends StatefulWidget {
  const AnalysisCard(
      {super.key,
      required this.value,
      required this.label,
      required this.icon});

  final String value;
  final String label;
  final IconData icon;

  @override
  State<AnalysisCard> createState() => _AnalysisCardState();
}

class _AnalysisCardState extends State<AnalysisCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.label == "Earnings" || widget.label == "People") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ExpandedAnalysis(label: widget.label)));
        }
      },
      child: Container(
        width: getScreenWidth(context) * 0.4,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(blurRadius: 2, color: Colors.grey)]),
        height: 160,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: CustomText(
                text: widget.value,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xff344054),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 20),
                    child: Icon(
                      widget.icon,
                      color: Color(0xff344054),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: CustomText(
                      text: widget.label,
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Color(0xff667085),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
