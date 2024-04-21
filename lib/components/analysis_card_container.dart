import 'package:flutter/material.dart';
import 'package:gym_buddy/components/analysis_card.dart';
import 'package:gym_buddy/components/custom_text.dart';
import 'package:gym_buddy/models/responses.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';

class AnalysisCardContainer extends StatefulWidget {
  const AnalysisCardContainer({super.key});

  @override
  State<AnalysisCardContainer> createState() => _AnalysisCardContainerState();
}

class _AnalysisCardContainerState extends State<AnalysisCardContainer> {
  AnalysisHomepageResponse analysisHomepageResponse =
      const AnalysisHomepageResponse(
          earnings: 0, numberOfPeople: 0, averageMonth: "", genderRatio: "");

  fetchData() async {
    var _analysisHomepageResponse = AnalysisHomepageResponse.fromJson(
        await backendAPICall('/analysis', {}, 'POST', true));
    setState(() {
      analysisHomepageResponse = _analysisHomepageResponse;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomText.bodyHeading(text: "Current Month"),
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnalysisCard(
                    value: analysisHomepageResponse.earnings.toString(),
                    label: "Earnings",
                    icon: Icons.credit_card),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnalysisCard(
                    value: analysisHomepageResponse.numberOfPeople.toString(),
                    label: "People",
                    icon: Icons.person),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnalysisCard(
                    value: analysisHomepageResponse.averageMonth,
                    label: "Average",
                    icon: Icons.lock_clock),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnalysisCard(
                    value: analysisHomepageResponse.genderRatio,
                    label: "Gender",
                    icon: Icons.transgender),
              ),
            ],
          ),
        )
      ],
    );
  }
}
