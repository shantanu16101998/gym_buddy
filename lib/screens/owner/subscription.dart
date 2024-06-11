import 'package:flutter/material.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/components/owner/header.dart';
import 'package:gym_buddy/components/owner/loader.dart';
import 'package:gym_buddy/components/owner/side_bar.dart';
import 'package:gym_buddy/components/owner/subscription_card_container.dart';
import 'package:gym_buddy/components/owner/tab_bar.dart';
import 'package:gym_buddy/components/owner/text_box.dart';
import 'package:gym_buddy/providers/subscription_provider.dart';
import 'package:gym_buddy/screens/owner/user_sign_up.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'package:gym_buddy/utils/custom.dart';
import 'package:gym_buddy/utils/ui_constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Subscription extends StatefulWidget {
  const Subscription({super.key});

  @override
  State<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  final TextEditingController _searchController = TextEditingController();

  bool ownerGivenLocation = true;
  String userName = "Owner";

  initialConfigs() async {
    var sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      userName = sharedPreferences.getString("userName") ?? "Owner";
      ownerGivenLocation =
          sharedPreferences.getBool('isLocationPermissionGiven') ?? false;
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
    bool locationPermission = await getCurrentLocationSuccess();

    if (locationPermission) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      backendAPICall(
          '/owner/updateLocation',
          {
            'lat': sharedPreferences.getDouble('latitude'),
            'lon': sharedPreferences.getDouble('longitude')
          },
          'PUT',
          true);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: SideBar(userName: userName),
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  padding: EdgeInsets.only(
                      top: getStatusBarHeight(context),
                      left: 10,
                      right: 10,
                      bottom: 100),
                  child: Column(
                    children: [
                      Header(userName: userName),
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
                          : const SizedBox(child: Loader())
                    ],
                  ),
                )),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 100,
                  color: Colors.white,
                  child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                          padding: const EdgeInsets.only(bottom: 10, top: 10),
                          child: SizedBox(
                              height: 50,
                              width: 340,
                              child: ElevatedButton(
                                  onPressed: () => {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const UserSignUp()))
                                      },
                                  style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                          color: Colors.black, width: 1),
                                      elevation: 0,
                                      backgroundColor:
                                          Color.fromARGB(255, 255, 255, 255)),
                                  child: const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text("Add Members",
                                          style: TextStyle(
                                              color: headingColor,
                                              fontSize: 18,
                                              fontWeight:
                                                  FontWeight.bold))))))),
                )),
            !ownerGivenLocation
                ? Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 200,
                      width: 340,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            width: 1, color: const Color(0xffDBDDE2)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(width: 40),
                              const Padding(
                                  padding: EdgeInsets.only(top: 20.0),
                                  child: CustomText(
                                    text: 'Required for attendance',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  )),
                              const SizedBox(width: 30),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      ownerGivenLocation = true;
                                    });
                                  },
                                  child: const Icon(Icons.close))
                            ],
                          ),
                          const SizedBox(height: 30),
                          OutlinedButton(
                              onPressed: grantLocationPermission,
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.transparent,
                                  side: const BorderSide(
                                      width: 1, color: Colors.black)),
                              child: const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text("Grant Location Permission",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold))))
                        ],
                      ),
                    ))
                : const SizedBox()
          ],
        ));
  }
}
