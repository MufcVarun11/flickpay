import 'dart:async';

import 'package:flutter/material.dart';

import 'widgets/backdrop.dart';
import 'widgets/confetti_painter.dart';
import 'widgets/money_actions.dart';
import 'widgets/reward_hero.dart';
import 'widgets/top_bar.dart';

class RewardRevealScreen extends StatefulWidget {
  const RewardRevealScreen({super.key});

  @override
  State<RewardRevealScreen> createState() => _RewardRevealScreenState();
}

class _RewardRevealScreenState extends State<RewardRevealScreen>
    with SingleTickerProviderStateMixin {
  final List<Timer> _timers = [];
  late final AnimationController _confettiController;
  bool _heroVisible = false;
  bool _headerSettled = false;
  int _visibleActionCount = 0;

  @override
  void initState() {
    super.initState();
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _stage(const Duration(milliseconds: 120), () => _heroVisible = true);
    _stage(const Duration(milliseconds: 760), () => _headerSettled = true);
    _stage(const Duration(milliseconds: 1120), () => _visibleActionCount = 1);
    _stage(const Duration(milliseconds: 1280), () => _visibleActionCount = 2);
    _stage(const Duration(milliseconds: 1440), () => _visibleActionCount = 3);
    _stage(const Duration(milliseconds: 1600), () => _visibleActionCount = 4);
    _stage(const Duration(milliseconds: 1760), () => _visibleActionCount = 5);
    _stage(const Duration(milliseconds: 2020), () => _visibleActionCount = 6);
  }

  void _stage(Duration delay, VoidCallback update) {
    _timers.add(
      Timer(delay, () {
        if (!mounted) return;
        setState(update);
      }),
    );
  }

  @override
  void dispose() {
    for (final timer in _timers) {
      timer.cancel();
    }
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF15161D),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Backdrop(),
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _confettiController,
              builder: (context, _) {
                return CustomPaint(
                  painter: ConfettiPainter(progress: _confettiController.value),
                  child: const SizedBox.expand(),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 22),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final centeredGap = constraints.maxHeight * .26;
                  final settledGap = constraints.maxHeight * .06;
                  final headerTravel = centeredGap - settledGap;
                  final headerTop = settledGap + 42;
                  final listTop = headerTop + 190;

                  return Stack(
                    children: [
                      const TopBar(),
                      Positioned.fill(
                        top: listTop,
                        child: LayoutBuilder(
                          builder: (context, listConstraints) {
                            return Align(
                              alignment: Alignment.topCenter,
                              child: FittedBox(
                                alignment: Alignment.topCenter,
                                fit: BoxFit.scaleDown,
                                child: SizedBox(
                                  width: listConstraints.maxWidth,
                                  child: RepaintBoundary(
                                    child: MoneyActions(
                                      visibleCount: _visibleActionCount,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        top: headerTop,
                        child: RepaintBoundary(
                          child: AnimatedSlide(
                            offset: Offset(
                              0,
                              _headerSettled ? 0 : headerTravel / 220,
                            ),
                            duration: const Duration(milliseconds: 560),
                            curve: Curves.easeOutCubic,
                            child: RewardHero(
                              walletScale: _heroVisible ? 1 : 0,
                              textOpacity: _heroVisible ? 1 : 0,
                              drift: 0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
