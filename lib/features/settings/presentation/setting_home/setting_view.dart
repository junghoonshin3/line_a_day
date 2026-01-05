import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:line_a_day/core/config/routes.dart';
import 'package:line_a_day/core/config/theme/theme.dart';
import 'package:line_a_day/features/settings/presentation/setting_home/setting_view_model.dart';
import 'package:line_a_day/features/settings/presentation/setting_home/state/setting_state.dart';
import 'package:line_a_day/shared/widgets/dialogs/dialog_helper.dart';
import 'package:line_a_day/shared/widgets/animtation/staggered_animation_mixin.dart';

class SettingView extends ConsumerStatefulWidget {
  const SettingView({super.key});

  @override
  ConsumerState<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends ConsumerState<SettingView>
    with TickerProviderStateMixin, StaggeredAnimationMixin {
  @override
  void initState() {
    super.initState();
    initStaggeredAnimation();
  }

  @override
  void dispose() {
    disposeStaggeredAnimation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(settingViewModelProvider);
    final viewModel = ref.read(settingViewModelProvider.notifier);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildHeader(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 통계 카드
                  buildAnimatedItem(
                    index: 0,
                    child: _buildStatisticsCard(state),
                  ),
                  const SizedBox(height: 20),

                  // 설정 섹션
                  buildAnimatedItem(
                    index: 1,
                    child: _buildSettingsSection(viewModel),
                  ),
                  const SizedBox(height: 20),

                  // 앱 정보 섹션
                  buildAnimatedItem(index: 2, child: _buildAppInfoSection()),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SliverAppBar(
      expandedHeight: 120,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(gradient: AppTheme.primaryGradient),
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              buildFadeItem(
                index: 0,
                child: const Text(
                  '내 정보',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsCard(SettingState state) {
    final averagePerDay = state.averagePerDay.toStringAsFixed(1); // 소수점 1자리
    final String recentTime = state.recentTime == null
        ? "없음"
        : DateFormat('a h시 mm분', 'ko_KR').format(state.recentTime!);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadow,
      ),
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
                  Icons.bar_chart,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text('나의 기록', style: AppTheme.titleLarge),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  '총 일기',
                  '${state.totalDiaries}편',
                  Icons.book,
                  Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatItem(
                  '작성 일수',
                  '${state.totalDays}일',
                  Icons.calendar_today,
                  Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  '일 평균',
                  '$averagePerDay편',
                  Icons.trending_up,
                  const Color(0xFF10B981),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatItem(
                  '최근 기록 시간',
                  recentTime,
                  Icons.timer,
                  const Color(0xFFF59E0B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color, {
    double? fontSize = 20,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTheme.labelMedium.copyWith(color: AppTheme.gray600),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(SettingViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          _buildSettingItem(
            icon: Icons.notifications_outlined,
            title: '알림 설정',
            subtitle: '일기 작성 알림',
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.notification);
            },
          ),
          _buildDivider(),
          _buildSettingItem(
            icon: Icons.lock_outlined,
            title: '보안',
            subtitle: '비밀번호 잠금',
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.security);
            },
          ),
          _buildDivider(),
          _buildSettingItem(
            icon: Icons.backup_outlined,
            title: '백업 및 복원',
            subtitle: '데이터 백업',
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.backup);
            },
          ),
          _buildDivider(),
          _buildSettingItem(
            icon: Icons.palette_outlined,
            title: '테마',
            subtitle: '다크모드, 색상 변경',
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.theme);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppInfoSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          _buildSettingItem(
            icon: Icons.info_outlined,
            title: '앱 정보',
            subtitle: '버전 1.0.0',
            onTap: () {
              _showAppInfoDialog();
            },
          ),
          _buildDivider(),
          _buildSettingItem(
            icon: Icons.article_outlined,
            title: '이용약관',
            onTap: () {
              // TODO: 이용약관 화면으로 이동
            },
          ),
          _buildDivider(),
          _buildSettingItem(
            icon: Icons.privacy_tip_outlined,
            title: '개인정보 처리방침',
            onTap: () {
              // TODO: 개인정보 처리방침 화면으로 이동
            },
          ),
          _buildDivider(),
          _buildSettingItem(
            icon: Icons.mail_outlined,
            title: '문의하기',
            subtitle: 'support@lineaday.com',
            onTap: () {
              // TODO: 문의하기 기능
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.gray100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppTheme.gray600, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTheme.titleMedium),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.gray400,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppTheme.gray400),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 1,
      color: AppTheme.gray200,
    );
  }

  void _showEditNameDialog(String currentName, viewModel) {
    final controller = TextEditingController(text: currentName);

    DialogHelper.showBottomSheetDialog(
      context,
      title: '이름 변경',
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: '이름을 입력하세요',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('취소'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      if (controller.text.trim().isNotEmpty) {
                        viewModel.updateUserName(controller.text.trim());
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('확인'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAppInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Line A Day'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('버전: 1.0.0'),
            const SizedBox(height: 8),
            const Text('개발자: Line A Day Team'),
            const SizedBox(height: 8),
            Text(
              '매일의 감정을 기록하고\n소중한 추억을 남기세요',
              style: AppTheme.bodyMedium.copyWith(color: AppTheme.gray600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}
