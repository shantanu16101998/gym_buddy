import 'package:flutter/material.dart';
import 'package:gym_buddy/components/subscription_card.dart';
import 'package:gym_buddy/models/user_subscription.dart';

class SubscriptionCardContainer extends StatefulWidget {
  final bool showCurrentUsers;
  const SubscriptionCardContainer({super.key,required this.showCurrentUsers});

  @override
  State<SubscriptionCardContainer> createState() =>
      _SubscriptionCardContainerState();
}

class _SubscriptionCardContainerState extends State<SubscriptionCardContainer> {
  List listToShow() {
    if (widget.showCurrentUsers) {
      return currentUsers;
    } else {
      return expiredUsers;
    }
  }

  final List currentUsers = [
    UserSubscription("Shantanu Mukherjee", "31 March 2023", "22 April 2024"),
    UserSubscription("Suraj Kumar", "31 March 2023", "22 April 2024")
  ];

  final List expiredUsers = [
    UserSubscription("Aryan Gupta", "31 March 2023", "22 April 2024"),
    UserSubscription("Shivendra Yadav", "31 March 2023", "22 April 2024")
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: listToShow()
          .map((userSubscription) => Padding(
              padding: const EdgeInsets.all(5),
              child: SubscriptionCard(
                name: userSubscription.name,
                startDate: userSubscription.startDate,
                endDate: userSubscription.endDate,
                expiredDay: widget.showCurrentUsers ? null : "10",
                expiringDay: widget.showCurrentUsers ? "10" : null,
              )))
          .toList(),

      // Padding(
      //     padding: EdgeInsets.all(5),
      //     child: SubscriptionCard(
      //       name: "Shantanu Mukherjee",
      //       startDate: "31 March 2023",
      //       endDate: "22 April 2024",
      //       expiredDay: "10",
      //       expiringDay: null,
      //     )),
      // Padding(
      //     padding: EdgeInsets.all(5),
      //     child: SubscriptionCard(
      //         name: "Suraj Kumar",
      //         startDate: "31 March 2023",
      //         endDate: "22 April 2024",
      //         expiredDay: null,
      //         expiringDay: "10")),
      // Padding(
      //     padding: EdgeInsets.all(5),
      //     child: SubscriptionCard(
      //         name: "Shivendra Yadav",
      //         startDate: "31 March 2023",
      //         endDate: "22 April 2024",
      //         expiredDay: null,
      //         expiringDay: null))
    );
  }
}
