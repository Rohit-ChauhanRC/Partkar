import 'package:rxdart/rxdart.dart';
import '../modals/bible_responses.dart';
import '../modals/error_response.dart';
import '../resources/api_provider.dart';
import '../resources/data_store.dart';
import '../utilities/constants.dart';

class BibleBloc {
  final _bibles = BehaviorSubject<dynamic>();

  Stream<dynamic> get bible => _bibles.stream;

  Function(dynamic) get changeBible => _bibles.sink.add;

  void fetchBible() async {
    final headers = {'Authorization': await DataStore().getLoginToken()};
    final apiProvider = ApiProvider();
    final response =
        await apiProvider.getData(Constants.END_POINT_BIBLE, headers: headers);
    // print('BIBLE Response');
    // print(response);
    if (response['status']) {
      BibleResponseModal res = BibleResponseModal.fromJSON(response);
      changeBible(res.data);
      return;
    }

    ErrorResponseModel err = ErrorResponseModel.fromJSON(response);

    changeBible(err);
  }

  Future<BibleChapterDetailResponseModal> fetchChapterDetails(int id) async {
    final headers = {'Authorization': await DataStore().getLoginToken()};
    final body = {'chapter_id': id.toString()};
    final apiProvider = ApiProvider();
    final response = await apiProvider.postData(
        Constants.END_POINT_BIBLE_CHAPTER_DETAILS,
        headers: headers,
        body: body);
    // print('BIBLE chapter detail Response');
    // print(response);
    BibleChapterDetailResponseModal res =
        BibleChapterDetailResponseModal.fromJSON(response);
    // print('returning');
    return res;
  }

  dispose() {
    _bibles.close();
  }
}
