import 'package:flutter/material.dart';
import 'package:gym_buddy/components/app_scaffold.dart';
import 'package:gym_buddy/components/custom_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gym_buddy/models/responses.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';
import 'package:gym_buddy/utils/ui_constants.dart';
import 'package:intl/intl.dart';

class ExpandedAnalysis extends StatefulWidget {
  const ExpandedAnalysis({super.key, required this.label});
  final String label;

  @override
  State<ExpandedAnalysis> createState() => _ExpandedAnalysisState();
}

class _ExpandedAnalysisState extends State<ExpandedAnalysis> {
  ExpandedAnalysisResponse expandedAnalysisResponse = ExpandedAnalysisResponse(
      titles: [], data: [], average: "", total: "", maxLimitOfData: 100);

  bool isApiDataLoaded = false;

  fetchData() async {
    ExpandedAnalysisResponse _expandedAnalysisResponse =
        ExpandedAnalysisResponse.fromJson(await backendAPICall(
            '/owner/analysis/${widget.label.toLowerCase()}', {}, 'POST', true));
    setState(() {
      expandedAnalysisResponse = _expandedAnalysisResponse;
      isApiDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  List<BarChartGroupData> makeData() {
    return expandedAnalysisResponse.data
        .asMap()
        .entries
        .map((entry) => BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                    toY: entry.value.toDouble(),
                    color: entry.key % 2 == 0
                        ? const Color(0xff344054)
                        : const Color(0xff344054),
                    width: 40,
                    borderRadius: BorderRadius.circular(0))
              ],
            ))
        .toList();
  }

  Widget getBottomTitlesWidget(double x, TitleMeta titleMeta) {
    return CustomText(
        text: expandedAnalysisResponse.titles[x.round()],
        color: const Color(0XFF86909C));
  }

  Widget getLeftTitlesWidget(double x, TitleMeta titleMeta) {
    return CustomText(
        text: NumberFormat.compact(locale: 'en_IN').format(x),
        color: const Color(0XFF86909C));
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isApiDataLoaded: isApiDataLoaded,
      child: Column(
        children: [
          Container(
            width: getScreenWidth(context) * 0.9,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(blurRadius: 2, color: Colors.grey)]),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  CustomText.bodyHeading(text: widget.label),
                  SizedBox(
                    height: getScreenHeight(context) * 0.3,
                    child: BarChart(
                      BarChartData(
                          maxY: expandedAnalysisResponse.maxLimitOfData
                              .toDouble(),
                          barGroups: makeData(),
                          borderData: FlBorderData(
                              border: const Border(
                            bottom:
                                BorderSide(width: 1, color: Color(0xffc9cdd4)),
                          )),
                          gridData: const FlGridData(
                              drawHorizontalLine: true,
                              drawVerticalLine: false),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                    reservedSize: 44,
                                    showTitles: true,
                                    getTitlesWidget: getLeftTitlesWidget)),
                            rightTitles: const AxisTitles(
                                sideTitles: SideTitles(
                                    reservedSize: 44, showTitles: false)),
                            topTitles: const AxisTitles(
                                sideTitles: SideTitles(
                                    reservedSize: 44, showTitles: false)),
                            bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                    reservedSize: 44,
                                    showTitles: true,
                                    getTitlesWidget: getBottomTitlesWidget)),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(blurRadius: 2, color: Colors.grey)]),
              width: getScreenWidth(context) * 0.9,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                              text: "Average ${widget.label}",
                              color: Color(0xff344054),
                              fontSize: 20),
                          CustomText(
                              text: expandedAnalysisResponse.average,
                              color: Color(0xff344054),
                              fontSize: 20)
                        ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                            text: "Total ${widget.label}",
                            color: Color(0xff344054),
                            fontSize: 20),
                        CustomText(
                            text: expandedAnalysisResponse.total,
                            color: Color(0xff344054),
                            fontSize: 20)
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
