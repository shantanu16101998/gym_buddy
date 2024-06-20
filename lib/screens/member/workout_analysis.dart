import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gym_buddy/components/common/app_scaffold.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/models/responses.dart';
import 'package:gym_buddy/providers/exercise_list_provider.dart';
import 'package:gym_buddy/screens/common/screen_shimmer.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'package:gym_buddy/utils/ui_constants.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class WorkoutAnalayis extends StatefulWidget {
  const WorkoutAnalayis({super.key});

  @override
  State<WorkoutAnalayis> createState() => _WorkoutAnalayisState();
}

class _WorkoutAnalayisState extends State<WorkoutAnalayis> {
  int comparisionExerciseIndex = 0;
  bool isApiDataLoaded = false;

  WorkoutAnalysisResponse workoutAnalysisResponse = WorkoutAnalysisResponse(
      comparisionData: ComparisionData(
          data: [],
          titles: [],
          maxLimitOfData: 0,
          top: 0,
          highlightTitle: 0,
          minLimitOfData: 0),
      growthData: GrowthData(
          titles: [], data: [], maxLimitOfData: 0, minLimitOfData: 0));

  fetchExerciseAndData() async {
    await Provider.of<ExerciseListProvider>(context, listen: false)
        .fetchUserExercise();

    if (Provider.of<ExerciseListProvider>(context, listen: false)
        .analysisExerciseTableInformation
        .isNotEmpty) {
      await fetchData();
    } else {
      isApiDataLoaded = true;
    }
  }

  fetchData() async {
    WorkoutAnalysisResponse workoutAnalysisResponseFromAPI =
        WorkoutAnalysisResponse.fromJson(await backendAPICall(
            '/customer/workoutAnalysis',
            {
              'exerciseName':
                  Provider.of<ExerciseListProvider>(context, listen: false)
                      .analysisExerciseTableInformation[comparisionExerciseIndex]
                      .name
            },
            'POST',
            true));

    setState(() {
      workoutAnalysisResponse = workoutAnalysisResponseFromAPI;
      isApiDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchExerciseAndData();
  }

  List<BarChartGroupData> makeData() {
    return workoutAnalysisResponse.comparisionData.data
        .asMap()
        .entries
        .map((entry) => BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                    toY: entry.value.toDouble(),
                    color: entry.key ==
                            workoutAnalysisResponse
                                .comparisionData.highlightTitle
                        ? const Color(0xff344054)
                        : const Color(0xff9FA5B3),
                    width: 20,
                    borderRadius: BorderRadius.circular(0))
              ],
            ))
        .toList();
  }

  List<BarChartGroupData> makeDataForGrowth() {
    return workoutAnalysisResponse.growthData.data
        .asMap()
        .entries
        .map((entry) => BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                    toY: entry.value.toDouble(),
                    color: entry.key ==
                            workoutAnalysisResponse.growthData.data.length - 1
                        ? const Color(0xff344054)
                        : const Color(0xff9FA5B3),
                    width: 20,
                    borderRadius: BorderRadius.circular(0))
              ],
            ))
        .toList();
  }

  Widget getBottomTitlesWidgetForGrowth(double x, TitleMeta titleMeta) {
    return CustomText(
        text: workoutAnalysisResponse.growthData.titles[x.round()].toString(),
        color: const Color(0XFF86909C));
  }

  Widget getBottomTitlesWidget(double x, TitleMeta titleMeta) {
    return CustomText(
        text: workoutAnalysisResponse.comparisionData.titles[x.round()]
            .toString(),
        color: const Color(0XFF86909C));
  }

  Widget getLeftTitlesWidget(double x, TitleMeta titleMeta) {
    return CustomText(
        text: NumberFormat.compact(locale: 'en_IN').format(x),
        color: const Color(0XFF86909C));
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _comparisionSearchController =
        TextEditingController();

    return isApiDataLoaded
        ? Provider.of<ExerciseListProvider>(context, listen: true)
                .analysisExerciseTableInformation
                .isEmpty
            ? const Padding(
                padding: EdgeInsets.only(top: 200),
                child: CustomText(
                  text: 'Please do some workout to get analysis',
                  fontSize: 40,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffD9D9D9),
                ),
              )
            : Container(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child:  CustomText(
                        text: 'Workout Analysis',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: headingColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40, top: 20),
                      child: SizedBox(
                        child: DropdownButton2<ExercisesTableInformation>(
                          dropdownSearchData: DropdownSearchData(
                            searchController: _comparisionSearchController,
                            searchInnerWidgetHeight: 50,
                            searchInnerWidget: Container(
                                height: 50,
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  bottom: 4,
                                  right: 8,
                                  left: 8,
                                ),
                                child: TextFormField(
                                  expands: true,
                                  maxLines: null,
                                  controller: _comparisionSearchController,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    hintText: 'Search',
                                    hintStyle: const TextStyle(fontSize: 12),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                )),
                          ),
                          iconStyleData: const IconStyleData(
                              icon: RotatedBox(
                            quarterTurns: 3,
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 10,
                            ),
                          )),
                          dropdownStyleData: const DropdownStyleData(
                              maxHeight: 250,
                              decoration: BoxDecoration(color: Colors.white)),
                          value: context
                                  .watch<ExerciseListProvider>()
                                  .analysisExerciseTableInformation[
                              comparisionExerciseIndex],
                          onChanged: (ExercisesTableInformation? value) {
                            if (value != null) {
                              print(value.name);
                              setState(() {
                                comparisionExerciseIndex =
                                    Provider.of<ExerciseListProvider>(context,
                                            listen: false)
                                        .analysisExerciseTableInformation
                                        .indexOf(value);
                                // print('comparision index is' +
                                //     comparisionExerciseIndex.toString());
                                fetchData();
                              });
                            }
                          },
                          items: context
                              .watch<ExerciseListProvider>()
                              .analysisExerciseTableInformation
                              .map<DropdownMenuItem<ExercisesTableInformation>>(
                                  (ExercisesTableInformation value) {
                            return DropdownMenuItem<ExercisesTableInformation>(
                              value: value,
                              child: SizedBox(
                                  child: CustomText(
                                text: value.name.toString(),
                              )),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: CustomText(
                        text: 'Peer analysis (Max Weight/ 8 reps)',
                        fontSize: 20,
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.bold,
                        color: headingColor,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 20, bottom: 20),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: SizedBox(
                                  width: 50,
                                  child: CustomText(
                                    text: 'No of people',
                                    color: Color(0XFF86909C),
                                  ))),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              CustomText(
                                text:
                                    'Top ${workoutAnalysisResponse.comparisionData.top}%',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: headingColor,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: getScreenHeight(context) * 0.3,
                      width: getScreenWidth(context) * 0.8,
                      child: BarChart(
                        BarChartData(
                            barTouchData: BarTouchData(
                                touchTooltipData: BarTouchTooltipData(
                                    getTooltipColor: (_) => Colors.white)),
                            maxY: workoutAnalysisResponse
                                .comparisionData.maxLimitOfData
                                .toDouble(),
                            minY: workoutAnalysisResponse
                                .comparisionData.minLimitOfData
                                .toDouble(),
                            barGroups: makeData(),
                            borderData: FlBorderData(
                                border: const Border(
                              bottom: BorderSide(
                                  width: 1, color: Color(0xffc9cdd4)),
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
                    const Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: CustomText(
                          text: 'Weight (kg)', color: Color(0XFF86909C)),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CustomText(
                        text: 'Growth',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: headingColor,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 20, bottom: 20),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: SizedBox(
                              width: 50,
                              child: CustomText(
                                text: 'Volume (kg)',
                                color: Color(0XFF86909C),
                              ))),
                    ),
                    SizedBox(
                      height: getScreenHeight(context) * 0.3,
                      width: getScreenWidth(context) * 0.8,
                      child: BarChart(
                        BarChartData(
                            barTouchData: BarTouchData(
                                touchTooltipData: BarTouchTooltipData(
                                    getTooltipColor: (_) => Colors.white)),
                            minY: workoutAnalysisResponse
                                .growthData.minLimitOfData
                                .toDouble(),
                            barGroups: makeDataForGrowth(),
                            borderData: FlBorderData(
                                border: const Border(
                              bottom: BorderSide(
                                  width: 1, color: Color(0xffc9cdd4)),
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
                                      getTitlesWidget:
                                          getBottomTitlesWidgetForGrowth)),
                            )),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 100),
                      child:
                          CustomText(text: 'Session', color: Color(0XFF86909C)),
                    )
                  ],
                ),
              )
        : const ScreenShimmer();
  }
}
