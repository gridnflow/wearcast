import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/character/character_state.dart';
import '../../../../l10n/app_localizations.dart';

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
            _CharacterBase(
              stage: state.stage,
              overlays: state.overlays,
              size: size,
            ),
            ...state.overlays.map((o) => _OverlayLayer(overlay: o, size: size)),
            // Reactions attached to the figure itself.
            if (state.stage >= 7)
              _CharacterEffectLayer(effect: _CharacterEffect.sweat, size: size),
            if (state.overlays.contains(WeatherOverlay.rain))
              _CharacterEffectLayer(
                effect: _CharacterEffect.umbrella,
                size: size,
              ),
          ],
        ),
      ),
    );
  }
}

class _CharacterBase extends StatefulWidget {
  final int stage;
  final List<WeatherOverlay> overlays;
  final double size;

  const _CharacterBase({
    required this.stage,
    required this.overlays,
    required this.size,
  });

  @override
  State<_CharacterBase> createState() => _CharacterBaseState();
}

class _CharacterBaseState extends State<_CharacterBase>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    // Fast loop so the figure visibly trembles when the weather calls for it.
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 240),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  /// The figure trembles when it's windy or cold enough to shiver; otherwise it
  /// stands still (no idle bobbing).
  bool get _trembles =>
      widget.overlays.contains(WeatherOverlay.wind) || widget.stage <= 2;

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      'assets/character/base/stage_${widget.stage}.png',
      width: widget.size,
      height: widget.size,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) =>
          _FallbackCharacter(stage: widget.stage, size: widget.size),
    );

    if (!_trembles) return image;

    final s = widget.size;
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        // Small, quick side-to-side jitter with a slight tilt — a shiver.
        final phase = _ctrl.value * 2 * pi;
        final dx = sin(phase) * s * 0.010;
        final rot = sin(phase + pi / 2) * 0.012;
        return Transform.translate(
          offset: Offset(dx, 0),
          child: Transform.rotate(angle: rot, child: child),
        );
      },
      child: image,
    );
  }
}

class _FallbackCharacter extends StatelessWidget {
  final int stage;
  final double size;

  const _FallbackCharacter({required this.stage, required this.size});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final stages = [
      _StageData('🧥', l.stageExtremeCold, const Color(0xFFCDE4F4), '≤ -5°C'),
      _StageData('🧥', l.stageSevereCold,  const Color(0xFFD4ECF4), '-5~3°C'),
      _StageData('🧣', l.stageChilly,      const Color(0xFFDCF0EE), '3~8°C'),
      _StageData('🚶', l.stageCool,        const Color(0xFFDDF0E4), '8~15°C'),
      _StageData('😊', l.stagePerfect,     const Color(0xFFF0F0DC), '15~22°C'),
      _StageData('😎', l.stageWarm,        const Color(0xFFF8EAD4), '22~27°C'),
      _StageData('😅', l.stageHot,         const Color(0xFFF8DEC4), '27~32°C'),
      _StageData('🥵', l.stageExtremeHot,  const Color(0xFFF8CCAC), '≥ 32°C'),
    ];
    final d = stages[(stage - 1).clamp(0, 7)];
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

class _OverlayLayer extends StatelessWidget {
  final WeatherOverlay overlay;
  final double size;

  const _OverlayLayer({required this.overlay, required this.size});

  @override
  Widget build(BuildContext context) {
    return _OverlayEffect(overlay: overlay, size: size);
  }
}

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

/// Reactions drawn on top of the figure itself (as opposed to the ambient
/// [_OverlayEffect] weather particles): sweat when hot, an umbrella when it
/// rains.
enum _CharacterEffect { sweat, umbrella }

class _CharacterEffectLayer extends StatefulWidget {
  final _CharacterEffect effect;
  final double size;

  const _CharacterEffectLayer({required this.effect, required this.size});

  @override
  State<_CharacterEffectLayer> createState() => _CharacterEffectLayerState();
}

class _CharacterEffectLayerState extends State<_CharacterEffectLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: switch (widget.effect) {
        _CharacterEffect.sweat => const Duration(milliseconds: 1500),
        _CharacterEffect.umbrella => const Duration(milliseconds: 3200),
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
        painter: switch (widget.effect) {
          _CharacterEffect.sweat => _SweatPainter(t: _ctrl.value),
          _CharacterEffect.umbrella => _UmbrellaPainter(t: _ctrl.value),
        },
      ),
    );
  }
}

class _SweatPainter extends CustomPainter {
  final double t;
  const _SweatPainter({required this.t});

  // Beads near the temples/brow that roll down and fade, offset in phase.
  static const _origins = [
    Offset(0.63, 0.22),
    Offset(0.40, 0.25),
    Offset(0.66, 0.31),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < _origins.length; i++) {
      final local = (t + i / _origins.length) % 1.0;
      final o = _origins[i];
      final x = o.dx * size.width;
      final y = (o.dy + local * 0.16) * size.height;
      final alpha = (((1 - local) * 220).clamp(0, 220)).toInt();
      final r = size.width * 0.018;
      canvas.drawPath(
        _teardrop(Offset(x, y), r),
        Paint()..color = const Color(0xFF7EC8F0).withAlpha(alpha),
      );
      canvas.drawCircle(
        Offset(x - r * 0.3, y - r * 0.2),
        r * 0.28,
        Paint()..color = Colors.white.withAlpha((alpha * 0.7).toInt()),
      );
    }
  }

  Path _teardrop(Offset c, double r) {
    return Path()
      ..moveTo(c.dx, c.dy - r * 1.8)
      ..cubicTo(c.dx + r * 1.2, c.dy - r * 0.4, c.dx + r, c.dy + r, c.dx, c.dy + r)
      ..cubicTo(
        c.dx - r,
        c.dy + r,
        c.dx - r * 1.2,
        c.dy - r * 0.4,
        c.dx,
        c.dy - r * 1.8,
      )
      ..close();
  }

  @override
  bool shouldRepaint(_SweatPainter old) => old.t != t;
}

class _UmbrellaPainter extends CustomPainter {
  final double t;
  const _UmbrellaPainter({required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width * 0.5;
    final baseY = size.height * 0.17; // canopy rim height
    final rx = size.width * 0.27;
    final ry = size.height * 0.13;

    // Gentle sway around the canopy top.
    final pivot = Offset(cx, baseY - ry);
    canvas.save();
    canvas.translate(pivot.dx, pivot.dy);
    canvas.rotate(sin(t * 2 * pi) * 0.05);
    canvas.translate(-pivot.dx, -pivot.dy);

    // Pole down toward the hand.
    canvas.drawLine(
      Offset(cx, baseY),
      Offset(cx, size.height * 0.52),
      Paint()
        ..color = const Color(0xFF8A5A2B)
        ..strokeWidth = size.width * 0.018
        ..strokeCap = StrokeCap.round,
    );

    // Canopy: upper half of an ellipse closed by a scalloped rim.
    const scallops = 4;
    final canopy = Path()
      ..addArc(
        Rect.fromCenter(
          center: Offset(cx, baseY),
          width: rx * 2,
          height: ry * 2,
        ),
        pi,
        pi,
      );
    for (var i = scallops; i > 0; i--) {
      final x1 = cx - rx + (2 * rx) * (i - 1) / scallops;
      final mid = cx - rx + (2 * rx) * (i - 0.5) / scallops;
      canopy.quadraticBezierTo(mid, baseY + ry * 0.35, x1, baseY);
    }
    canopy.close();
    canvas.drawPath(canopy, Paint()..color = const Color(0xFFEF5D5D));

    // Ribs + top nub.
    final rib = Paint()
      ..color = const Color(0x33000000)
      ..strokeWidth = 1;
    for (var i = 1; i < scallops; i++) {
      final x = cx - rx + (2 * rx) * i / scallops;
      canvas.drawLine(Offset(x, baseY), Offset(cx, baseY - ry), rib);
    }
    canvas.drawCircle(
      Offset(cx, baseY - ry),
      size.width * 0.012,
      Paint()..color = const Color(0xFF7A2E2E),
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(_UmbrellaPainter old) => old.t != t;
}
