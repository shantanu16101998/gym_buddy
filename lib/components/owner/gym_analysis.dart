import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/models/responses.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'package:intl/intl.dart';

class GymAnalysis extends StatefulWidget {
  const GymAnalysis({super.key});

  @override
  State<GymAnalysis> createState() => _GymAnalysisState();
}

class _GymAnalysisState extends State<GymAnalysis> {
  ExpandedAnalysisResponse earningExpandedAnalysisResponse =
      ExpandedAnalysisResponse(
          titles: [], data: [], average: 0, total: 0, maxLimitOfData: 100);

  ExpandedAnalysisResponse peopleExpandedAnalysisResponse =
      ExpandedAnalysisResponse(
          titles: [], data: [], average: 0, total: 0, maxLimitOfData: 100);

  Widget getBottomTitlesWidget(double x, TitleMeta titleMeta) {
    return CustomText(
        text: x.round() == x
            ? earningExpandedAnalysisResponse.titles.length > x.round()
                ? earningExpandedAnalysisResponse.titles[x.round()]
                : ''
            : '',
        color: const Color(0XFF86909C));
  }

  Widget getLeftTitlesWidget(double x, TitleMeta titleMeta) {
    return CustomText(
        text: convertToIndianNumber(x), color: const Color(0XFF86909C));
  }

  String convertToIndianNumber(num input) {
    String locale = NumberFormat.compact(locale: 'en_IN').format(input);
    return locale.endsWith('T') ? locale.replaceFirst('T', 'K') : locale;
  }

  String convertToIndianNumberString(String input) {
    try {
      String locale = NumberFormat.compact(locale: 'en_IN').format(input);
      return locale.endsWith('T') ? locale.replaceFirst('T', 'K') : locale;
    } catch (e) {
      return input;
    }
  }

  bool isApiDataLoaded = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    ExpandedAnalysisResponse _expandedAnalysisResponse =
        ExpandedAnalysisResponse.fromJson(
            await backendAPICall('/owner/analysis/earnings', {}, 'POST', true));

    ExpandedAnalysisResponse _peopleExpandedAnalysisResponse =
        ExpandedAnalysisResponse.fromJson(
            await backendAPICall('/owner/analysis/people', {}, 'POST', true));
    setState(() {
      earningExpandedAnalysisResponse = _expandedAnalysisResponse;
      peopleExpandedAnalysisResponse = _peopleExpandedAnalysisResponse;
      isApiDataLoaded = true;
    });
  }

  LinearGradient lowToHighGradient() {
    return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.green, Colors.white]);
  }

  LinearGradient highToLowGradient() {
    return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.red, Colors.white]);
  }

  @override
  Widget build(BuildContext context) {
    List<FlSpot> makeData() {
      return earningExpandedAnalysisResponse.data
          .asMap()
          .entries
          .map((entry) => FlSpot(entry.key.toDouble(), entry.value.toDouble()))
          .toList();
    }

    List<FlSpot> makePeopleData() {
      return peopleExpandedAnalysisResponse.data
          .asMap()
          .entries
          .map((entry) => FlSpot(entry.key.toDouble(), entry.value.toDouble()))
          .toList();
    }

    return Column(
      children: [
        const CustomText(
          text: 'Gym Analysis',
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 25, left: 10, right: 10),
          child: Container(
            // width: 400,
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xffE5E6EB)),
                borderRadius: const BorderRadius.all(Radius.circular(12))),
            child: Column(children: [
              const Padding(
                padding: EdgeInsets.only(top: 30),
                child: CustomText(
                  text: 'Earnings',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                    text: 'Rupees',
                    color: primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20,left: 25,right: 25),
                // width: 350,
                // height: 300,
                child: Container(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: LineChart(LineChartData(
                        lineTouchData: LineTouchData(
                            getTouchedSpotIndicator: (LineChartBarData barData,
                                List<int> spotIndexes) {
                              return spotIndexes.map((index) {
                                return TouchedSpotIndicatorData(
                                  FlLine(
                                    color: Colors.black,
                                  ),
                                  FlDotData(
                                    show: true,
                                    getDotPainter:
                                        (spot, percent, barData, index) =>
                                            FlDotCirclePainter(
                                      // radius: 8,
                                      color: primaryColor,
                                      strokeWidth: 2,
                                      // strokeColor: widget.indicatorStrokeColor,
                                    ),
                                  ),
                                );
                              }).toList();
                            },
                            touchTooltipData: LineTouchTooltipData(
                                getTooltipColor: (touchedSpot) => Colors.white,
                                tooltipBorder: const BorderSide(
                                    color: const Color(0xffE5E6EB)))),
                        lineBarsData: [
                          LineChartBarData(
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: peopleExpandedAnalysisResponse
                                            .data.isNotEmpty &&
                                        earningExpandedAnalysisResponse
                                                .data.first <
                                            earningExpandedAnalysisResponse
                                                .data.last
                                    ? lowToHighGradient()
                                    : highToLowGradient(),
                              ),
                              dotData: const FlDotData(show: true),
                              color: primaryColor,
                              spots: makeData())
                        ],
                        maxY: earningExpandedAnalysisResponse.maxLimitOfData
                            .toDouble(),
                        gridData: const FlGridData(
                            drawHorizontalLine: true, drawVerticalLine: false),
                        borderData: FlBorderData(
                            border: const Border(
                          bottom:
                              BorderSide(width: 1, color: Color(0xffc9cdd4)),
                        )),
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
                        ))),
                  ),
                ),
              ),
              const CustomText(
                text: 'Months',
                color: primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: SizedBox(
                  width: 250,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: 'Monthly avg:',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                              SizedBox(height: 5),
                              CustomText(
                                text: 'Total:',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text:
                                    '₹ ${convertToIndianNumber(earningExpandedAnalysisResponse.average)}',
                                fontSize: 20,
                              ),
                              const SizedBox(height: 5),
                              CustomText(
                                text:
                                    '₹ ${convertToIndianNumber(earningExpandedAnalysisResponse.total)}',
                                fontSize: 20,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 25,left: 10,right: 10),
          child: Container(
            // width: 400,
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xffE5E6EB)),
                borderRadius: const BorderRadius.all(Radius.circular(12))),
            child: Column(children: [
              const Padding(
                padding: EdgeInsets.only(top: 30),
                child: CustomText(
                  text: 'Active Members',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                    text: 'People',
                    color: primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(25),
                // width: 350,
                // height: 300,
                child: Container(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: LineChart(LineChartData(
                        lineTouchData: LineTouchData(
                            getTouchedSpotIndicator: (LineChartBarData barData,
                                List<int> spotIndexes) {
                              return spotIndexes.map((index) {
                                return TouchedSpotIndicatorData(
                                  const FlLine(
                                    color: primaryColor,
                                  ),
                                  FlDotData(
                                    show: true,
                                    getDotPainter:
                                        (spot, percent, barData, index) =>
                                            FlDotCirclePainter(
                                      // radius: 8,
                                      color: primaryColor,
                                      strokeWidth: 2,
                                      // strokeColor: widget.indicatorStrokeColor,
                                    ),
                                  ),
                                );
                              }).toList();
                            },
                            touchTooltipData: LineTouchTooltipData(
                                getTooltipColor: (touchedSpot) => Colors.white,
                                tooltipBorder: const BorderSide(
                                    color: const Color(0xffE5E6EB)))),
                        lineBarsData: [
                          LineChartBarData(
                              belowBarData: BarAreaData(
                                  show: true,
                                  gradient: peopleExpandedAnalysisResponse
                                              .data.isNotEmpty &&
                                          peopleExpandedAnalysisResponse
                                                  .data.first <
                                              peopleExpandedAnalysisResponse
                                                  .data.last
                                      ? lowToHighGradient()
                                      : highToLowGradient()),
                              dotData: const FlDotData(show: true),
                              color: primaryColor,
                              spots: makePeopleData())
                        ],
                        maxY: peopleExpandedAnalysisResponse.maxLimitOfData
                            .toDouble(),
                        gridData: const FlGridData(
                            drawHorizontalLine: true, drawVerticalLine: false),
                        borderData: FlBorderData(
                            border: const Border(
                          bottom:
                              BorderSide(width: 1, color: Color(0xffc9cdd4)),
                        )),
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
                        ))),
                  ),
                ),
              ),
              const CustomText(
                text: 'Months',
                color: primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: SizedBox(
                  width: 250,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: 'Monthly avg:',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                              SizedBox(height: 5),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: peopleExpandedAnalysisResponse.average.toString(),
                                fontSize: 20,
                              ),
                              const SizedBox(height: 5),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ]),
          ),
        ),
      ],
    );
  }
}
