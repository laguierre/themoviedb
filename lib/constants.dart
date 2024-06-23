import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'api_key.dart';
import 'package:flutter/material.dart';

const urlTheMovieDB = 'api.themoviedb.org';
const apiKey = myApiKey;

///USE YOUR API KEY HERE
const kSizePosterCoefficientPhone = 0.50;
const kSizePosterCoefficientTablet = 0.8;
const kViewportFraction = 0.8;
double kDescriptionDetailsText = 15.0.sp;
Color kTextDetailsColor = Colors.grey;
Color kSearchColorTextField = Colors.black38;
Color kSearchColorButton =  const Color(0xFF2D2C2C);
const kSearchDuration = 500;
TextStyle kTextStyleDetails = TextStyle(fontSize: 25.sp, color: kTextDetailsColor);

List<String> emojis = ["⭐", "⭐", "⭐", "⭐", "⭐"];
