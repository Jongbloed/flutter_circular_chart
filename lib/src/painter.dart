import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/src/animated_circular_chart.dart';
import 'package:flutter_circular_chart/src/circular_chart.dart';
import 'package:flutter_circular_chart/src/stack.dart';

class AnimatedCircularChartPainter extends CustomPainter {
  AnimatedCircularChartPainter(this.animation, this.labelPainter)
      : super(repaint: animation);

  final Animation<CircularChart> animation;
  final TextPainter labelPainter;

  @override
  void paint(Canvas canvas, Size size) {
    _paintLabel(canvas, size, labelPainter);
    _paintChart(canvas, size, animation.value, labelPainter);
  }

  @override
  bool shouldRepaint(AnimatedCircularChartPainter old) => false;
}

class CircularChartPainter extends CustomPainter {
  CircularChartPainter(this.chart, this.labelPainter);

  final CircularChart chart;
  final TextPainter labelPainter;

  @override
  void paint(Canvas canvas, Size size) {
    _paintLabel(canvas, size, labelPainter);
    _paintChart(canvas, size, chart, labelPainter);
  }

  @override
  bool shouldRepaint(CircularChartPainter old) => false;
}

const double _kRadiansPerDegree = Math.pi / 180;

void _paintLabel(Canvas canvas, Size size, TextPainter labelPainter) {
  if (labelPainter != null) {
    labelPainter.paint(
      canvas,
      new Offset(
        size.width / 2 - labelPainter.width / 2,
        size.height / 2 - labelPainter.height / 2,
      ),
    );
  }
}

void _paintChart(Canvas canvas, Size size, CircularChart chart, TextPainter labelPainter) {
  final Paint segmentPaint = new Paint()
    ..style = chart.chartType == CircularChartType.Radial
        ? PaintingStyle.stroke
        : PaintingStyle.fill
    ..strokeCap = chart.edgeStyle == SegmentEdgeStyle.round
        ? StrokeCap.round
        : StrokeCap.butt;

  for (final CircularChartStack stack in chart.stacks) {
    for (final segment in stack.segments) {
      segmentPaint.color = segment.color;
      segmentPaint.strokeWidth = stack.width;

      canvas.drawArc(
        new Rect.fromCircle(
          center: new Offset(size.width / 2, size.height / 2),
          radius: stack.radius,
        ),
        stack.startAngle * _kRadiansPerDegree,
        segment.sweepAngle * _kRadiansPerDegree,
        chart.chartType == CircularChartType.Pie,
        segmentPaint,
      );
    }
  }
  if(labelPainter == null) return;
  var centerTextSpan = labelPainter.text;
  for(final CircularChartStack stack in chart.stacks) {
    for(final segment in stack.segments) {
      if(segment.label?.isEmpty ?? true) continue;
      labelPainter
        ..text = TextSpan(text: segment.label, style: TextStyle(color: segment.labelColor))
        ..layout();
      labelPainter.paint(
        canvas,
        _computeSegmentLabelOffset(
          size.width / 2, size.height / 2,
          segment.labelAngle,
          stack.radius,
          labelPainter.getFullHeightForCaret(TextPosition(offset: 0), Rect.zero),
        )
      );
    }
  }
  labelPainter.text = centerTextSpan;
}

Offset _computeSegmentLabelOffset(double x, double y, double labelAngle, double radius, double textHeight) {
  var offsetX = x + Math.sin(labelAngle * _kRadiansPerDegree) * radius / 3 * 2;
  var offsetY = y - Math.cos(labelAngle * _kRadiansPerDegree) * radius / 3 * 2 - textHeight;
  return Offset(offsetX, offsetY);
}
