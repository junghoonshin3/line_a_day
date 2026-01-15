import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_a_day/core/config/theme/theme.dart';
import 'package:line_a_day/features/goal/domain/model/goal_model.dart';
import 'package:line_a_day/features/goal/presentation/view_model/goal_view_model.dart';
import 'package:line_a_day/features/goal/presentation/state/goal_state.dart';
import 'package:line_a_day/shared/widgets/indicators/loading_indicator.dart';
import 'package:line_a_day/shared/widgets/animtation/staggered_animation_mixin.dart';

class GoalView extends ConsumerStatefulWidget {
  const GoalView({super.key});

  @override
  ConsumerState<GoalView> createState() => _GoalViewState();
}

class _GoalViewState extends ConsumerState<GoalView>
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
    final state = ref.watch(goalViewModelProvider);
    final viewModel = ref.read(goalViewModelProvider.notifier);

    if (state.isLoading) {
      return const LoadingIndicator();
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildHeader(state),
          _buildStatsCards(state),
          _buildActiveGoals(state),
          _buildBadges(state),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  Widget _buildHeader(state) {
    return SliverAppBar(
      expandedHeight: 170,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(gradient: AppTheme.primaryGradient),
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildFadeItem(
                index: 0,
                child: const Text(
                  '나의 목표',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              buildFadeItem(
                index: 1,
                child: const Text(
                  '작은 습관이 큰 변화를 만듭니다',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCards(GoalState state) {
    return buildAnimatedSliverBox(
      index: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: _buildStatCard(
                '${state.totalDiaries}',
                '총 일기',
                '📚',
                Theme.of(context).brightness == Brightness.dark
                    ? AppTheme.gray100
                    : AppTheme.darkGray700,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                '${state.currentStreak}일',
                '연속 작성',
                '🔥',
                Theme.of(context).brightness == Brightness.dark
                    ? AppTheme.gray100
                    : AppTheme.darkGray700,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                '${state.positiveEmotionRate.toStringAsFixed(0)}%',
                '긍정 비율',
                '😊',
                Theme.of(context).brightness == Brightness.dark
                    ? AppTheme.gray100
                    : AppTheme.darkGray700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, String emoji, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppTheme.darkGray700
            : AppTheme.gray100,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppTheme.gray100
                  : AppTheme.darkGray700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveGoals(state) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildAnimatedItem(
              index: 3,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.flag,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    '진행 중인 목표',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ...state.activeGoals.asMap().entries.map((entry) {
              final index = entry.key;
              final goal = entry.value;
              return buildAnimatedItem(
                index: index + 4,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildGoalCard(goal),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalCard(GoalModel goal) {
    final progressPercent = (goal.progress * 100).toStringAsFixed(0);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppTheme.darkGray700
            : AppTheme.gray200,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Color(goal.colorCode).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    goal.emoji ?? '🎯',
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppTheme.gray100
                            : AppTheme.darkGray700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      goal.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppTheme.gray100
                            : AppTheme.darkGray700,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '$progressPercent%',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(goal.colorCode),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppTheme.gray100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: goal.progress,
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(goal.colorCode),
                              Color(goal.colorCode).withOpacity(0.7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${goal.currentValue}/${goal.targetValue}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppTheme.gray100
                      : AppTheme.darkGray700,
                ),
              ),
            ],
          ),
          if (goal.remainingDays > 0) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 14,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppTheme.gray100
                      : AppTheme.gray400,
                ),
                const SizedBox(width: 4),
                Text(
                  '${goal.remainingDays}일 남음',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppTheme.gray100
                        : AppTheme.darkGray700,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBadges(GoalState state) {
    return buildAnimatedSliverBox(
      index: 8,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.military_tech,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  '획득한 뱃지',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                Text(
                  '${state.unlockedBadges.length}/${Badge.allBadges.length}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.gray600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: Badge.allBadges.length,
              itemBuilder: (context, index) {
                final badge = Badge.allBadges[index];
                final isUnlocked = state.unlockedBadges.any(
                  (b) => b.id == badge.id,
                );
                return _buildBadgeCard(badge, isUnlocked);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeCard(Badge badge, bool isUnlocked) {
    return GestureDetector(
      onTap: () => _showBadgeDetail(badge, isUnlocked),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppTheme.darkGray700
              : AppTheme.gray100,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isUnlocked
                    ? Color(badge.colorCode).withOpacity(0.2)
                    : AppTheme.gray200,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  isUnlocked ? badge.emoji : '🔒',
                  style: TextStyle(
                    fontSize: 28,
                    color: isUnlocked ? null : AppTheme.gray400,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              badge.title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isUnlocked
                    ? Theme.of(context).brightness == Brightness.dark
                          ? AppTheme.gray100
                          : AppTheme.darkGray800
                    : AppTheme.gray400,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showBadgeDetail(Badge badge, bool isUnlocked) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: isUnlocked
                      ? Color(badge.colorCode).withOpacity(0.2)
                      : AppTheme.gray200,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    isUnlocked ? badge.emoji : '🔒',
                    style: const TextStyle(fontSize: 48),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                badge.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                badge.description,
                style: const TextStyle(fontSize: 14, color: AppTheme.gray600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              if (!isUnlocked)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppTheme.darkGray700
                        : AppTheme.gray100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.lock_outline,
                        size: 16,
                        color: AppTheme.gray600,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '아직 획득하지 못한 뱃지입니다',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppTheme.gray100
                              : AppTheme.darkGray700,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    '확인',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
