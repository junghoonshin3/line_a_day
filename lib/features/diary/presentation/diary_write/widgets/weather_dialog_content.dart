import 'package:flutter/material.dart';
import 'package:line_a_day/shared/constants/weather_constants.dart';

class WeatherDialogContent extends StatelessWidget {
  final WeatherData? current;
  final ValueChanged<WeatherData> onSelect;

  const WeatherDialogContent({super.key, this.current, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final weathers = WeatherData.weathers;

    return GridView.builder(
      shrinkWrap: true,
      itemCount: weathers.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (_, index) {
        final weather = weathers[index];
        final isSelected = current?.name == weather.name;

        return GestureDetector(
          onTap: () {
            onSelect(weather);
            Navigator.pop(context);
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : const Color(0xFFE5E7EB),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(weather.icon, style: const TextStyle(fontSize: 32)),
                const SizedBox(height: 4),
                Text(
                  weather.name,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : const Color(0xFF6B7280),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
