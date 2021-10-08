import 'package:rxdart/rxdart.dart';
import '../resources/api_provider.dart';
import '../utilities/constants.dart';
import 'validator.dart';
import '../modals/club_responses.dart';
import '../modals/error_response.dart';

class ClubBloc extends Object with Validator {
  // final _clubs = BehaviorSubject<List<ClubModal>>();
  final _searchText = BehaviorSubject<String>();

  // Stream<List<ClubModal>> get clubs => _clubs.stream;
  Stream<String> get searchText => _searchText.stream;

  // Function(List<ClubModal>) get changeClubs => _clubs.sink.add;
  Function(String) get changeSearchText => _searchText.sink.add;

  Future<dynamic> fetchClubs() async {
    final apiProvider = ApiProvider();
    final response = await apiProvider.getData(Constants.END_POINT_CLUBS);
    if (response['status']) {
      AllClubsResponseModal res = AllClubsResponseModal.fromJSON(response);
      return res.data;
    }

    ErrorResponseModel err = ErrorResponseModel.fromJSON(response);

    return err;
  }

  Future<ClubDataModal> fetchClubInfo(String id) async {
    final body = {'club_id': id};
    final apiProvider = ApiProvider();
    final response =
        await apiProvider.postData(Constants.END_POINT_CLUB_INFO, body: body);
    // if (response['status']) {
    ClubInfoResponseModal res = ClubInfoResponseModal.fromJSON(response);
    // print(response);
    return res.data;
    //   return;
    // }

    // ErrorResponseModel err = ErrorResponseModel.fromJSON(response);

    // changeClubs(err);
  }

  dispose() {
    // _clubs.close();
    _searchText.close();
  }
}
