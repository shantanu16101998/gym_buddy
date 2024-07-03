import 'package:flutter/material.dart';
import 'package:gym_buddy/constants/environment.dart';
import 'package:gym_buddy/utils/enums.dart';

const formValidationErrorColor = Colors.red;

const attendanceMarkPresent = Color(0xff3ABA2E);
const attendanceMarkAbsent = Color(0xffE56B6B);
const attendanceMarkNothing = Color(0xffD9D9D9);
const subscriptionCardNewbie = Color(0xff19AE01);
const primaryColor = appEnvironment == AppEnvironment.member
    ? Color(0xffE63744)
    : Color(0xff000042);

const headerColor = Colors.black;
