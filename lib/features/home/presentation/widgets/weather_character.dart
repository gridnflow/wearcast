import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/character/character_state.dart';

class WeatherCharacter extends StatelessWidget {
  final CharacterState state;
  final double size;

  const WeatherCharacter({
    super.key,
    required this.state,
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 450),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, anim) => FadeTransition(
        opacity: anim,
        child: ScaleTransition(scale: anim, child: child),
      ),
      child: SizedBox(
        key: ValueKey(state.stage),
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _CharacterBase(stage: state.stage, size: size),
            ...state.overlays.map((o) => _OverlayLayer(overlay: o, size: size)),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Base character: Lottie → PNG → emoji fallback
// ---------------------------------------------------------------------------

class _CharacterBase extends StatelessWidget {
  final int stage;
  final double size;

  const _CharacterBase({required this.stage, required this.size});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/character/base/stage_$stage.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
errorBuilder: (_, _, _) => _FallbackCharacter(stage: stage, size: size),
    );
  }
}

class _FallbackCharacter extends StatelessWidget {
  final int stage;
  final double size;

  const _FallbackCharacter({required this.stage, required this.size});

  static const _stages = [
    _StageData('🧥', '극한 추위', Color(0xFFCDE4F4), '≤ -5°C'),
    _StageData('🧥', '강추위', Color(0xFFD4ECF4), '-5~3°C'),
    _StageData('🧣', '쌀쌀', Color(0xFFDCF0EE), '3~8°C'),
    _StageData('🚶', '선선', Color(0xFFDDF0E4), '8~15°C'),
    _StageData('😊', '딱 좋음', Color(0xFFF0F0DC), '15~22°C'),
    _StageData('😎', '따뜻', Color(0xFFF8EAD4), '22~27°C'),
    _StageData('😅', '더움', Color(0xFFF8DEC4), '27~32°C'),
    _StageData('🥵', '폭염', Color(0xFFF8CCAC), '≥ 32°C'),
  ];

  @override
  Widget build(BuildContext context) {
    final d = _stages[(stage - 1).clamp(0, 7)];
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: d.bg, shape: BoxShape.circle),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(d.emoji, style: TextStyle(fontSize: size * 0.36)),
          const SizedBox(height: 4),
          Text(
            d.label,
            style: TextStyle(
              fontSize: size * 0.10,
              color: Colors.black54,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            d.range,
            style: TextStyle(fontSize: size * 0.085, color: Colors.black38),
          ),
        ],
      ),
    );
  }
}

class _StageData {
  final String emoji;
  final String label;
  final Color bg;
  final String range;
  const _StageData(this.emoji, this.label, this.bg, this.range);
}

// ---------------------------------------------------------------------------
// Overlay: Lottie → animated Flutter painter fallback
// ---------------------------------------------------------------------------

class _OverlayLayer extends StatelessWidget {
  final WeatherOverlay overlay;
  final double size;

  const _OverlayLayer({required this.overlay, required this.size});

  @override
  Widget build(BuildContext context) {
    return _OverlayEffect(overlay: overlay, size: size);
  }
}

// ---------------------------------------------------------------------------
// Animated painter overlays (fallback when Lottie file missing)
// ---------------------------------------------------------------------------

class _OverlayEffect extends StatefulWidget {
  final WeatherOverlay overlay;
  final double size;

  const _OverlayEffect({required this.overlay, required this.size});

  @override
  State<_OverlayEffect> createState() => _OverlayEffectState();
}

class _OverlayEffectState extends State<_OverlayEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: switch (widget.overlay) {
        WeatherOverlay.rain  => const Duration(milliseconds: 700),
        WeatherOverlay.snow  => const Duration(milliseconds: 2200),
        WeatherOverlay.wind  => const Duration(milliseconds: 1100),
        WeatherOverlay.sunny => const Duration(milliseconds: 2800),
        WeatherOverlay.dust  => const Duration(milliseconds: 3500),
      },
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, _) => CustomPaint(
        size: Size(widget.size, widget.size),
        painter: _painterFor(widget.overlay, _ctrl.value),
      ),
    );
  }

  CustomPainter _painterFor(WeatherOverlay o, double t) => switch (o) {
    WeatherOverlay.rain  => _RainPainter(t: t),
    WeatherOverlay.snow  => _SnowPainter(t: t),
    WeatherOverlay.wind  => _WindPainter(t: t),
    WeatherOverlay.sunny => _SunnyPainter(t: t),
    WeatherOverlay.dust  => _DustPainter(t: t),
  };
}

class _RainPainter extends CustomPainter {
  final double t;
  const _RainPainter({required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x997EC8F0)
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    final rng = Random(42);
    for (int i = 0; i < 14; i++) {
      final x = rng.nextDouble() * size.width;
      final y = ((rng.nextDouble() + t) % 1.0) * size.height;
      canvas.drawLine(
        Offset(x - size.width * 0.035, y),
        Offset(x, y + size.height * 0.07),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_RainPainter old) => old.t != t;
}

class _SnowPainter extends CustomPainter {
  final double t;
  const _SnowPainter({required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withAlpha(210);
    final rng = Random(77);
    for (int i = 0; i < 12; i++) {
      final x = (rng.nextDouble() * size.width +
          sin((t + i * 0.3) * 2 * pi) * size.width * 0.04)
          .clamp(0.0, size.width);
      final y = ((rng.nextDouble() + t * 0.6) % 1.0) * size.height;
      canvas.drawCircle(Offset(x, y), rng.nextDouble() * 3.0 + 1.5, paint);
    }
  }

  @override
  bool shouldRepaint(_SnowPainter old) => old.t != t;
}

class _WindPainter extends CustomPainter {
  final double t;
  const _WindPainter({required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withAlpha(130)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 5; i++) {
      final y = size.height * (0.15 + i * 0.18);
      final len = size.width * (0.18 + (i % 2) * 0.1);
      final x = ((t + i * 0.22) % 1.2 - 0.1) * size.width;
      canvas.drawLine(Offset(x, y), Offset(x + len, y), paint);
    }
  }

  @override
  bool shouldRepaint(_WindPainter old) => old.t != t;
}

class _SunnyPainter extends CustomPainter {
  final double t;
  const _SunnyPainter({required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width * 0.82;
    final cy = size.height * 0.14;
    final r = size.width * 0.09;

    canvas.drawCircle(
      Offset(cx, cy),
      r * (2.0 + 0.4 * sin(t * 2 * pi)),
      Paint()
        ..color = Colors.yellow.withAlpha(38)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    final rayPaint = Paint()
      ..color = Colors.yellow.withAlpha(180)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 8; i++) {
      final angle = (i * pi / 4) + t * pi * 0.4;
      canvas.drawLine(
        Offset(cx + cos(angle) * r * 1.3, cy + sin(angle) * r * 1.3),
        Offset(cx + cos(angle) * r * 1.9, cy + sin(angle) * r * 1.9),
        rayPaint,
      );
    }
    canvas.drawCircle(Offset(cx, cy), r, Paint()..color = const Color(0xFFFFC94A));
  }

  @override
  bool shouldRepaint(_SunnyPainter old) => old.t != t;
}

class _DustPainter extends CustomPainter {
  final double t;
  const _DustPainter({required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0x2AC8A060),
    );
    final pPaint = Paint()..color = const Color(0x50C8A060);
    final rng = Random(55);
    for (int i = 0; i < 18; i++) {
      final x = ((rng.nextDouble() + t * 0.4) % 1.0) * size.width;
      final y = rng.nextDouble() * size.height;
      canvas.drawCircle(Offset(x, y), rng.nextDouble() * 2.5 + 1, pPaint);
    }
  }

  @override
  bool shouldRepaint(_DustPainter old) => old.t != t;
}
