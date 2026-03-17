import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/injection_container.dart';
import '../../core/services/preferences_service.dart';
import '../../l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const List<IconData> _icons = [
    Icons.fitness_center,
    Icons.favorite,
    Icons.sync,
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    final prefsService = sl<PreferencesService>();
    await prefsService.setOnboardingComplete(true);

    if (mounted) {
      context.go('/');
    }
  }

  List<String> _getTitles(AppLocalizations l10n) => [
    l10n.onboardingTitle1,
    l10n.onboardingTitle2,
    l10n.onboardingTitle3,
  ];

  List<String> _getDescriptions(AppLocalizations l10n) => [
    l10n.onboardingDesc1,
    l10n.onboardingDesc2,
    l10n.onboardingDesc3,
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final titles = _getTitles(l10n);
    final descriptions = _getDescriptions(l10n);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _skipOnboarding,
                    child: Text(
                      l10n.skip,
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return _buildPage(
                    icon: _icons[index],
                    title: titles[index],
                    description: descriptions[index],
                    colorScheme: colorScheme,
                  );
                },
              ),
            ),
            _buildIndicators(colorScheme),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [colorScheme.primary, colorScheme.secondary],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _nextPage,
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          _currentPage == 2 ? l10n.getStarted : l10n.next,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPage({
    required IconData icon,
    required String title,
    required String description,
    required ColorScheme colorScheme,
  }) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary.withValues(alpha: 0.2),
                  colorScheme.primary.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.4),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.2),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(icon, size: 70, color: colorScheme.primary),
          ),
          const SizedBox(height: 48),
          Text(
            title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildIndicators(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final isActive = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
