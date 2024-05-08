import 'package:flutter/material.dart';
import 'package:gym_buddy/components/header.dart';
import 'package:gym_buddy/components/side_bar.dart';
import 'package:gym_buddy/components/subscription_card_container.dart';
import 'package:gym_buddy/components/tab_bar.dart';
import 'package:gym_buddy/components/text_box.dart';
import 'package:gym_buddy/screens/user_sign_up.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';
import 'package:gym_buddy/utils/ui_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gym_buddy/models/responses.dart';

class Subscription extends StatefulWidget {
  const Subscription({super.key});

  @override
  State<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  final TextEditingController _searchController = TextEditingController();
  List currentUsers = [];
  List expiredUsers = [];
  List allCurrentUsers = [];
  List allExpiredUsers = [];

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
    fetchSubscription();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchSubscription();
  }

  fetchSubscription() async {
    // var sharedPreferences = await SharedPreferences.getInstance();

    SubscriptionDetailsResponse subscriptionDetailsResponse =
        SubscriptionDetailsResponse.fromJson(
            await backendAPICall('/customer/getCustomers', null, "GET", true));

    setState(() {
      currentUsers = subscriptionDetailsResponse.currentUsers;
      expiredUsers = subscriptionDetailsResponse.expiredUsers;
      allCurrentUsers = currentUsers;
      allExpiredUsers = expiredUsers;
    });
  }

  _onSearchTextFieldChanged(String currentText) {
    setState(() {
      currentUsers = allCurrentUsers
          .where((currentUser) =>
              currentUser.name.toLowerCase()!.contains(currentText))
          .toList();
      expiredUsers = allExpiredUsers
          .where((expiredUser) =>
              expiredUser.name.toLowerCase()!.contains(currentText))
          .toList();
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
                  // color: Colors.white,
                  // padding: EdgeInsets.all(10),
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
                          numberOfCurrentUsers: allCurrentUsers.length,
                          numberOfExpiredUsers: allExpiredUsers.length),
                      Container(
                        width: 340,
                        child: LabeledTextField(
                            labelText: "Search members",
                            controller: _searchController,
                            onChange: _onSearchTextFieldChanged,
                            textColour: const Color(0xff667085),
                            borderColor: const Color(0xffD0D5DD),
                            cursorColor: const Color(0xff667085),
                            errorText: null),
                      ),
                      SubscriptionCardContainer(
                        fetchSubsription: fetchSubscription,
                        showCurrentUsers: showCurrentUsers,
                        currentUsers: currentUsers,
                        expiredUsers: expiredUsers,
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
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UserSignUp()))
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
                ))
          ],
        ));
  }
}
