import 'package:flutter/material.dart';

/// 날씨 데이터 클래스
class WeatherData {
  final String icon;
  final String name;
  final String value;
  final Color color;

  const WeatherData({
    required this.icon,
    required this.name,
    required this.value,
    required this.color,
  });

  /// 모든 날씨 목록
  static const List<WeatherData> weathers = [
    WeatherData(
      icon: '☀️',
      name: '맑음',
      value: 'sunny',
      color: Color(0xFFFDB813),
    ),
    WeatherData(
      icon: '⛅',
      name: '구름 조금',
      value: 'partly_cloudy',
      color: Color(0xFF93C5FD),
    ),
    WeatherData(
      icon: '☁️',
      name: '흐림',
      value: 'cloudy',
      color: Color(0xFF9CA3AF),
    ),
    WeatherData(
      icon: '🌧️',
      name: '비',
      value: 'rainy',
      color: Color(0xFF60A5FA),
    ),
    WeatherData(
      icon: '⛈️',
      name: '천둥번개',
      value: 'thunderstorm',
      color: Color(0xFF6366F1),
    ),
    WeatherData(
      icon: '❄️',
      name: '눈',
      value: 'snowy',
      color: Color(0xFFBFDBFE),
    ),
    WeatherData(
      icon: '🌫️',
      name: '안개',
      value: 'foggy',
      color: Color(0xFFD1D5DB),
    ),
    WeatherData(
      icon: '🌪️',
      name: '바람',
      value: 'windy',
      color: Color(0xFF94A3B8),
    ),
  ];

  /// value로 날씨 찾기
  static WeatherData? getWeatherByValue(String? value) {
    if (value == null) return null;
    try {
      return weathers.firstWhere((weather) => weather.value == value);
    } catch (e) {
      return null;
    }
  }

  /// name으로 날씨 찾기
  static WeatherData? getWeatherByName(String name) {
    try {
      return weathers.firstWhere((weather) => weather.name == name);
    } catch (e) {
      return null;
    }
  }
}
