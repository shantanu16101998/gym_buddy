import 'package:flutter/material.dart';
import 'package:gym_buddy/components/common/custom_dialog_box.dart';
import 'package:gym_buddy/components/owner/subscription_card_container.dart';
import 'package:gym_buddy/components/owner/tab_bar.dart';
import 'package:gym_buddy/components/owner/text_box.dart';
import 'package:gym_buddy/models/responses.dart';
import 'package:gym_buddy/providers/subscription_provider.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'package:gym_buddy/utils/custom.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class Subscription extends StatefulWidget {
  const Subscription({super.key});

  @override
  State<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
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

  @override
  void initState() {
    super.initState();
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
                  buttonColor: headingColor,
                  iconWidget: const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Icon(Icons.location_on,
                        size: 60, color: headingColor),
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
              // padding: EdgeInsets.only(bottom: 100),
              child: Column(
                children: [
                  CustomTabBar(
                      setShouldShowCurrent: setShouldShowCurrent,
                      showCurrentUsers: showCurrentUsers,
                      numberOfCurrentUsers: context
                          .watch<SubscriptionProvider>()
                          .allCurrentUsers
                          .length,
                      numberOfExpiredUsers: context
                          .watch<SubscriptionProvider>()
                          .allExpiredUsers
                          .length),
                  SizedBox(
                    width: 360,
                    child: LabeledTextField(
                        labelText: "Search members",
                        controller: _searchController,
                        onChange: context
                            .read<SubscriptionProvider>()
                            .onSearchTextFieldChanged,
                        textColour: const Color(0xff667085),
                        borderColor: const Color(0xffD0D5DD),
                        cursorColor: const Color(0xff667085),
                        errorText: null),
                  ),
                  context
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
                                  baseColor:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  highlightColor:
                                      const Color.fromARGB(255, 227, 227, 226),
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
                                  baseColor:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  highlightColor:
                                      const Color.fromARGB(255, 227, 227, 226),
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
                                  baseColor:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  highlightColor:
                                      const Color.fromARGB(255, 227, 227, 226),
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
                  const SizedBox(height: 100)
                ],
              ),
            )),
      ],
    );
  }
}
