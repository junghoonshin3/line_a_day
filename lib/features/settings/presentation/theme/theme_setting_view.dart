// lib/features/settings/presentation/theme/theme_settings_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_a_day/core/config/theme/theme.dart';
import 'package:line_a_day/di/providers.dart';
import 'package:line_a_day/features/settings/domain/model/theme_model.dart';

class ThemeSettingsView extends ConsumerWidget {
  const ThemeSettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeViewModelProvider);
    final viewModel = ref.read(themeViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('테마 설정'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // 다크모드 설정
          _buildCard(
            context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.brightness_6,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      '화면 모드',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildThemeModeOption(
                  context,
                  ThemeMode.light,
                  '라이트 모드',
                  Icons.light_mode,
                  themeState.settings.themeMode == ThemeMode.light,
                  () => viewModel.updateThemeMode(ThemeMode.light),
                ),
                const SizedBox(height: 12),
                _buildThemeModeOption(
                  context,
                  ThemeMode.dark,
                  '다크 모드',
                  Icons.dark_mode,
                  themeState.settings.themeMode == ThemeMode.dark,
                  () => viewModel.updateThemeMode(ThemeMode.dark),
                ),
                const SizedBox(height: 12),
                _buildThemeModeOption(
                  context,
                  ThemeMode.system,
                  '시스템 설정',
                  Icons.settings_suggest,
                  themeState.settings.themeMode == ThemeMode.system,
                  () => viewModel.updateThemeMode(ThemeMode.system),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 색상 테마 설정
          _buildCard(
            context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.palette,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      '테마 색상',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: AppColorTheme.values.length,
                  itemBuilder: (context, index) {
                    final colorTheme = AppColorTheme.values[index];
                    final isSelected =
                        themeState.settings.colorTheme == colorTheme;

                    return _buildColorThemeCard(
                      context,
                      colorTheme,
                      isSelected,
                      () => viewModel.updateColorTheme(colorTheme),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: child,
    );
  }

  Widget _buildThemeModeOption(
    BuildContext context,
    ThemeMode mode,
    String label,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isSelected ? AppTheme.primaryGradient : null,
          color: isSelected
              ? null
              : Theme.of(context).brightness == Brightness.dark
              ? AppTheme.darkGray700
              : AppTheme.gray100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : Theme.of(context).brightness == Brightness.dark
                ? AppTheme.darkGray600
                : AppTheme.gray300,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).brightness == Brightness.dark
                  ? AppTheme.darkGray400
                  : AppTheme.gray600,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : AppTheme.gray800,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildColorThemeCard(
    BuildContext context,
    AppColorTheme colorTheme,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: colorTheme.gradient,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 3,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colorTheme.primaryColor.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.white, size: 32)
            else
              const SizedBox(height: 32),
            const SizedBox(height: 8),
            Text(
              colorTheme.label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
