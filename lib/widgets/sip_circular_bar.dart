import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:dynamic_sip_flutter/constants.dart';
import 'package:dynamic_sip_flutter/widgets/widget_utils.dart';

///
/// SIP Circular Bar
/// - Shows the equity and fixed Value of the SIP based on [equityValue]
/// - [radius] is the inner Radius of the bar
/// - [strokeWidth] is the width of actual bar
class SIPCircularBar extends StatefulWidget {
  final double radius;
  final double strokeWidth;
  final int equityValue;
  final Color innerBackgroundColor;
  final Color equityColor;
  final Color fixedEquityColor;
  const SIPCircularBar({
    Key? key,
    this.radius = 80,
    this.strokeWidth = 30,
    this.equityValue = 50,
    this.innerBackgroundColor = Colors.white,
    this.equityColor = Colors.orange,
    this.fixedEquityColor = kAppBackgroudColor,
  }) : super(key: key);

  @override
  State<SIPCircularBar> createState() => _SIPCircularBarState();
}

class _SIPCircularBarState extends State<SIPCircularBar> with SingleTickerProviderStateMixin {
  late final AnimationController animController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    animation = Tween<double>(
      begin: 0,
      end: widget.equityValue.toDouble(),
    ).animate(animController);
    animController.forward();
  }

  @override
  void didUpdateWidget(covariant SIPCircularBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    animation = Tween<double>(
      begin: oldWidget.equityValue.toDouble(),
      end: widget.equityValue.toDouble(),
    ).animate(animController);

    animController.reset();
    animController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (widget.radius * 2),
      width: (widget.radius * 2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: widget.strokeWidth + 10,
          )
        ],
      ),
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, _) => CustomPaint(
          painter: _SIPCircularBarPainter(
            radius: widget.radius,
            strokeWidth: widget.strokeWidth,
            equityValue: animation.value,
            innerBackgroundColor: widget.innerBackgroundColor,
            equityColor: widget.equityColor,
            fixedEquityColor: widget.fixedEquityColor,
          ),
        ),
      ),
    );
  }
}

class _SIPCircularBarPainter extends CustomPainter {
  final double radius;
  final double strokeWidth;
  final double equityValue;
  final Color fixedEquityColor;

  late final Paint innerBackground;
  late final Paint equityPaint;
  late final Paint fixedEquityPaint;

  _SIPCircularBarPainter({
    required this.radius,
    required this.strokeWidth,
    required this.equityValue,
    required Color innerBackgroundColor,
    required Color equityColor,
    required this.fixedEquityColor,
  }) {
    innerBackground = Paint()..color = innerBackgroundColor;

    equityPaint = Paint()
      ..color = equityColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    fixedEquityPaint = Paint()
      ..shader = ui.Gradient.linear(
        const Offset(0, 0),
        Offset(0, radius),
        [
          Color.lerp(fixedEquityColor, Colors.black, 0.4)!,
          Color.lerp(fixedEquityColor, Colors.black, 0.15)!,
        ],
      );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(radius, radius);
    const double startAngle = -90; // Top Center

    final double equityArcLenght = ((equityValue) / 100) * 360;

    final outerCircleRadius = radius + strokeWidth;
    final outerCircleStrokeRadius = radius + (strokeWidth / 2);

    // Background Circle (Seen as Fixed Equity Progress)
    canvas.drawCircle(center, outerCircleRadius, fixedEquityPaint);

    // Equity Progress Arc
    canvas.drawArc(Rect.fromCircle(center: center, radius: outerCircleStrokeRadius),
        deg2rad(startAngle), deg2rad(equityArcLenght), false, equityPaint);

    // Inner Circle
    canvas.drawCircle(center, radius, innerBackground);

    // Text
    TextPainter tp = TextPainter(
      textDirection: ui.TextDirection.ltr,
      textAlign: ui.TextAlign.center,
    );

    final equityValueTextStyle = TextStyle(
      color: equityPaint.color,
      fontSize: remap(equityValue, 0, 100, 12, 24),
    );
    final fixedValueTextStyle = TextStyle(
      color: fixedEquityColor,
      fontSize: remap(100 - equityValue, 0, 100, 12, 24),
    );

    TextSpan equityTextSpan = TextSpan(
      text: "${equityValue.toStringAsFixed(0)}%\n",
      style: equityValueTextStyle,
      children: const [
        TextSpan(
          text: "Share Market",
          style: TextStyle(fontSize: 10, color: Colors.black),
        ),
      ],
    );

    TextSpan fixedTextSpan = TextSpan(
      text: "${(100 - equityValue).toStringAsFixed(0)}%\n",
      style: fixedValueTextStyle,
      children: const [
        TextSpan(
          text: "Fixed Income",
          style: TextStyle(fontSize: 10, color: Colors.black),
        ),
      ],
    );

    tp.text = equityTextSpan;
    tp.layout();
    tp.paint(canvas, Offset(radius, remap(equityValue, 0, 100, 15, radius)));

    tp.text = fixedTextSpan;
    tp.layout();
    tp.paint(canvas, Offset(15, remap(100 - equityValue, 0, 100, 15, radius)));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
