import 'dart:math';

import 'package:ema_v4/pigeon.dart';
import 'package:flutter/material.dart';

getPoint(PlatformPose pose, String spec) {

  // '(13)'
  // '(0):(28):(28}/10:30'
  // '(0.5,(13),(14))'
  // '(0.5,(13),(0.6,(23),(24)))'
  // '(0.5,(0.6,(23),(24)),(13))'
  // '(0.5,(0.6,(23),(24)),(0.7,(24),(25)))'

  if (pose.landmarks.isEmpty) return null;

  var stk = [];
  var term = '';
  for (var c in spec.characters) {
    if (c == '(') {
      stk.add(c);
    } else if (c == ',') {
      // indicates end of a number
      if (term.isNotEmpty) {
        stk.add(num.parse(term));
        term = '';
      }
    } else if (c == '}') {
      // returns (x + 0.1, y), 0.1 is arbitrary, does not matter
      if (term.isNotEmpty) {
        stk.add(num.parse(term));
        term = '';
      }
      var opArr = stk.sublist(stk.lastIndexOf('(') + 1);
      stk.removeRange(stk.lastIndexOf('('), stk.length);
      if (opArr.length == 1) {
        stk.add([pose.landmarks[opArr[0]]!.x + 0.1, pose.landmarks[opArr[0]]!.y]);
      } else if (opArr.length == 3) {
        num factor = opArr[0];
        var p1 = opArr[1] is List ? opArr[1] : [pose.landmarks[opArr[1]]!.x, pose.landmarks[opArr[1]]!.y];
        var p2 = opArr[2] is List ? opArr[2] : [pose.landmarks[opArr[2]]!.x, pose.landmarks[opArr[2]]!.y];
        stk.add([(p1[0] + p2[0]) * factor + 0.1, (p1[1] + p2[1]) * factor]);
      } else {
        throw 'malformed point spec';
      }
    } else if (c == ']') {
      // returns (x, y + 0.1), 0.1 is arbitrary, does not matter
      if (term.isNotEmpty) {
        stk.add(num.parse(term));
        term = '';
      }
      var opArr = stk.sublist(stk.lastIndexOf('(') + 1);
      stk.removeRange(stk.lastIndexOf('('), stk.length);
      if (opArr.length == 1) {
        stk.add([pose.landmarks[opArr[0]]!.x, pose.landmarks[opArr[0]]!.y + 0.1]);
      } else if (opArr.length == 3) {
        num factor = opArr[0];
        var p1 = opArr[1] is List ? opArr[1] : [pose.landmarks[opArr[1]]!.x, pose.landmarks[opArr[1]]!.y];
        var p2 = opArr[2] is List ? opArr[2] : [pose.landmarks[opArr[2]]!.x, pose.landmarks[opArr[2]]!.y];
        stk.add([(p1[0] + p2[0]) * factor, (p1[1] + p2[1]) * factor + 0.1]);
      } else {
        throw 'malformed point spec';
      }
    } else if (c == ')') {
      // returns calculated (x, y)
      if (term.isNotEmpty) {
        stk.add(num.parse(term));
        term = '';
      }
      var opArr = stk.sublist(stk.lastIndexOf('(') + 1);
      stk.removeRange(stk.lastIndexOf('('), stk.length);
      if (opArr.length == 1) {
        stk.add([pose.landmarks[opArr[0]]!.x, pose.landmarks[opArr[0]]!.y]);
      } else if (opArr.length == 3) {
        num factor = opArr[0];
        var p1 = opArr[1] is List ? opArr[1] : [pose.landmarks[opArr[1]]!.x, pose.landmarks[opArr[1]]!.y];
        var p2 = opArr[2] is List ? opArr[2] : [pose.landmarks[opArr[2]]!.x, pose.landmarks[opArr[2]]!.y];
        stk.add([(p1[0] + p2[0]) * factor, (p1[1] + p2[1]) * factor]);
      } else {
        throw 'malformed point spec';
      }
    } else {
      // normal number, add to the term to be compiled to a number when ',' , ')' , '}' or ']' comes
      term += c;
    }
  }

  return stk[0];

}

getAngleBetweenTwoLines(
    line1Start,
    line1End,
    line2Start,
    line2End
    ) {

  var dx0 = line1End[0] - line1Start[0];
  var dy0 = line1End[1] - line1Start[1];
  var dx1 = line2End[0] - line2Start[0];
  var dy1 = line2End[1] - line2Start[1];
  var angle = atan2(dx0 * dy1 - dx1 * dy0, dx0 * dx1 + dy0 * dy1);

  return angle.abs();
}

getInsideAngleBetweenTwoLinesInDegrees(
    line1Start,
    line1End,
    line2Start,
    line2End
    ) {
  return getAngleBetweenTwoLines(
      line1Start,
      line1End,
      line2Start,
      line2End
  ) * 180 / pi;
}

// no use of this
getDistanceBetweenPoints(
    nonNormalizedPoint1,
    nonNormalizedPoint2,
    ) {
  return sqrt(
      pow(nonNormalizedPoint2[1] - nonNormalizedPoint1[1], 2) +
          pow(nonNormalizedPoint2[0] - nonNormalizedPoint1[0], 2)
  );
}