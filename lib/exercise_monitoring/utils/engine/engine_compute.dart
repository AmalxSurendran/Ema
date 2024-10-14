import 'package:ema_v4/pigeon.dart';
import 'package:flutter/foundation.dart';

import '../../models/exercise_data_record.dart';
import 'geometry_utils.dart';

enum EMTreeNodeType { input, decision, result }

extension EMTreeNodeTypeEx on EMTreeNodeType {
  static EMTreeNodeType fromValue(String value) {
    switch (value) {
      case "input":
        return EMTreeNodeType.input;
      case "decision":
        return EMTreeNodeType.decision;
      case "result":
        return EMTreeNodeType.result;
      default:
        throw 'Unsupported NodeType $value';
    }
  }
}

enum EMDecisionNodeDecisionType { majority, monoPass, monoFail }

extension EMDecisionNodeDecisionTypeEx on EMDecisionNodeDecisionType {
  static EMDecisionNodeDecisionType fromValue(String value) {
    switch (value) {
      case "majority":
        return EMDecisionNodeDecisionType.majority;
      case "monopass":
        return EMDecisionNodeDecisionType.monoPass;
      case "monofail":
        return EMDecisionNodeDecisionType.monoFail;
      default:
        throw 'Unsupported EMDecisionNodeDecisionType $value';
    }
  }
}

class EMTreeNode {
  EMTreeNodeType nodeType;
  EMTree tree;
  int? nextNode;
  int? failNode;
  int? passNode;
  EMDecisionNodeDecisionType? decisionMode;
  List<String>? conditions;
  int? resultVal;
  int nodeIndex;

  EMTreeNode(
      {required this.nodeIndex, required this.nodeType, required this.tree});

  factory EMTreeNode.ofInput(
      {required int nodeIndex, required EMTree tree, required int nextNode}) {
    EMTreeNode n = EMTreeNode(
        nodeIndex: nodeIndex, nodeType: EMTreeNodeType.input, tree: tree);
    n.nextNode = nextNode;
    return n;
  }

  factory EMTreeNode.ofDecision(
      {required int nodeIndex,
      required EMTree tree,
      required List<String> conditions,
      required int passNode,
      required int failNode,
      required EMDecisionNodeDecisionType? decisionMode}) {
    EMTreeNode n = EMTreeNode(
        nodeIndex: nodeIndex, nodeType: EMTreeNodeType.decision, tree: tree);
    n.conditions = conditions;
    n.passNode = passNode;
    n.failNode = failNode;
    n.decisionMode = decisionMode ?? EMDecisionNodeDecisionType.majority;
    return n;
  }

  factory EMTreeNode.ofResult(
      {required int nodeIndex, required EMTree tree, required int resultVal}) {
    EMTreeNode n = EMTreeNode(
        nodeIndex: nodeIndex, nodeType: EMTreeNodeType.result, tree: tree);
    n.resultVal = resultVal;
    return n;
  }

  int processFrame(PlatformPose pose,
      {required EMTreeNodeResult nodeLog,
      required List<EMTreeNodeResult> frameLogs}) {
    if (nodeType == EMTreeNodeType.input) {
      nodeLog.nextNode = nextNode;
      return tree.process(pose, nodeIndex: nextNode!, frameLogs: frameLogs);
    } else if (nodeType == EMTreeNodeType.decision) {
      _checkConditions(pose, nodeLog: nodeLog);
      nodeLog.decisionMode = decisionMode;
      nodeLog.nextNode = nextNode;
      return tree.process(pose, nodeIndex: nextNode!, frameLogs: frameLogs);
    } else {
      if (nodeType == EMTreeNodeType.result && resultVal == null) {
        throw 'No result specified in a result node';
      }
      nodeLog.resultVal = resultVal;
      return resultVal!;
    }
  }

  addCondition(String condition) {
    conditions ??= [];
    conditions!.add(condition);
  }

  _checkConditions(PlatformPose pose, {required EMTreeNodeResult nodeLog}) {
    if (conditions!.isEmpty) {
      throw 'No conditions specified';
    }

    if (conditions!.length % 2 == 0) {
      if (kDebugMode) {
        // print(
        //     'Even number of conditions specified, in case of equal conflict and majority deduction mode, pass node will be executed');
      }
    }

    if (decisionMode == null) {
      if (kDebugMode) {
        print('`decisionMode` not set, using `majority`');
      }
      decisionMode = EMDecisionNodeDecisionType.majority;
    }

    // decide next node based on decisionMode

    nodeLog.conditionResults = [];

    if (decisionMode == EMDecisionNodeDecisionType.majority) {
      num factor = 1 / conditions!.length;
      num score = 0;

      // check conditions
      for (var c in conditions!) {
        EMTreeNodeResultConditionResult conditionResult =
            EMTreeNodeResultConditionResult(value: 0.0, passed: false);
        score += isConditionPass(pose, c, conditionResult: conditionResult)
            ? factor
            : -1 * factor;
        nodeLog.conditionResults?.add(conditionResult);
      }

      if (score == 0) {
        nextNode = passNode;
      } else if (score > 0) {
        nextNode = passNode;
      } else {
        nextNode = failNode;
      }
    } else if (decisionMode == EMDecisionNodeDecisionType.monoPass) {
      nextNode = failNode;
      for (String c in conditions!) {
        EMTreeNodeResultConditionResult conditionResult =
            EMTreeNodeResultConditionResult(value: 0.0, passed: false);
        if (isConditionPass(pose, c, conditionResult: conditionResult)) {
          nextNode = passNode;
          nodeLog.conditionResults?.add(conditionResult);
          break;
        }
        nodeLog.conditionResults?.add(conditionResult);
      }
      // console.log(this.nextNode);
    } else if (decisionMode == EMDecisionNodeDecisionType.monoFail) {
      nextNode = passNode;
      for (String c in conditions!) {
        EMTreeNodeResultConditionResult conditionResult =
            EMTreeNodeResultConditionResult(value: 0.0, passed: false);
        if (!isConditionPass(pose, c, conditionResult: conditionResult)) {
          nextNode = failNode;
          nodeLog.conditionResults?.add(conditionResult);
          break;
        }
        nodeLog.conditionResults?.add(conditionResult);
      }
    } else {
      throw 'Invalid decision mode, expected on of [ `majority`, `monopass`, `monofail` ], got $decisionMode';
    }
  }

  static validate(EMTreeNode node) {
    if (node.nodeType == EMTreeNodeType.input) {
      if (node.nextNode == null) {
        throw 'Missing next node index';
      }
    } else if (node.nodeType == EMTreeNodeType.result) {
      if (node.resultVal == null) {
        throw 'Missing result to return';
      }
    } else if (node.nodeType == EMTreeNodeType.decision) {
      if (node.conditions == null) {
        throw 'Conditions not specified';
      }
      if (node.conditions!.isEmpty) {
        throw 'At least 1 valid condition must be specified';
      }

      for (int i = 0; i < node.conditions!.length; i++) {
        var c = node.conditions![i];
        try {
          validateConditionSpec(c);
        } catch (e) {
          throw 'Condition ${i + 1}: $e';
        }
      }

      if (node.passNode == null) {
        throw 'Missing pass node index';
      }

      if (node.failNode == null) {
        throw 'Missing fail node index';
      }
    } else {
      throw 'Invalid node type';
    }

    return true;
  }
}

class EMTree {
  EMTree();

  List<EMTreeNode> nodes = [];
  int initialNode = 0;

  addNode(EMTreeNode node) {
    nodes.add(node);
  }

  int process(PlatformPose pose,
      {int nodeIndex = 0, required List<EMTreeNodeResult> frameLogs}) {
    if (nodes.isEmpty) {
      throw 'No nodes in the tree';
    }

    try {
      EMTreeNodeResult nodeLog = EMTreeNodeResult.fromNode(nodes[nodeIndex]);
      int nodeResult = nodes[nodeIndex]
          .processFrame(pose, nodeLog: nodeLog, frameLogs: frameLogs);
      frameLogs.add(nodeLog);
      return nodeResult;
    } catch (e) {
      if (kDebugMode) {
        print('[Node: $nodeIndex] -> $e');
      }
      rethrow;
    }
  }

  static validate(EMTree tree) {
    if (tree.nodes.isEmpty) {
      throw 'Minimum 1 valid node is required';
    }

    int resultNodeCount = 0;
    int inputNodeCount = 0;

    for (int index = 0; index < tree.nodes.length; index++) {
      EMTreeNode node = tree.nodes[index];

      if (node.nodeType == EMTreeNodeType.input) {
        inputNodeCount += 1;
      }

      if (node.nodeType == EMTreeNodeType.result) {
        resultNodeCount += 1;
      }

      try {
        EMTreeNode.validate(node);
      } catch (e) {
        throw 'Node index $index: $e';
      }
    }

    if (resultNodeCount < 1) {
      throw 'No result nodes found';
    }

    return true;
  }

  factory EMTree.fromJson(List<dynamic> nodes) {
    EMTree tree = EMTree();
    for (int i = 0; i < nodes.length; i++) {
      var element = nodes[i];
      switch (EMTreeNodeTypeEx.fromValue(element["typ"])) {
        case EMTreeNodeType.input:
          tree.addNode(EMTreeNode.ofInput(
              nodeIndex: i, tree: tree, nextNode: element["nextNode"]));
          break;
        case EMTreeNodeType.decision:
          tree.addNode(EMTreeNode.ofDecision(
              nodeIndex: i,
              tree: tree,
              conditions: element["conditions"].cast<String>(),
              passNode: element["passNode"],
              failNode: element["failNode"],
              decisionMode: element["decisionMode"] != null
                  ? EMDecisionNodeDecisionTypeEx.fromValue(
                      element["decisionMode"])
                  : null));
          break;
        case EMTreeNodeType.result:
          tree.addNode(EMTreeNode.ofResult(
              nodeIndex: i, tree: tree, resultVal: element["result"]));
          break;
      }
    }
    validate(tree);
    return tree;
  }
}

validateConditionSpec(String conditionSpec) {
  var parts = conditionSpec.split('/');
  if (parts.length < 2) {
    throw 'Malformed condition spec, see help';
  }
  var angleSpec = parts[0];
  var limitSpec = parts[1];
  var pointSpecs = angleSpec.split(':');
  if (pointSpecs.length != 3) {
    throw '3 points are required in angle spec, got: $angleSpec';
  }
  var limitParts = limitSpec.split(':');
  if (limitParts.length != 2) {
    throw 'Minimum and maximum limit must be specified';
  }

  return true;
}

isConditionPass(PlatformPose pose, String conditionSpec,
    {required EMTreeNodeResultConditionResult conditionResult}) {
  var parts = conditionSpec.split('/');
  if (parts.length < 2) {
    throw 'Malformed condition spec';
  }
  // console.log(parts)
  var angleSpec = parts[0];
  var limitSpec = parts[1];
  var angleInDegrees = findAngle(pose, angleSpec);

  conditionResult.value = angleInDegrees;
  bool inLimit = isInLimit(angleInDegrees, limitSpec);
  conditionResult.passed = inLimit;

  return inLimit;
}

findAngle(PlatformPose pose, String angleSpec) {
  var pointSpecs = angleSpec.split(':');
  if (pointSpecs.length != 3) {
    throw '3 points are required in angle spec, got: $angleSpec';
  }
  var p1 = getPoint(pose, pointSpecs[0]);
  var p2 = getPoint(pose, pointSpecs[1]);
  var p3 = getPoint(pose, pointSpecs[2]);

  return getInsideAngleBetweenTwoLinesInDegrees(p2, p1, p2, p3);
}

isInLimit(num angleInDegrees, String limitSpec) {
  var limitParts = limitSpec.split(':');
  var limMin = num.parse(limitParts[0]);
  var limMax = num.parse(limitParts[1]);

  return angleInDegrees >= limMin && angleInDegrees <= limMax;
}
