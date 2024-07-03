import 'package:shared_preferences/shared_preferences.dart';

class VideoPlaybackConfigRepository {
  static const String _autoplay = 'autoplay';
  static const String _muted = 'muted';

  final SharedPreferences _preferences;

  VideoPlaybackConfigRepository(this._preferences);

  Future<void> setMute(bool value) async {
    _preferences.setBool(_muted, value);
  }

  Future<void> setAutoplay(bool value) async {
    _preferences.setBool(_autoplay, value);
  }

  bool isMuted() {
    //디스크에 없으면 false
    return _preferences.getBool(_muted) ?? false;
  }

  bool isAutoplay() {
    //디스크에 없으면 false
    return _preferences.getBool(_autoplay) ?? false;
  }
}
