import '../../../pigeon.dart';
import 'one_euro_filter.dart';

class PoseFilter {
  double frequency = 10;
  double mincutoff = 0.7;
  double beta = 0.005;
  double dcutoff = 0.7;
  late OneEuroFilter pointFilterX;
  late OneEuroFilter pointFilterY;

  PoseFilter() {
    try {
      pointFilterX = OneEuroFilter(frequency,
          mincutoff: mincutoff, beta_: beta, dcutoff: dcutoff);
      pointFilterY = OneEuroFilter(frequency,
          mincutoff: mincutoff, beta_: beta, dcutoff: dcutoff);
    } on Exception catch (e) {
      print(e);
    }
  }

  PlatformPoseLandmark getFilteredLandmark(PlatformPoseLandmark landmark) {
    return PlatformPoseLandmark(type: landmark.type,
        x: pointFilterX.filter(landmark.x, timestamp: DateTime
            .now()
            .millisecondsSinceEpoch
            .toDouble()),
      y: pointFilterY.filter(landmark.y, timestamp: DateTime
          .now()
          .millisecondsSinceEpoch
          .toDouble()),
      z: landmark.z,
      likelihood: landmark.likelihood
    );
  }
}
