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
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: CustomText(text: 'Set', fontSize: 16, color: Color(0xff667085),fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: CustomText(text: '1', fontSize: 16, color: Color(0xff667085)),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: CustomText(text: '2', fontSize: 16, color: Color(0xff667085)),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: CustomText(text: '3', fontSize: 16, color: Color(0xff667085)),
        )
      ]),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: CustomText(text: 'Weight', fontSize: 16, color: Color(0xff667085),fontWeight: FontWeight.bold),
        ),
        CustomText(text: '1kg', fontSize: 16, color: Color(0xff667085)),
        CustomText(text: '200kg', fontSize: 16, color: Color(0xff667085)),
        CustomText(text: '30000kg', fontSize: 16, color: Color(0xff667085))
      ]),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        CustomText(text: 'Reps', fontSize: 16, color: Color(0xff667085),fontWeight: FontWeight.bold),
        CustomText(text: '10', fontSize: 16, color: Color(0xff667085)),
        CustomText(text: '200', fontSize: 16, color: Color(0xff667085)),
        CustomText(text: '3000', fontSize: 16, color: Color(0xff667085))
      ]),
      
    ]);
  }
}

// class _CardInformationTableState extends State<CardInformationTable> {
//   @override
//   Widget build(BuildContext context) {
//     return const Column(
//       children: [
//          Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             CustomText(text: 'Set', fontSize: 16, color: Color(0xff667085)),
//             CustomText(text: 'Weight', fontSize: 16, color: Color(0xff667085)),
//             CustomText(text: 'Reps', fontSize: 16, color: Color(0xff667085))
//           ],
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             CustomText(text: '1', fontSize: 16, color: Color(0xff667085)),
//             CustomText(text: '5kg', fontSize: 16, color: Color(0xff667085)),
//             CustomText(text: '10', fontSize: 16, color: Color(0xff667085))
//           ],
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             CustomText(text: '2', fontSize: 16, color: Color(0xff667085)),
//             CustomText(text: '10kg', fontSize: 16, color: Color(0xff667085)),
//             CustomText(text: '20', fontSize: 16, color: Color(0xff667085))
//           ],
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             CustomText(text: '3', fontSize: 16, color: Color(0xff667085)),
//             CustomText(text: '100kg', fontSize: 16, color: Color(0xff667085)),
//             CustomText(text: '80', fontSize: 16, color: Color(0xff667085))
//           ],
//         )
//         // widget.tableInformation.tableRows.map((e) => Container()).toList()
//       ],
//     );
//   }
// }
