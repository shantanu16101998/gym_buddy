import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gym_buddy/components/common/custom_dialog_box.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/components/owner/subscription_card_container.dart';
import 'package:gym_buddy/components/owner/tab_bar.dart';
import 'package:gym_buddy/components/owner/text_box.dart';
import 'package:gym_buddy/models/responses.dart';
import 'package:gym_buddy/providers/subscription_provider.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'package:gym_buddy/utils/custom.dart';
import 'package:gym_buddy/utils/ui_constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  bool showCurrentUsers = true;

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

  Future<void> setShouldShowCurrent(bool value) async {
    var sharedPreference = await SharedPreferences.getInstance();
    await sharedPreference.setBool("showCurrent", value);
    setState(() {
      showCurrentUsers = value;
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
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                    // width: 360,
                    child: LabeledTextField(
                        prefixIcon:
                            Icon(Icons.search, color: const Color(0xff667085)),
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
                    dividerColor: Color(0xffD0D5DD),
                    onTap: (value) {
                      if (value == 0) {
                        setShouldShowCurrent(true);
                      } else {
                        setShouldShowCurrent(false);
                      }
                    },
                    controller: tabController,
                    indicatorColor: Color(0xff344054),
                    labelColor: Color(0xff344054),
                    unselectedLabelColor: Color(0xff344054).withOpacity(0.64),
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
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: context
                            .watch<SubscriptionProvider>()
                            .subcriptionAPIDataFetched
                        ? SubscriptionCardContainer(
                            showCurrentUsers: showCurrentUsers,
                            currentUsers: context
                                .watch<SubscriptionProvider>()
                                .currentUsers,
                            expiredUsers: context
                                .watch<SubscriptionProvider>()
                                .expiredUsers,
                          )
                        : SizedBox(
                            child: Column(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Shimmer.fromColors(
                                    baseColor: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    highlightColor: const Color.fromARGB(
                                        255, 227, 227, 226),
                                    child: Container(
                                      height: 200,
                                      width: 360,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: const Color(0xffDBDDE2)),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
                                      ),
                                    ),
                                  )),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Shimmer.fromColors(
                                    baseColor: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    highlightColor: const Color.fromARGB(
                                        255, 227, 227, 226),
                                    child: Container(
                                      height: 200,
                                      width: 360,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: const Color(0xffDBDDE2)),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
                                      ),
                                    ),
                                  )),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Shimmer.fromColors(
                                    baseColor: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    highlightColor: const Color.fromARGB(
                                        255, 227, 227, 226),
                                    child: Container(
                                      height: 150,
                                      width: 360,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: const Color(0xffDBDDE2)),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
                                      ),
                                    ),
                                  )),
                            ],
                          )),
                  ),
                  const SizedBox(height: 100)
                ],
              ),
            )),
      ],
    );
  }
}
