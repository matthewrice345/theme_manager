import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:theme_manager/enums.dart';

class ThemeState extends Equatable {
  final ThemeData themeData;
  final BrightnessPreference brightnessPreference;

  const ThemeState(this.themeData, this.brightnessPreference);

  @override
  List<Object?> get props => [
    themeData,
    brightnessPreference,
  ];

  @override
  String toString() {
    return 'ThemeState { themeData: $themeData, brightnessPreference: $brightnessPreference }';
  }
}
