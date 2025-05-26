import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResponsiveSize {

  static double width(double width) {
    return width.w;
  }


  static double height(double height) {
    return height.h;
  }


  static double fontSize(double size) {
    return size.sp;
  }


  static double radius(double radius) {
    return radius.r;
  }


  static EdgeInsetsGeometry padding({
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? horizontal,
    double? vertical,
    double? all,
  }) {
    if (all != null) {
      return EdgeInsets.all(all.r);
    }

    if (horizontal != null && vertical != null) {
      return EdgeInsets.symmetric(
        horizontal: horizontal.w,
        vertical: vertical.h,
      );
    }

    return EdgeInsets.only(
      left: (left ?? 0).w,
      top: (top ?? 0).h,
      right: (right ?? 0).w,
      bottom: (bottom ?? 0).h,
    );
  }


  static EdgeInsetsGeometry margin({
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? horizontal,
    double? vertical,
    double? all,
  }) {
    return padding(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      horizontal: horizontal,
      vertical: vertical,
      all: all,
    );
  }
}
