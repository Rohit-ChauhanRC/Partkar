import 'package:rxdart/subjects.dart';

class AudioPlayerBloc {
  final _progressStatus = BehaviorSubject<double>();
  final _playSpeed = BehaviorSubject<double>();

  Stream<double> get progressStatus => _progressStatus.stream;
  Stream<double> get playSpeed => _playSpeed.stream;

  Function(double) get changeProgressStatus => _progressStatus.sink.add;
  Function(double) get changePlaySpeed => _playSpeed.sink.add;

  double getPlaySpeedValue() {
    return _playSpeed.value;
  }

  dispose() {
    _progressStatus.close();
    _playSpeed.close();
  }
}
