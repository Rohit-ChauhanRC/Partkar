import 'package:flutter/material.dart';

class Helper {
  //ignore: non_constant_identifier_names
  static bool DEVICE_DETAILS_UPDATED = false;
  //ignore: non_constant_identifier_names
  static bool COLOURS_UPDATED = false;
  //ignore: non_constant_identifier_names
  static Function RELOAD_HOME_TAB;
  //ignore: non_constant_identifier_names
  static Function() HANDLE_NOTIFICATION;
  //ignore: non_constant_identifier_names
  static Map<String, dynamic> NOTIFICATION_INFO;
  //ignore: non_constant_identifier_names
  static bool showTabbar = false;
  //ignore: non_constant_identifier_names
  static TabController TAB_CONTROLLER;
  //ignore: non_constant_identifier_names
  static bool VERSION_CHECKED = false;

  // //ignore: non_constant_identifier_names
  // static Widget NAVIGATION_BAR;

  //ignore: non_constant_identifier_names
  static List<int> BACK_TRACK = [];

  //ignore: non_constant_identifier_names
  static bool HOME_BACK_CLICKED = false;

  //ignore: non_constant_identifier_names
  //static bool CHANGE_INDEX = false;

  //ignore: non_constant_identifier_names
  static void HANDLE_BACK(BuildContext context) async {
    //CHANGE_INDEX = false;
    // print('End drawer');
    // print(Scaffold.of(context).isEndDrawerOpen);
    if (Scaffold.of(context).isEndDrawerOpen) {
      Navigator.pop(context);
      return;
    }
    // print('HANDLE BACK');
    // print(BACK_TRACK);
    if (BACK_TRACK.length > 0) {
      int moveTo = BACK_TRACK.last;
      // print('move to $moveTo');
      // print(TAB_CONTROLLER);
      //TAB_CONTROLLER.animateTo(moveTo);
      await Future.delayed(Duration(microseconds: 1000), () {
        Helper.TAB_CONTROLLER.animateTo(moveTo);
      });
      BACK_TRACK.removeLast();
    }
    // print('after');
    // print(BACK_TRACK);
  }
}
