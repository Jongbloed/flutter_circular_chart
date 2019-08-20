import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/src/tween.dart';

class CircularChartSegment extends MergeTweenable<CircularChartSegment> {
  CircularChartSegment(this.rank, this.sweepAngle, this.color, this.labelAngle, this.label, this.labelColor);

  final String label;
  final int rank;
  final double sweepAngle;
  final double labelAngle;
  final Color color;
  final Color labelColor;

  @override
  CircularChartSegment get empty => new CircularChartSegment(rank, 0.0, color, 0.0, label, labelColor);

  @override
  bool operator <(CircularChartSegment other) => rank < other.rank;

  @override
  Tween<CircularChartSegment> tweenTo(CircularChartSegment other) =>
      new CircularChartSegmentTween(this, other);

  static CircularChartSegment lerp(
      CircularChartSegment begin, CircularChartSegment end, double t) {
    assert(begin.rank == end.rank);

    return new CircularChartSegment(
      begin.rank,
      lerpDouble(begin.sweepAngle, end.sweepAngle, t),
      Color.lerp(begin.color, end.color, t),
      lerpDouble(begin.labelAngle, end.labelAngle, t),
      begin.label,
      Color.lerp(begin.labelColor, end.labelColor, t),
    );
  }
}

class CircularChartSegmentTween extends Tween<CircularChartSegment> {
  CircularChartSegmentTween(
      CircularChartSegment begin, CircularChartSegment end)
      : super(begin: begin, end: end) {
    assert(begin.rank == end.rank);
  }

  @override
  CircularChartSegment lerp(double t) =>
      CircularChartSegment.lerp(begin, end, t);
}
