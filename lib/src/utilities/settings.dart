import 'package:intl/intl.dart';
import '../modals/club_responses.dart';
export '../modals/club_responses.dart';
import '../resources/data_store.dart';
// import '../bloc/settings_provider.dart';

enum ColourModes { day, night, auto }

class Setting {
  static final Setting _instance = new Setting._internal();

  factory Setting() {
    return _instance;
  }

  Setting._internal();

  ClubColourModesModal _colours;
  ColourModes _mode;

  Future<void> loadColours() async {
    _colours = await DataStore().getLoginClubColours();
  }

  Future<void> loadColourMode() async {
    _mode = await DataStore().getSelectedColourMode();
  }

  ColourModes mode() {
    ColourModes givenMode = _mode;
    if (givenMode == ColourModes.auto) {
      DateTime currentTime = DateTime.now();
      String currentDate = DateFormat('yyyy-MM-dd').format(currentTime);
      String givenMorningTime = '$currentDate 07:30 AM';
      String givenEveningTime = '$currentDate 07:30 PM';
      DateFormat format = DateFormat('yyyy-MM-dd HH:mm a');
      DateTime morningTime = format.parse(givenMorningTime);
      DateTime eveningTime = format.parse(givenEveningTime);

      if ((currentTime.isAfter(morningTime)) &&
          (currentTime.isBefore(eveningTime))) {
        return ColourModes.day;
      } else {
        return ColourModes.night;
      }
    }

    return givenMode;
  }

  ClubColourModeModal colours() {
    if (mode() == ColourModes.day) {
      return _colours.day;
    }
    return _colours.night;
  }
}
