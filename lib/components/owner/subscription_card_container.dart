import 'package:flutter/material.dart';
import 'package:gym_buddy/components/owner/subscription_card.dart';

class SubscriptionCardContainer extends StatefulWidget {
  final List<dynamic> users;
  const SubscriptionCardContainer(
      {super.key, required this.users});

  @override
  State<SubscriptionCardContainer> createState() =>
      _SubscriptionCardContainerState();
}

class _SubscriptionCardContainerState extends State<SubscriptionCardContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: widget.users
          .map((userSubscription) => Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                children: [
                  SubscriptionCard(
                    userId: userSubscription.id,
                    name: userSubscription.name,
                    startDate: userSubscription.startDate,
                    endDate: userSubscription.endDate,
                    expiredDay: userSubscription.expiredDays,
                    expiringDay: userSubscription.expiringDays,
                    profilePic: userSubscription.profilePic,
                    experience: userSubscription.experience,
                    phone: userSubscription.contact,
                  ),
                ],
              )))
          .toList(),
    );
  }
}
