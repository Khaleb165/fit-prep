import 'package:flutter/material.dart'
    show
        BuildContext,
        CrossAxisAlignment,
        MainAxisAlignment,
        MainAxisSize,
        MediaQuery,
        MediaQueryData,
        Orientation;

//Must be called on Initialization
class ScreenSize {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double defaultSize;
  static late Orientation orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
  }
}

// Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = ScreenSize.screenHeight;
  // 800 is the layout height the designer used

  // shortestSide helps determine the type of device
  // if less than 600, then it is a phone
  if (ScreenSize._mediaQueryData.size.shortestSide < 600) {
    if (ScreenSize.orientation == Orientation.portrait) {
      return (inputHeight / 800.0) * screenHeight;
    } else {
      return (inputHeight / 360.0) * screenHeight;
    }
  }

  return (inputHeight / 800.0) * screenHeight;
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = ScreenSize.screenWidth;
  // 360 is the layout width that designer use

  // shortestSide helps determine the type of device
  // if less than 600, then it is a phone
  if (ScreenSize._mediaQueryData.size.shortestSide < 600) {
    if (ScreenSize.orientation == Orientation.portrait) {
      return (inputWidth / 360.0) * screenWidth;
    } else {
      return (inputWidth / 800.0) * screenWidth;
    }
  }

  return (inputWidth / 360.0) * screenWidth;
}

// Column and Row alignmnet usables
MainAxisAlignment mainStart = MainAxisAlignment.start;
MainAxisAlignment mainCenter = MainAxisAlignment.center;
MainAxisAlignment mainEnd = MainAxisAlignment.end;
MainAxisAlignment mainSpaceBetween = MainAxisAlignment.spaceBetween;
MainAxisAlignment mainSpaceEvenly = MainAxisAlignment.spaceEvenly;
MainAxisAlignment mainSpaceAround = MainAxisAlignment.spaceAround;

CrossAxisAlignment crossStart = CrossAxisAlignment.start;
CrossAxisAlignment crossCenter = CrossAxisAlignment.center;
CrossAxisAlignment crossEnd = CrossAxisAlignment.end;
CrossAxisAlignment crossStretch = CrossAxisAlignment.stretch;

MainAxisSize mainMax = MainAxisSize.max;
MainAxisSize mainMin = MainAxisSize.min;