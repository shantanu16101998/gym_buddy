import 'package:flutter/material.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/models/table_information.dart';

class CardInformationTable extends StatefulWidget {
  final TableInformation tableInformation;
  const CardInformationTable({super.key, required this.tableInformation});

  @override
  State<CardInformationTable> createState() => _CardInformationTableState();
}

class _CardInformationTableState extends State<CardInformationTable> {
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
         const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomText(text: 'Set', fontSize: 16, color: Color(0xff667085)),
            CustomText(text: 'Previous', fontSize: 16, color: Color(0xff667085)),
            CustomText(text: 'Weight', fontSize: 16, color: Color(0xff667085)),
            CustomText(text: 'Reps', fontSize: 16, color: Color(0xff667085))
          ],
          
        ),
        // widget.tableInformation.tableRows.map((e) => Container()).toList()
      ],
    );
  }
}
