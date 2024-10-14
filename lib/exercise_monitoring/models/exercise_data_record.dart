import 'package:ema_v4/exercise_monitoring/utils/engine/engine_compute.dart';
import 'package:flutter/material.dart';

import '../../pigeon.dart';

class EMTreeNodeResultConditionResult {
  double value;
  bool passed;

  EMTreeNodeResultConditionResult({required this.value, required this.passed});

  Map<String, dynamic> toJson() => {'value': value, 'passed': passed};
  @override
  String toString() => "$value";
}

class EMTreeNodeResult extends EMTreeNode {
  List<EMTreeNodeResultConditionResult>? conditionResults;

  EMTreeNodeResult({required super.nodeIndex,required super.nodeType, required super.tree});

  factory EMTreeNodeResult.fromNode(EMTreeNode node) {
    EMTreeNodeResult t =
        EMTreeNodeResult(nodeIndex:node.nodeIndex,nodeType: node.nodeType, tree: node.tree);
    t.resultVal = node.resultVal;
    t.conditions = node.conditions;
    t.nextNode = node.nextNode;
    t.decisionMode = node.decisionMode;
    t.passNode = node.passNode;
    t.failNode = node.failNode;
    return t;
  }

  Map<String, dynamic> toJson() => {
        'typ': nodeType.name,
        'value': resultVal,
        'conditions': conditions,
        'nextNode': nextNode,
        'decisionMode': decisionMode?.name,
        'passNode': passNode,
        'failNode': failNode,
        'conditionResults': conditionResults?.map((e) => e.toJson()).toList()
      };
  @override
  String toString(){
    String conversion="";
    conversion+="$nodeIndex:$resultVal:${conditionResults?.map((e) => e.toString()).toList()}";
    return conversion;
  }
}

class ExerciseDataRecord {
  List<PlatformPose> recordedPoints;
  Size imageSize;
  String version = "2.0.0";

  DateTime startTime, endTime;
  List<List<EMTreeNodeResult>>? log;

  ExerciseDataRecord(
      {required this.recordedPoints,
      required this.imageSize,
      required this.startTime,
      required this.endTime,
      this.log});

  Map<String, dynamic> toJson() {
    List<List<List<String>>> onlyPoints = [];
    for (var element in recordedPoints) {
      List<List<String>> landmarkPoints = [];
      var sortedByKeyMap = Map.fromEntries(
          element.landmarks.entries.toList()..sort((e1, e2) => e1.key!.compareTo(e2.key!)));
      sortedByKeyMap.forEach((key, value) {
        landmarkPoints.add(value!.toStringList());
      });
      onlyPoints.add(landmarkPoints);
    }
    Map<String, dynamic> map = {
      "version": version,
      "frameWidth": imageSize.width,
      "frameHeight": imageSize.height,
      "startTime": startTime.toIso8601String(),
      "endTime": endTime.toIso8601String(),
      "recordedPoints": onlyPoints
    };
    if (log != null) {
      map["log"] =
          log!.map((e) => e.map((e1) => e1.toString()).toList().reversed.toList().join("/")).toList();
    }
    return map;
  }
}
