import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';


class ExerciseSessionProcessor {
  static const classMinValue = -100;
  int windowSize, resetClass;
  List<ProcessorClass> repSequence;
  late void Function() onRepDetected;
  late void Function(int classID) goToClass;
  late void Function(int classID) onStartHolding;

  List<int> _window = [];
  int expectedSequenceIndex = 0;

  Timer holdTimer = Timer(const Duration(seconds: 0), () {});
  final RxInt holdTimeLeft = RxInt(0);
  final RxBool isHoldingClass = RxBool(false);

  ExerciseSessionProcessor({
    required this.windowSize,
    required this.resetClass,
    required this.repSequence,
  }) {
    _window = List.generate(windowSize, (index) => classMinValue);
    expectedSequenceIndex = 0;
  }

  resetProcessor() {
    _window = List.generate(windowSize, (index) => classMinValue);
  }

  add(int classValue) {
    _window.removeAt(0);
    _window.add(classValue);

    // if (classValue == resetClass) {
    //   _onClassConfirmed(resetClass);
    //   return resetProcessor();
    // }
    bool allSame = true;

    _window.forEachIndexed((index, element) {
      if (index > 0) {
        if (_window[index] != _window[index - 1]) {
          allSame = false;
        }
      }
    });

    if (allSame) {
      int conClass = _window[0];

        _onClassConfirmed(conClass);

    }
  }

  _onClassConfirmed(int confirmedClass) {
    debugPrint(
        "processor trace : confirmed class is $confirmedClass expecting class is ${repSequence[expectedSequenceIndex].classID}");
    if (repSequence[expectedSequenceIndex].acceptedClasses.contains(confirmedClass)) {
      if (repSequence[expectedSequenceIndex].holdDuration > 0) {
        if (!holdTimer.isActive) {
          debugPrint(
              "processor trace : class requires hold and not holding currently");
          isHoldingClass(true);
          onStartHolding(confirmedClass);
          holdTimeLeft(repSequence[expectedSequenceIndex].holdDuration);
          holdTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
            holdTimeLeft(
                repSequence[expectedSequenceIndex].holdDuration - timer.tick);
            if (timer.tick == repSequence[expectedSequenceIndex].holdDuration) {
              holdTimer.cancel();
              isHoldingClass(false);
              debugPrint("processor trace : hold complete moving to next");
              _moveToNextClass();
            }
          });
        }
      } else {
        debugPrint(
            "processor trace : class does not require hold. moving to next");
        _moveToNextClass();
      }
    } else {
      if (holdTimer.isActive) {
        holdTimer.cancel();
        isHoldingClass(false);
        debugPrint("processor trace : holding stopped in middle");
        goToClass(repSequence[expectedSequenceIndex].classID);
      }
    }
  }

  _moveToNextClass() {
    if (expectedSequenceIndex == repSequence.length - 1) {
      _onRepDetectedInternal();
      expectedSequenceIndex = 0;
      if (repSequence.last.classID != repSequence.first.classID) {
        goToClass(repSequence[expectedSequenceIndex].classID);
      }
    } else {
      expectedSequenceIndex = expectedSequenceIndex + 1;
      goToClass(repSequence[expectedSequenceIndex].classID);
    }
  }

  _onRepDetectedInternal() {
    onRepDetected();
  }

  factory ExerciseSessionProcessor.fromJson(Map<String, dynamic> json) {
    List<dynamic> a = (json["repSequence"] as List<dynamic>);
    List<ProcessorClass> repSequence = [];
    for (var element in a) {
      repSequence.add(ProcessorClass.fromJson(element));
    }
    return ExerciseSessionProcessor(
        windowSize: json["windowSize"],
        resetClass: json["resetClass"],
        repSequence: repSequence);
  }
}

class ProcessorClass {
  int classID;
  int holdDuration;
  List<int> acceptedClasses;

  ProcessorClass(
      {required this.classID,
      required this.holdDuration,
      required this.acceptedClasses});

  factory ProcessorClass.fromJson(Map<String, dynamic> json) {
    List<int> acceptedClasses = [];
    for (var element in (json["acceptedClasses"] as List<dynamic>)) {
      acceptedClasses.add(element);
    }
    return ProcessorClass(
        classID: json["classID"],
        holdDuration: json["holdDuration"],
        acceptedClasses: acceptedClasses);
  }
}
