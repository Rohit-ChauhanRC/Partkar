import 'package:rxdart/rxdart.dart';
import 'validator.dart';
import '../modals/song_responses.dart';
import '../modals/error_response.dart';
import '../resources/api_provider.dart';
import '../resources/data_store.dart';
import '../utilities/constants.dart';

enum SongsListView {
  typeTOC,
  typeIndex,
}

class SongBloc extends Object with Validator {
  final _viewType = BehaviorSubject<SongsListView>();
  final _searchText = BehaviorSubject<String>();

  Stream<SongsListView> get viewType => _viewType.stream;
  Stream<String> get searchText => _searchText.stream;

  Function(SongsListView) get changeViewType => _viewType.sink.add;
  Function(String) get changeSearchText => _searchText.sink.add;

  Future<dynamic> fetchSongs() async {
    final headers = {'Authorization': await DataStore().getLoginToken()};
    final apiProvider = ApiProvider();
    final response = await apiProvider.getData(Constants.END_POINT_SONGS_LIST,
        headers: headers);
    // print('SONGS Response');
    // print(response);
    if (response['status']) {
      SongsResponseModal res = SongsResponseModal.fromJSON(response);
      return res.data.songs;
    }

    ErrorResponseModel err = ErrorResponseModel.fromJSON(response);

    return err;
  }

  Future<dynamic> fetchSongDetails(String id) async {
    final headers = {'Authorization': await DataStore().getLoginToken()};
    final apiProvider = ApiProvider();
    final response = await apiProvider
        .getData(Constants.END_POINT_SONG_DETAIL(id), headers: headers);
    print('SONGS Detail Response');
    print(response);
    if (response['status']) {
      SongDetailsResponseModal res =
          SongDetailsResponseModal.fromJSON(response);
      return res.data.song;
    }

    ErrorResponseModel err = ErrorResponseModel.fromJSON(response);

    return err;
  }

  dispose() {
    _viewType.close();
    _searchText.close();
  }
}
