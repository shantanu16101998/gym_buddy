import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gym_buddy/components/common/app_scaffold.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/components/owner/gym_analysis.dart';
import 'package:gym_buddy/components/owner/header.dart';
import 'package:gym_buddy/components/owner/subscription_card_container.dart';
import 'package:gym_buddy/components/owner/text_box.dart';
import 'package:gym_buddy/providers/subscription_provider.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'package:gym_buddy/utils/ui_constants.dart';
import 'package:provider/provider.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);

    Provider.of<SubscriptionProvider>(context, listen: false)
        .fetchSubscription();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _searchController = TextEditingController();

    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Header(),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
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
                    tabs: [
                      Tab(child: Text("Tab 1")),
                      Tab(child: Text("Tab 2")),
                    ],
                  ),
                ],
              ),
            ),
          ],
          body: TabBarView(
            children: [
              Container(
                child: SingleChildScrollView(
                  child: SubscriptionCardContainer(
                    users: context.watch<SubscriptionProvider>().currentUsers,
                  ),
                ),
              ),
              SubscriptionCardContainer(
                users: context.watch<SubscriptionProvider>().currentUsers,
              )
            ],
          ),
        ),
      ),
    );
  }
}
