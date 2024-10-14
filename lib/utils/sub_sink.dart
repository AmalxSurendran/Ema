import 'dart:async';


class SubSink {

  List<StreamSubscription?> _subs = [];

  SubSink() {
    _subs = [];
  }

  add(StreamSubscription s) {

    _subs.add(s);

  }

  cancelAll() {

    for (var value in _subs) {
      value?.cancel();
    }

  }

}