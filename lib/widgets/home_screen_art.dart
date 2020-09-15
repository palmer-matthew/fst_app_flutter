import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fst_app_flutter/models/svg_model.dart';

class HomeArt extends CustomPainter {
  List<Point<double>> wave1 = [
    MovePoint(15.601, 53.64),
    CurvePoints(0.0, 0.0, 28.6, -71.5, 126.1, -49.4),
    CurvePoints(97.5, 22.1, 210.6, 114.4, 248.3, 85.8),
    CurvePoints(37.7, -28.6, 96.2, -14.3, 96.2, -14.3),
    VerticalPoint(68.9, 0.0),
    HorizontalPoint(-461.5, 0.0)
  ];
  List<Point<double>> wave2 = [
    MovePoint(250.901000, 78.340000),
    CurvePoints(61.1, -33.8, 202.8, -78.0, 227.5, -62.4),
    CurvePoints(24.7, 15.6, 7.8, 174.2, 7.8, 174.2),
    LinePoint(-235.3, -27.3),
  ];
  List<Point<double>> wave3 = [
    MovePoint(7.801000, 122.540000),
    CurvePoints(0.0, 0.0, 187.2, -123.5, 245.7, -84.5),
    CurvePoints(58.5, 39.0, 131.431, 31.542, 131.431, 31.542),
    LinePoint(101.27, -19.498),
    VerticalPoint(136.5, 0.0),
    HorizontalPoint(-478.401, 0.0)
  ];

  List<Point<double>> viewBox = [
    MovePoint(0.0, 0.0),
    HorizontalPoint(491.842, 0.0),
    VerticalPoint(-190.139, 0.0),
    HorizontalPoint(-491.842, 0.0),
    //VerticalPoint(190.139, -491.842),
  ];

  final Color colorOne;
  final Color colorTwo;
  final Color colorThree;

  HomeArt(this.colorOne, this.colorTwo, this.colorThree);

  @override
  void paint(Canvas canvas, Size size) {
    Paint wavePaint1 = Paint()
      ..color = colorOne
      ..style = PaintingStyle.fill;
    Paint wavePaint2 = Paint()
      ..color = colorTwo
      ..style = PaintingStyle.fill;
    Paint wavePaint3 = Paint()
      ..color = colorThree
      ..style = PaintingStyle.fill;
/* 
    drawPathFromPoints(canvas, Paint()..color = Colors.black, viewBox,
        MovePoint(0.0, 0.0), 0.5); */

    drawPathFromPoints(canvas, wavePaint1, wave1, MovePoint(0.0, -68.9), 1.0,true);
    drawPathFromPoints(
        canvas, wavePaint2, wave2, MovePoint(250.901000, -78.340000), 1.0,true);
    drawPathFromPoints(
        canvas, wavePaint3, wave3, MovePoint(7.801000, -31.0), 1.0,true);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
