import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget headingText({
  required String text,
  FontWeight fontWeight = FontWeight.bold,
  Color color = Colors.black,
  TextAlign textAlign = TextAlign.start,
  int maxLines = 1,
  TextOverflow overflow = TextOverflow.ellipsis,
}) {
  return Builder(
    builder: (context) => MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Text(
        text,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        style: TextStyle(
          color: color,
          fontSize: 24.sp,
          fontWeight: fontWeight,
        ),
      ),
    ),
  );
}

Widget normalText({
  required String text,
  FontWeight fontWeight = FontWeight.normal,
  Color color = Colors.black,
  TextAlign textAlign = TextAlign.start,
  int maxLines = 1,
  TextOverflow overflow = TextOverflow.ellipsis,
}) {
  return Builder(
    builder: (context) => MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Text(
        text,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        style: TextStyle(
          color: color,
          fontSize: 16.sp,
          fontWeight: fontWeight,
        ),
      ),
    ),
  );
}

Widget smallText({
  required String text,
  FontWeight fontWeight = FontWeight.w400,
  Color color = Colors.black,
  TextAlign textAlign = TextAlign.start,
  int maxLines = 1,
  TextOverflow overflow = TextOverflow.ellipsis,
}) {
  return Builder(
    builder: (context) => MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Text(
        text,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        style: TextStyle(
          color: color,
          fontSize: 14.sp,
          fontWeight: fontWeight,
        ),
      ),
    ),
  );
}

Widget headingValue(String heading, String value) {
  return Row(
    children: [
      smallText(text: heading, color: Colors.black),
      smallText(text: " : ${value}", color: Colors.grey)
    ],
  );
}
/*
sample usage.

headingText(text: "Heading"),
normalText(text: "Body text here"),
smallText(text: "Footnote or label"),

*/
