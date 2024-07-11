import 'package:flutter/material.dart';
import 'package:gym_buddy/components/common/custom_dialog_box.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/components/owner/header.dart';
import 'package:gym_buddy/components/owner/side_bar.dart';
import 'package:gym_buddy/components/owner/subscription_card_container.dart';
import 'package:gym_buddy/components/owner/text_box.dart';
import 'package:gym_buddy/database/user_subscription.dart';
import 'package:gym_buddy/models/responses.dart';
import 'package:gym_buddy/models/user_subscription.dart';
import 'package:gym_buddy/providers/subscription_provider.dart';
import 'package:gym_buddy/screens/owner/user_sign_up.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'package:gym_buddy/utils/custom.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class Subscription extends StatefulWidget {
  const Subscription({super.key});

  @override
  State<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();

  bool ownerGivenLocation = true;

  initialConfigs() async {
    OwnerDetails ownerDetails = OwnerDetails.fromJson(
        await backendAPICall('/owner/details', {}, 'GET', true));

    setState(() {
      ownerGivenLocation = ownerDetails.gymLocationLat != null;

      if (!ownerGivenLocation) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showAlertDialog();
        });
      }
    });
  }

  late AnimationController _animationController;

  void toggleVisibility() {
    setState(() {
      if (tabController.index == 0) {
        _animationController.forward(); // Play forward animation
      } else {
        _animationController.reverse(); // Reverse animation
      }
    });
  }

  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);

    initialConfigs();
    Provider.of<SubscriptionProvider>(context, listen: false)
        .fetchSubscription();
  }

  grantLocationPermission() async {
    LocationResult locationResult = await getCurrentLocationSuccess();
    bool locationPermission = locationResult.success;

    if (locationPermission) {
      backendAPICall(
          '/owner/updateLocation',
          {'lat': locationResult.latitude, 'lon': locationResult.longitude},
          'PUT',
          true);
    }

    if (mounted) {
      Navigator.pop(context);
    }

    setState(() {
      ownerGivenLocation = locationPermission;
    });
  }

  void showAlertDialog() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              elevation: 0,
              backgroundColor:
                  Colors.transparent, // Set background color to white
              content: CustomDialogBox(
                  shouldShowExtraDismissButton: true,
                  buttonColor: primaryColor,
                  iconWidget: const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child:
                        Icon(Icons.location_on, size: 60, color: primaryColor),
                  ),
                  heading: 'Are you inside gym ?',
                  subheading:
                      'Please grant location permission for users to mark their attendance',
                  buttonName: 'Allow',
                  buttonAction: grantLocationPermission));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideBar(userName: ''),
      body: Stack(children: [
        NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const Header(),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 10,
                    ),
                    // width: 360,
                    child: LabeledTextField(
                        prefixIcon:
                            const Icon(Icons.search, color: Color(0xff667085)),
                        labelText: "Search members...",
                        controller: _searchController,
                        onChange: context
                            .read<SubscriptionProvider>()
                            .onSearchTextFieldChanged,
                        textColour: const Color(0xff667085),
                        borderColor: const Color(0xffD0D5DD),
                        cursorColor: const Color(0xff667085),
                        errorText: null),
                  ),
                  TabBar(
                    dividerColor: const Color(0xffD0D5DD),
                    controller: tabController,
                    indicatorColor: const Color(0xff344054),
                    labelColor: const Color(0xff344054),
                    unselectedLabelColor:
                        const Color(0xff344054).withOpacity(0.64),
                    tabs: [
                      Tab(
                        child: Container(
                          color: Colors.transparent,
                          width: 100,
                          height: 50,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: CustomText(
                                text:
                                    "Current (${context.watch<SubscriptionProvider>().allCurrentUsers.length})",
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          color: Colors.transparent,
                          width: 100,
                          height: 50,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: CustomText(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  text:
                                      "Expired (${context.watch<SubscriptionProvider>().allExpiredUsers.length})"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          body: TabBarView(
            controller: tabController,
            children: [
              context.watch<SubscriptionProvider>().subcriptionAPIDataFetched
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Stack(children: [
                        SingleChildScrollView(
                          child: SubscriptionCardContainer(
                            users: context
                                .watch<SubscriptionProvider>()
                                .currentUsers,
                          ),
                        ),
                        Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 25, bottom: 25),
                              child: GestureDetector(
                                onTap: () async {


                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const UserSignUp()));
                                },
                                child: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: const BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 2, color: Colors.grey)
                                        ]),
                                    child: const Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                            child: Text("+",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 30,
                                                    fontWeight:
                                                        FontWeight.bold))))),
                              ),
                            )),
                      ]),
                    )
                  : SizedBox(
                      child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Shimmer.fromColors(
                            baseColor: const Color.fromARGB(255, 255, 255, 255),
                            highlightColor:
                                const Color.fromARGB(255, 227, 227, 226),
                            child: Container(
                              height: 200,
                              width: 360,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: const Color(0xffDBDDE2)),
                              ),
                            ),
                          )),
                    ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SingleChildScrollView(
                  child: SubscriptionCardContainer(
                    users: context.watch<SubscriptionProvider>().expiredUsers,
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
