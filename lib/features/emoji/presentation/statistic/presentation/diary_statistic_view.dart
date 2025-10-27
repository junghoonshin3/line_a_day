import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:line_a_day/constant.dart';
import 'package:line_a_day/core/app/config/theme/theme.dart';
import 'package:line_a_day/features/emoji/presentation/statistic/presentation/diary_statistic_view_model.dart';
import 'package:line_a_day/features/emoji/presentation/statistic/state/diary_statistic_state.dart';
import 'package:line_a_day/widgets/common/staggered_animation/staggered_animation_mixin.dart';

class DiaryStatisticView extends ConsumerStatefulWidget {
  const DiaryStatisticView({super.key});

  @override
  ConsumerState<DiaryStatisticView> createState() => _EmojiStatisticViewState();
}

class _EmojiStatisticViewState extends ConsumerState<DiaryStatisticView>
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
    final state = ref.watch(emojiStatisticViewModelProvider);
    final viewModel = ref.read(emojiStatisticViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: AppTheme.gray50,
      body: CustomScrollView(
        slivers: [
          _buildHeader(state, viewModel),
          buildAnimatedSliverBox(
            index: 3,
            child: _buildPeriodSelector(state, viewModel),
          ),
          buildAnimatedSliverBox(
            index: 4,
            child: _buildChart(state, viewModel),
          ),
          buildAnimatedSliverBox(
            index: 5,
            child: _buildEmotionChart(state, viewModel),
          ),
          buildAnimatedSliverBox(
            index: 6,
            child: _buildTopEmotions(state, viewModel),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  Widget _buildHeader(DiaryStatisticState state, DiaryStatisticViewModel vm) {
    String periodText = '';
    switch (state.selectedPeriod) {
      case PeriodType.week:
        final monday = state.selectedDate.subtract(
          Duration(days: state.selectedDate.weekday - 1),
        );
        final sunday = monday.add(const Duration(days: 6));

        periodText =
            '${DateFormat('M/d(E)', 'ko').format(monday)} - ${DateFormat('M/d(E)', 'ko').format(sunday)}';
        break;

      case PeriodType.month:
        periodText = DateFormat('yyyy년 M월').format(state.selectedDate);
        break;

      case PeriodType.year:
        periodText = '${state.selectedDate.year}년';
        break;
    }

    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: buildFadeItem(
                      index: 0,
                      child: const Text(
                        '감정 통계',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              buildAnimatedItem(
                index: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: vm.goToPreviousPeriod,
                      icon: const Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    Text(
                      periodText,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: vm.goToNextPeriod,
                      icon: const Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodSelector(
    DiaryStatisticState state,
    DiaryStatisticViewModel viewModel,
  ) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: PeriodType.values.map((period) {
          return Expanded(
            child: GestureDetector(
              onTap: () => viewModel.changePeriod(period),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: state.selectedPeriod == period
                      ? AppTheme.primaryGradient
                      : null,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  period.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: state.selectedPeriod == period
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: state.selectedPeriod == period
                        ? Colors.white
                        : AppTheme.gray600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildChart(DiaryStatisticState state, DiaryStatisticViewModel vm) {
    if (state.chartData.isEmpty) {
      return _buildEmptyChart();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '일기작성 횟수',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 300,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _getMaxY(state.chartData),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final data = state.chartData[group.x.toInt()];
                      return BarTooltipItem(
                        '${data.count}회',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= state.chartData.length) {
                          return const SizedBox();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            state.chartData[value.toInt()].label,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.gray600,
                            ),
                          ),
                        );
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.gray600,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return const FlLine(
                      color: AppTheme.gray200,
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    left: BorderSide(color: AppTheme.gray300, width: 1),
                    bottom: BorderSide(color: AppTheme.gray300, width: 1),
                  ),
                ),
                barGroups: state.chartData.asMap().entries.map((entry) {
                  final index = entry.key;
                  final data = entry.value;
                  final emotion = Emotion.getMoodByType(data.emotion);

                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: data.count.toDouble(),
                        gradient: LinearGradient(
                          colors: [
                            Color(emotion?.colorCode ?? 0xFFE5E7EB),
                            Color(
                              emotion?.colorCode ?? 0xFFE5E7EB,
                            ).withOpacity(0.7),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        width: 20,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionChart(
    DiaryStatisticState state,
    DiaryStatisticViewModel vm,
  ) {
    if (state.emotionCounts.isEmpty) return _buildEmptyChart();

    final entries = state.emotionCounts.entries.toList();
    final maxCount = entries
        .map((e) => e.value)
        .reduce((a, b) => a > b ? a : b);

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '감정 그래프',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 300,
            child: BarChart(
              transformationConfig: FlTransformationConfig(
                scaleAxis: FlScaleAxis.horizontal,
                scaleEnabled: true,
                transformationController: TransformationController(
                  Matrix4.identity()
                    ..scale(1.5, 1.5)
                    ..translate(0.0, 0.0),
                ),
              ),
              BarChartData(
                alignment: BarChartAlignment.spaceEvenly,
                maxY: (maxCount + 1).toDouble(),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final emotion = entries[group.x.toInt()].key;
                      final count = entries[group.x.toInt()].value;
                      final mood = Emotion.getMoodByType(emotion);

                      return BarTooltipItem(
                        '${mood?.emoji ?? ''} ${mood?.label ?? ''}\n$count회',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= entries.length) {
                          return const SizedBox.shrink();
                        }
                        final emotion = entries[index].key;
                        final mood = Emotion.getMoodByType(emotion);
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Column(
                            children: [
                              Text(
                                mood?.emoji ?? '🙂',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                mood?.label ?? '',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.gray600,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      reservedSize: 50,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.gray600,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return const FlLine(
                      color: AppTheme.gray200,
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    left: BorderSide(color: AppTheme.gray300, width: 1),
                    bottom: BorderSide(color: AppTheme.gray300, width: 1),
                  ),
                ),
                barGroups: entries.asMap().entries.map((entry) {
                  final index = entry.key;
                  final emotion = entry.value.key;
                  final count = entry.value.value;
                  final mood = Emotion.getMoodByType(emotion);

                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: count.toDouble(),
                        width: 22,
                        gradient: LinearGradient(
                          colors: [
                            Color(mood?.colorCode ?? 0xFFE5E7EB),
                            Color(
                              mood?.colorCode ?? 0xFFE5E7EB,
                            ).withOpacity(0.7),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getMaxY(List<ChartDataPoint> data) {
    if (data.isEmpty) return 10;
    final maxCount = data.map((d) => d.count).reduce((a, b) => a > b ? a : b);
    return (maxCount + 2).toDouble();
  }

  Widget _buildEmptyChart() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(60),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          Text(
            '📊',
            style: TextStyle(
              fontSize: 64,
              color: AppTheme.gray300.withOpacity(0.3),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '해당 기간에 작성된 일기가 없습니다',
            textAlign: TextAlign.center,
            style: AppTheme.bodyLarge.copyWith(
              color: AppTheme.gray400,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionLegend() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '감정 범례',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: Emotion.emotions.map((emotion) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Color(emotion.colorCode).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Color(emotion.colorCode).withOpacity(0.4),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(emotion.emoji, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 6),
                    Text(
                      emotion.label,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTopEmotions(
    DiaryStatisticState state,
    DiaryStatisticViewModel viewModel,
  ) {
    final emotionStats = viewModel.getEmotionStats();

    if (emotionStats.isEmpty) {
      return const SizedBox.shrink();
    }

    final topThree = emotionStats.take(3).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TOP 3 감정',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          ...topThree.asMap().entries.map((entry) {
            final index = entry.key;
            final stat = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildTopEmotionCard(stat, index + 1),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTopEmotionCard(EmotionStatItem stat, int rank) {
    final emotion = Emotion.getMoodByType(stat.type);
    if (emotion == null) return const SizedBox.shrink();

    final rankColors = [
      const Color(0xFFFFD700), // 금
      const Color(0xFFC0C0C0), // 은
      const Color(0xFFCD7F32), // 동
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: rankColors[rank - 1].withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$rank',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: rankColors[rank - 1],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(emotion.emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  emotion.label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${stat.count}회',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${stat.percentage.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 8,
            decoration: BoxDecoration(
              color: AppTheme.gray100,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: stat.percentage / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(emotion.colorCode),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
