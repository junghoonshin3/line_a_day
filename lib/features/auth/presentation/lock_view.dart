import 'dart:async';

import 'package:flutter/material.dart' hide LockState;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_a_day/core/app/config/theme/theme.dart';
import 'package:line_a_day/features/auth/presentation/lock_view_model.dart';
import 'package:line_a_day/features/auth/presentation/state/lock_state.dart';
import 'package:line_a_day/widgets/common/loading_indicator.dart';

class LockView extends ConsumerStatefulWidget {
  final bool showBiometric;

  const LockView({super.key, this.showBiometric = false});

  @override
  ConsumerState<LockView> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockView>
    with SingleTickerProviderStateMixin {
  final _passwordController = TextEditingController();
  final _focusNode = FocusNode();
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  Timer? _errorTimer;

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    // 생체 인증 자동 시도
    if (widget.showBiometric) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _tryBiometric();
      });
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _focusNode.dispose();
    _shakeController.dispose();
    _errorTimer?.cancel();
    super.dispose();
  }

  Future<void> _tryBiometric() async {
    final viewModel = ref.read(lockViewModelProvider.notifier);
    final success = await viewModel.verifyBiometric();

    if (success && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _verifyPassword() async {
    final password = _passwordController.text;
    if (password.isEmpty) return;

    final viewModel = ref.read(lockViewModelProvider.notifier);
    final success = await viewModel.verifyPassword(password);

    if (success && mounted) {
      Navigator.of(context).pop(true);
    } else {
      // 흔들림 애니메이션
      _shakeController.forward(from: 0);
      _passwordController.clear();
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(lockViewModelProvider);

    // 에러 메시지 자동 제거
    ref.listen(lockViewModelProvider, (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        _errorTimer?.cancel();
        _errorTimer = Timer(const Duration(seconds: 3), () {
          if (mounted) {
            ref.read(lockViewModelProvider.notifier).clearError();
          }
        });
      }
    });

    return PopScope(
      canPop: false, // 뒤로가기 버튼 비활성화
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          decoration: BoxDecoration(gradient: AppTheme.primaryGradient),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: AnimatedBuilder(
                  animation: _shakeAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(_shakeAnimation.value, 0),
                      child: child,
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 로고/아이콘
                      _buildLogo(),
                      const SizedBox(height: 32),

                      // 제목
                      const Text(
                        'Line A Day',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // 상태별 메시지
                      _buildStatusMessage(state),
                      const SizedBox(height: 48),

                      // 임시 잠금 상태
                      if (state.isTemporarilyLocked)
                        _buildLockedState(state)
                      else
                        _buildUnlockedState(state),

                      // 에러 메시지
                      if (state.errorMessage != null) ...[
                        const SizedBox(height: 24),
                        _buildErrorMessage(state.errorMessage!),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Icon(Icons.lock_outline, size: 50, color: Colors.white),
    );
  }

  Widget _buildStatusMessage(LockState state) {
    if (state.isTemporarilyLocked) {
      return Column(
        children: [
          const Text(
            '잠시 후 다시 시도해주세요',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Text(
            '남은 시간: ${_formatDuration(state.remainingLockTime!)}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white60,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    if (state.failedAttempts > 0) {
      return Text(
        '${5 - state.failedAttempts}회 남음',
        style: const TextStyle(fontSize: 14, color: Colors.white70),
      );
    }

    return const Text(
      '비밀번호를 입력하세요',
      style: TextStyle(fontSize: 16, color: Colors.white70),
    );
  }

  Widget _buildUnlockedState(LockState state) {
    return Column(
      children: [
        // 비밀번호 입력
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: TextField(
            controller: _passwordController,
            focusNode: _focusNode,
            obscureText: true,
            autofocus: !widget.showBiometric,
            enabled: !state.isAuthenticating,
            decoration: const InputDecoration(
              hintText: '비밀번호',
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onSubmitted: (_) => _verifyPassword(),
          ),
        ),
        const SizedBox(height: 24),

        // 확인 버튼
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: state.isAuthenticating ? null : _verifyPassword,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.primaryBlue,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: state.isAuthenticating
                ? const LoadingIndicator(size: 20)
                : const Text(
                    '확인',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
          ),
        ),

        // 생체 인증 버튼
        if (widget.showBiometric) ...[
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: state.isAuthenticating ? null : _tryBiometric,
            icon: const Icon(Icons.fingerprint, color: Colors.white),
            label: const Text(
              '생체 인증 사용',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],

        // 실패 횟수 표시
        if (state.failedAttempts > 0) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  '${state.failedAttempts}번 실패',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLockedState(LockState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.lock_clock, size: 64, color: Colors.white),
          const SizedBox(height: 16),
          const Text(
            '너무 많이 시도했습니다',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${_formatDuration(state.remainingLockTime!)} 후\n다시 시도할 수 있습니다',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(message, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes분 $seconds초';
  }
}
