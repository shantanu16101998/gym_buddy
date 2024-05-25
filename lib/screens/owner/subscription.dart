import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/components/owner/header.dart';
import 'package:gym_buddy/components/owner/side_bar.dart';
import 'package:gym_buddy/components/owner/subscription_card_container.dart';
import 'package:gym_buddy/components/owner/tab_bar.dart';
import 'package:gym_buddy/components/owner/text_box.dart';
import 'package:gym_buddy/providers/subscription_provider.dart';
import 'package:gym_buddy/screens/owner/user_sign_up.dart';
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

  bool ownerGivenLocation = false;

  String ownerName = "Owner";

  fetchOwnerName() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      ownerName = sharedPreferences.getString("ownerName") ?? "Owner";
    });
  }

  bool showCurrentUsers = true;

  @override
  void initState() {
    super.initState();
    fetchOwnerName();
    Provider.of<SubscriptionProvider>(context, listen: false)
        .fetchSubscription();
  }

  grantLocationPermission() async {
    bool locationPermission = await isLocationPermissionGiven();
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
        drawer: SideBar(ownerName: ownerName),
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
                      Header(ownerName: ownerName),
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
                      SubscriptionCardContainer(
                        showCurrentUsers: showCurrentUsers,
                        currentUsers:
                            context.watch<SubscriptionProvider>().currentUsers,
                        expiredUsers:
                            context.watch<SubscriptionProvider>().expiredUsers,
                      )
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
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: const Color(0xFFD9D9D9)),
                                  child: const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text("Add Members",
                                          style: TextStyle(
                                              color: Color(0xff004576),
                                              fontSize: 18,
                                              fontWeight:
                                                  FontWeight.bold))))))),
                )),
            !ownerGivenLocation
                ? Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 200,
                      width: 300,
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
                                  padding: EdgeInsets.all(20.0),
                                  child: CustomText(
                                    text: 'Grant permission',
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
