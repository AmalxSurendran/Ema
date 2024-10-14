import 'package:ema_v4/exercise_monitoring/models/calib_data.dart';
import 'package:ema_v4/exercise_monitoring/utils/engine/engine_compute.dart';

import '../utils/engine/exercise_session_processor.dart';

class IED {
  CalibData calibConfig;
  EMTree engine;
  ExerciseSessionProcessor processor;
  IED({required this.calibConfig, required this.engine,required this.processor});
  factory IED.fromJson(Map<String, dynamic> json) => IED(
    calibConfig: CalibData.fromJson(json["calibConfig"]),
    engine: EMTree.fromJson(json["nodes"]),
    processor: ExerciseSessionProcessor.fromJson(json["engineConfig"])
  );
}