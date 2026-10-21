import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/market_trend.dart';
import '../services/localization_service.dart';

class AnimatedPriceChart extends StatefulWidget {
  final List<HistoricalPricePoint> data;

  const AnimatedPriceChart({super.key, required this.data});

  @override
  State<AnimatedPriceChart> createState() => _AnimatedPriceChartState();
}

class _AnimatedPriceChartState extends State<AnimatedPriceChart> {
  int _selectedIndex = 7; // Default August

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) return const SizedBox();
    final loc = LocalizationService();

    final maxVal = widget.data
        .map((e) => max(e.currentYearPrice, e.lastYearPrice))
        .reduce(max)
        .toDouble();

    final selectedItem = widget.data[_selectedIndex];
    final diff = selectedItem.currentYearPrice - selectedItem.lastYearPrice;
    final pct = ((diff / selectedItem.lastYearPrice) * 100).toStringAsFixed(1);
    final monthLabel = loc.currentLanguage == 'mr' || loc.currentLanguage == 'hi'
        ? selectedItem.monthLocal
        : selectedItem.month;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header & Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.translate("last_year_vs_this_year"),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      "₹/${loc.translate('per_quintal')} Monthly Trend",
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Text(
                  "+$pct%",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Interactive Selected Month Details Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: AppColors.onionPurple,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "$monthLabel 2026: ₹${selectedItem.currentYearPrice}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onionPurple,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: AppColors.goldAmber,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "2025: ₹${selectedItem.lastYearPrice}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Bar Chart
          SizedBox(
            height: 170,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final barWidth = (constraints.maxWidth / widget.data.length) - 8;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(widget.data.length, (index) {
                    final item = widget.data[index];
                    final isSelected = index == _selectedIndex;

                    final currentHeight = (item.currentYearPrice / maxVal) * 120;
                    final lastYearHeight = (item.lastYearPrice / maxVal) * 120;
                    final curMonth = loc.currentLanguage == 'mr' || loc.currentLanguage == 'hi'
                        ? item.monthLocal
                        : item.month;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Last year bar
                              TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0, end: lastYearHeight),
                                duration: Duration(milliseconds: 600 + index * 50),
                                curve: Curves.easeOutCubic,
                                builder: (context, val, _) {
                                  return Container(
                                    width: barWidth * 0.42,
                                    height: val,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.goldAmber
                                          : AppColors.goldAmber.withValues(alpha: 0.5),
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(4),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 2),
                              // Current year bar
                              TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0, end: currentHeight),
                                duration: Duration(milliseconds: 700 + index * 50),
                                curve: Curves.easeOutCubic,
                                builder: (context, val, _) {
                                  return Container(
                                    width: barWidth * 0.48,
                                    height: val,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.onionPurple
                                          : AppColors.onionPurple.withValues(alpha: 0.6),
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(4),
                                      ),
                                      border: isSelected
                                          ? Border.all(color: Colors.white, width: 1.5)
                                          : null,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            curMonth,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected ? AppColors.onionPurple : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(AppColors.onionPurple, loc.translate("this_year_2026")),
              const SizedBox(width: 16),
              _buildLegendItem(AppColors.goldAmber, loc.translate("last_year_2025")),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
