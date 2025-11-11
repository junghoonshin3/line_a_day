import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:line_a_day/core/app/config/theme/theme.dart';
import 'package:line_a_day/core/services/auth_service.dart';
import 'package:line_a_day/di/providers.dart';
import 'package:line_a_day/features/settings/presentation/security/security_settings_view_model.dart';
import 'package:line_a_day/features/settings/presentation/security/state/security_settings_state.dart';
import 'package:line_a_day/widgets/settings/card_section.dart';

final securitySettingsViewModelProvider =
    StateNotifierProvider.autoDispose<
      SecuritySettingsViewModel,
      SecuritySettingsState
    >((ref) {
      final prefs = ref.watch(sharedPreferencesProvider);
      return SecuritySettingsViewModel(
        prefs: prefs,
        authService: AuthService(),
      );
    });

class SecuritySettingsView extends ConsumerWidget {
  const SecuritySettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(securitySettingsViewModelProvider);
    final viewModel = ref.read(securitySettingsViewModelProvider.notifier);

    ref.listen(securitySettingsViewModelProvider, (previous, next) {
      // 에러 발생
      if (next.errorMessage != null &&
          previous?.errorMessage != next.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            onVisible: () {
              viewModel.clearErrorMessage();
            },
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(next.errorMessage!)),
              ],
            ),
            backgroundColor: AppTheme.errorRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('보안'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Theme(
        data: ThemeData(
          highlightColor: Colors.white,
          splashColor: Colors.transparent,
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // 앱 잠금
            CardSection(
              child: Column(
                children: [
                  SwitchListTile(
                    value: state.isLockEnabled,
                    onChanged: (value) {
                      if (value) {
                        _showSetPasswordDialog(context, viewModel);
                      } else {
                        _showDisableLockDialog(context, viewModel);
                      }
                    },
                    title: const Text('앱 잠금', style: AppTheme.titleMedium),
                    subtitle: const Text(
                      '비밀번호로 일기를 보호합니다',
                      style: AppTheme.bodyMedium,
                    ),
                    activeThumbColor: AppTheme.primaryBlue,
                  ),

                  if (state.isLockEnabled) ...[
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.key, color: AppTheme.gray600),
                      title: const Text('비밀번호 변경'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () =>
                          _showChangePasswordDialog(context, viewModel),
                    ),
                  ],
                ],
              ),
            ),

            if (state.isLockEnabled && state.isBiometricAvailable) ...[
              const SizedBox(height: 20),
              CardSection(
                child: SwitchListTile(
                  value: state.isBiometricEnabled,
                  onChanged: (value) => viewModel.toggleBiometric(value),
                  title: const Text('생체 인증', style: AppTheme.titleMedium),
                  subtitle: const Text(
                    '지문 또는 얼굴 인식으로 잠금 해제',
                    style: AppTheme.bodyMedium,
                  ),
                  secondary: Icon(
                    Icons.fingerprint,
                    color: AppTheme.primaryBlue,
                  ),
                  activeThumbColor: AppTheme.primaryBlue,
                ),
              ),
            ],

            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppTheme.primaryBlue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '앱 잠금을 활성화하면 앱을 실행할 때마다 비밀번호 입력이 필요합니다.',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSetPasswordDialog(
    BuildContext context,
    SecuritySettingsViewModel viewModel,
  ) {
    final passwordController = TextEditingController();
    final confirmController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('비밀번호 설정'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PassWordTextField(
              currentController: passwordController,
              labelText: '비밀번호 입력',
            ),
            const SizedBox(height: 16),
            PassWordTextField(
              currentController: confirmController,
              labelText: '비밀번호 확인',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (passwordController.text.length < 4) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('비밀번호는 4자리 이상 입력해주세요')),
                );
                return;
              }

              if (passwordController.text != confirmController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('비밀번호가 일치하지 않습니다')),
                );
                return;
              }

              await viewModel.enableLock(passwordController.text);
              Navigator.pop(context);
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showDisableLockDialog(
    BuildContext context,
    SecuritySettingsViewModel viewModel,
  ) {
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('앱 잠금 해제'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('비밀번호를 입력하여 앱 잠금을 해제합니다.'),
            const SizedBox(height: 16),
            PassWordTextField(
              currentController: passwordController,
              labelText: '비밀번호',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              final isValid = await viewModel.verifyPassword(
                passwordController.text,
              );

              if (isValid) {
                await viewModel.disableLock();
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('비밀번호가 일치하지 않습니다')),
                );
              }
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(
    BuildContext context,
    SecuritySettingsViewModel viewModel,
  ) {
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('비밀번호 변경'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PassWordTextField(
              currentController: currentController,
              labelText: "현재 비밀번호",
            ),
            const SizedBox(height: 16),
            PassWordTextField(
              currentController: newController,
              labelText: "새 비밀번호",
            ),
            const SizedBox(height: 16),
            PassWordTextField(
              currentController: confirmController,
              labelText: "새 비밀번호 확인",
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              final isValid = await viewModel.verifyPassword(
                currentController.text,
              );

              if (!isValid) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('현재 비밀번호가 일치하지 않습니다')),
                );
                return;
              }

              if (newController.text.length < 4) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('비밀번호는 4자리 이상 입력해주세요')),
                );
                return;
              }

              if (newController.text != confirmController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('비밀번호가 일치하지 않습니다')),
                );
                return;
              }

              await viewModel.enableLock(newController.text);
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('비밀번호가 변경되었습니다')));
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}

class PassWordTextField extends StatelessWidget {
  const PassWordTextField({
    super.key,
    required this.currentController,
    this.labelText,
  });

  final TextEditingController currentController;
  final String? labelText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: currentController,
      obscureText: true,
      decoration: InputDecoration(labelText: labelText),
      keyboardType: TextInputType.number,
      inputFormatters: [
        LengthLimitingTextInputFormatter(4),
        FilteringTextInputFormatter.digitsOnly,
      ],
    );
  }
}
