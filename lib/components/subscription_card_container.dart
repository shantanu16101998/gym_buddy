import 'package:flutter/material.dart';
import 'package:gym_buddy/components/subscription_card.dart';

class SubscriptionCardContainer extends StatefulWidget {
  const SubscriptionCardContainer({super.key});

  @override
  State<SubscriptionCardContainer> createState() =>
      _SubscriptionCardContainerState();
}

class _SubscriptionCardContainerState extends State<SubscriptionCardContainer> {
  @override
  Widget build(BuildContext context) {
    return const Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
              padding: EdgeInsets.all(5),
              child: SubscriptionCard(
                name: "Shantanu Mukherjee",
                startDate: "31 March 2023",
                endDate: "22 April 2024",
                expiredDay: "10",
                expiringDay: null,
              )),
          Padding(
              padding: EdgeInsets.all(5),
              child: SubscriptionCard(
                  name: "Suraj Kumar",
                  startDate: "31 March 2023",
                  endDate: "22 April 2024",
                  expiredDay: null,
                  expiringDay: "10")),
          Padding(
              padding: EdgeInsets.all(5),
              child: SubscriptionCard(
                  name: "Shivendra Yadav",
                  startDate: "31 March 2023",
                  endDate: "22 April 2024",
                  expiredDay: null,
                  expiringDay: null))
        ]);
  }
}
