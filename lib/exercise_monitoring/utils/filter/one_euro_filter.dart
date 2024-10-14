import 'dart:math';

import 'low_pass_filter.dart';

class OneEuroFilter
{
  double freq=0;
  double mincutoff=0;
  double beta_=0;
  double dcutoff=0;
  late LowPassFilter x;
  late LowPassFilter dx;
  double lasttime=0;
  static const double undefinedTime = (-1);

  double alpha(double cutoff)
  {
    double te = (1.0 / freq);
    double tau = (1.0 / ((2 * pi) * cutoff));
    return 1.0 / (1.0 + (tau / te));
  }

  void setFrequency(double f)
  {
    if (f <= 0) {
      throw Exception("freq should be >0");
    }
    freq = f;
  }

  void setMinCutoff(double mc)
  {
    if (mc <= 0) {
      throw Exception("mincutoff should be >0");
    }
    mincutoff = mc;
  }

  void setBeta(double b)
  {
    beta_ = b;
  }

  void setDerivativeCutoff(double dc)
  {
    if (dc <= 0) {
      throw Exception("dcutoff should be >0");
    }
    dcutoff = dc;
  }


  OneEuroFilter(double freq, {double mincutoff=1, double beta_=0, double dcutoff=1})
  {
    init(freq, mincutoff, beta_, dcutoff);
  }

  void init(double freq, double mincutoff, double beta_, double dcutoff)
  {
    setFrequency(freq);
    setMinCutoff(mincutoff);
    setBeta(beta_);
    setDerivativeCutoff(dcutoff);
    x = LowPassFilter(alpha(mincutoff));
    dx = LowPassFilter(alpha(dcutoff));
    lasttime = undefinedTime;
  }

  double filter(double value, {double timestamp=undefinedTime})
  {
    if ((lasttime != undefinedTime) && (timestamp != undefinedTime)) {
      freq = (1 / ((timestamp - lasttime) / 1000));
    }
    lasttime = timestamp;
    double dvalue = (x.hasLastRawValue() ? ((value - x.lastRawValue()) * freq) : 0);
    double edvalue = dx.filterWithAlpha(dvalue, alpha(dcutoff));
    double cutoff = (mincutoff + (beta_ * edvalue.abs()));
    return x.filterWithAlpha(value, alpha(cutoff));
  }
}