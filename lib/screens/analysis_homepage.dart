import 'package:flutter/material.dart';
import 'package:gym_buddy/components/analysis_card_container.dart';
import 'package:gym_buddy/components/app_scaffold.dart';
import 'package:gym_buddy/models/responses.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';

class AnalysisHomepage extends StatefulWidget {
  const AnalysisHomepage({super.key});

  @override
  State<AnalysisHomepage> createState() => _AnalysisHomepageState();
}

class _AnalysisHomepageState extends State<AnalysisHomepage> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  bool isApiDataLoaded = false;

  AnalysisHomepageResponse analysisHomepageResponse =
      const AnalysisHomepageResponse(
          earnings: 0, numberOfPeople: 0, averageMonth: "", genderRatio: "");

  fetchData() async {
    var _analysisHomepageResponse = AnalysisHomepageResponse.fromJson(
        await backendAPICall('/analysis', {}, 'POST', true));
    setState(() {
      analysisHomepageResponse = _analysisHomepageResponse;
      isApiDataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isApiDataLoaded: isApiDataLoaded,
      child: AnalysisCardContainer(
          analysisHomepageResponse: analysisHomepageResponse),
    );
  }
}
