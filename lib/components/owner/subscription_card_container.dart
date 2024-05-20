import 'package:flutter/material.dart';
import 'package:gym_buddy/components/owner/subscription_card.dart';

class SubscriptionCardContainer extends StatefulWidget {
  final bool showCurrentUsers;
  final List<dynamic> currentUsers;
  final List<dynamic> expiredUsers;
  const SubscriptionCardContainer(
      {super.key,
      required this.showCurrentUsers,
      required this.currentUsers,
      required this.expiredUsers});

  @override
  State<SubscriptionCardContainer> createState() =>
      _SubscriptionCardContainerState();
}

class _SubscriptionCardContainerState extends State<SubscriptionCardContainer> {
  List listToShow() {
    if (widget.showCurrentUsers) {
      return widget.currentUsers;
    } else {
      return widget.expiredUsers;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: listToShow()
          .map((userSubscription) => Padding(
              padding: const EdgeInsets.all(5),
              child: SubscriptionCard(
                userId: userSubscription.id,
                name: userSubscription.name,
                startDate: userSubscription.startDate,
                endDate: userSubscription.endDate,
                expiredDay: userSubscription.expiredDays,
                expiringDay: userSubscription.expiringDays,
                profilePic: userSubscription.profilePic,
                phone:  userSubscription.contact,
              )))
          .toList(),
    );
  }
}
