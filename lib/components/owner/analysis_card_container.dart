import 'package:flutter/material.dart';
import 'package:gym_buddy/components/owner/analysis_card.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/models/responses.dart';
import 'package:gym_buddy/utils/custom.dart';

class AnalysisCardContainer extends StatefulWidget {
  final AnalysisHomepageResponse analysisHomepageResponse;
  const AnalysisCardContainer({super.key,required this.analysisHomepageResponse});

  @override
  State<AnalysisCardContainer> createState() => _AnalysisCardContainerState();
}

class _AnalysisCardContainerState extends State<AnalysisCardContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomText.bodyHeading(text: "Current Month"),
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnalysisCard(
                    value: formatCurrency(widget.analysisHomepageResponse.earnings),
                    label: "Earnings",
                    icon: Icons.credit_card),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnalysisCard(
                    value: widget.analysisHomepageResponse.numberOfPeople.toString(),
                    label: "People",
                    icon: Icons.person),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnalysisCard(
                    value: widget.analysisHomepageResponse.averageMonth.toString(),
                    label: "Average",
                    icon: Icons.lock_clock),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnalysisCard(
                    value: widget.analysisHomepageResponse.males.toString(),
                    label: "Males",
                    icon: Icons.male),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnalysisCard(
                    value: widget.analysisHomepageResponse.females.toString(),
                    label: "Females",
                    icon: Icons.female),
              ),
            ],
          ),
        )
      ],
    );
  }
}
