import 'package:flutter/material.dart';
import 'package:calculator/features/emi_calculator/presentation/emi_calculator_screen.dart';
import 'package:calculator/features/gst_calculator/presentation/gst_calculator_screen.dart';
import 'package:calculator/features/bmi_calculator/presentation/bmi_calculator_screen.dart';
import 'package:calculator/features/age_calculator/presentation/age_calculator_screen.dart';
import 'package:calculator/features/interest_calculator/presentation/interest_calculator_screen.dart';
import 'package:calculator/features/discount_calculator/presentation/discount_calculator_screen.dart';
import 'package:calculator/features/unit_converter/presentation/unit_converter_screen.dart';
import 'package:calculator/features/date_diff_calculator/presentation/date_diff_calculator_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SmartCalc')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CategorySection(
              title: 'Core Calculators',
              items: [
                _ToolItem(
                  'BMI Calculator',
                  'Health',
                  Icons.monitor_weight,
                  const Color(0xFFEF4444),
                  '/bmi',
                ),
                _ToolItem(
                  'Age Calculator',
                  'Birthday',
                  Icons.cake,
                  const Color(0xFFF59E0B),
                  '/age',
                ),
              ],
            ),
            const SizedBox(height: 24),
            _CategorySection(
              title: 'Finance Tools',
              items: [
                _ToolItem(
                  'EMI Calculator',
                  'Loan EMI',
                  Icons.account_balance,
                  const Color(0xFF6366F1),
                  '/emi',
                ),
                _ToolItem(
                  'GST Calculator',
                  'Tax',
                  Icons.receipt_long,
                  const Color(0xFF10B981),
                  '/gst',
                ),
                _ToolItem(
                  'Interest',
                  'Simple/Compound',
                  Icons.trending_up,
                  const Color(0xFF8B5CF6),
                  '/interest',
                ),
                _ToolItem(
                  'Discount & Tip',
                  'Offers',
                  Icons.local_offer,
                  const Color(0xFFEC4899),
                  '/discount',
                ),
              ],
            ),
            const SizedBox(height: 24),
            _CategorySection(
              title: 'Converters',
              items: [
                _ToolItem(
                  'Unit Converter',
                  'Length, Weight...',
                  Icons.swap_horiz,
                  const Color(0xFF14B8A6),
                  '/unit',
                ),
              ],
            ),
            const SizedBox(height: 24),
            _CategorySection(
              title: 'Time & Date',
              items: [
                _ToolItem(
                  'Date Difference',
                  'Between dates',
                  Icons.date_range,
                  const Color(0xFF0EA5E9),
                  '/date',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  final String title;
  final List<_ToolItem> items;

  const _CategorySection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return _ToolCard(item: items[index]);
          },
        ),
      ],
    );
  }
}

class _ToolItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String route;

  const _ToolItem(this.title, this.subtitle, this.icon, this.color, this.route);

  Widget get screen {
    switch (route) {
      case '/bmi':
        return const BmiCalculatorScreen();
      case '/age':
        return const AgeCalculatorScreen();
      case '/emi':
        return const EmiCalculatorScreen();
      case '/gst':
        return const GstCalculatorScreen();
      case '/interest':
        return const InterestCalculatorScreen();
      case '/discount':
        return const DiscountCalculatorScreen();
      case '/unit':
        return const UnitConverterScreen();
      case '/date':
        return const DateDiffCalculatorScreen();
      default:
        return const SizedBox();
    }
  }
}

class _ToolCard extends StatelessWidget {
  final _ToolItem item;

  const _ToolCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _navigate(context),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [item.color, item.color.withValues(alpha: 0.7)],
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(item.icon, size: 28, color: Colors.white),
              const Spacer(),
              Text(
                item.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                item.subtitle,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigate(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => item.screen));
  }
}
