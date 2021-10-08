import 'package:flutter/material.dart';
import '../widgets/alert.dart';
import '../widgets/spacer.dart';
import '../widgets/club_item.dart';
import '../bloc/club_provider.dart';
import '../bloc/login_provider.dart';
import '../utilities/constants.dart';
import '../modals/club_responses.dart';
import '../modals/error_response.dart';
import '../resources/data_store.dart';
import 'login.dart';

class ClubSelectorScreen extends StatelessWidget {
  final bool fromSplash;

  ClubSelectorScreen({this.fromSplash = false});

  @override
  Widget build(BuildContext context) {
    final ClubBloc clubBloc = ClubProvider.of(context);
    return Scaffold(
      body: _body(context, clubBloc),
    );
  }

  Widget _body(BuildContext context, ClubBloc clubBloc) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ..._backButton(context),
              _title(),
              Space(verticle: 20),
              _searchBar(context, clubBloc),
              Space(verticle: 20),
              _clubs(context, clubBloc),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _backButton(BuildContext context) {
    if (fromSplash) {
      return [Space(verticle: 40)];
    } else {
      List<Widget> widgets = [Space(verticle: 10)];
      widgets.add(Row(
        children: [
          IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ));
      return widgets;
    }
  }

  Widget _title() {
    return Text(
      'Select Club',
      style: TextStyle(fontFamily: Constants.FONT_FAMILY_FUTURA, fontSize: 20),
    );
  }

  Widget _searchBar(BuildContext context, ClubBloc clubBloc) {
    var searchController = TextEditingController();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: StreamBuilder(
        stream: clubBloc.searchText,
        builder: (cntxt, snapshot) {
          return TextField(
            controller: searchController,
            autocorrect: false,
            enableSuggestions: false,
            style: TextStyle(fontFamily: Constants.FONT_FAMILY_FUTURA),
            decoration: InputDecoration(
              hintText: 'Search club here',
              suffixIcon: IconButton(
                onPressed: () {
                  // searchController.clear();
                  FocusScope.of(context).unfocus();
                  clubBloc.changeSearchText('');
                },
                icon: Icon(Icons.clear, color: Colors.grey[900]),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[900]),
              ),
            ),
            onChanged: clubBloc.changeSearchText,
          );
        },
      ),
    );
  }

  Widget _clubs(BuildContext context, ClubBloc clubBloc) {
    return FutureBuilder(
      future: clubBloc.fetchClubs(),
      builder: (cntxt, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data;
          if (data is ErrorResponseModel) {
            Alert.defaultAlert(context, 'Error', data.message);
            return Center(child: Text(data.message));
          } else if (data is ClubsModal) {
            return _clublistSearch(context, clubBloc, data);
          }
        } else {
          return Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black)));
        }
        return Center(child: Text('Club List'));
      },
    );
  }

  Widget _clublistSearch(
      BuildContext context, ClubBloc clubBloc, ClubsModal clubsData) {
    return StreamBuilder(
      stream: clubBloc.searchText,
      builder: (cntxt, snapshot) {
        if (snapshot.hasData) {
          final searchText = snapshot.data;
          if (searchText == '') {
            return _clublist(
                context, clubsData.clubs, clubsData.clubInfo.clubMediaUrl);
          }
          List<ClubModal> nameSearchResult = clubsData.clubs
              .where((club) => club.clubName
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))
              .toList();

          List<ClubModal> citySearchResult = clubsData.clubs
              .where((club) =>
                  club.city.toLowerCase().contains(searchText.toLowerCase()))
              .toList();

          List<ClubModal> codeSearchResult = clubsData.clubs
              .where((club) => club.clubCode
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))
              .toList();

          List<ClubModal> searchResult =
              nameSearchResult + citySearchResult + codeSearchResult;
          return _clublist(context, searchResult.toSet().toList(),
              clubsData.clubInfo.clubMediaUrl);
        } else {
          return _clublist(
              context, clubsData.clubs, clubsData.clubInfo.clubMediaUrl);
        }
      },
    );
  }

  Widget _clublist(
      BuildContext context, List<ClubModal> clubs, String mediaUrl) {
    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: clubs.length,
      itemBuilder: (cntxt, index) {
        return GestureDetector(
          child: ClubItemWidget(club: clubs[index], mediaUrl: mediaUrl),
          onTap: () {
            _clubSelected(context, clubs[index], mediaUrl);
          },
        );
      },
    );
  }

  void _clubSelected(BuildContext context, ClubModal club, String mediaUrl) {
    DataStore().saveClubMediaUrl(mediaUrl);
    DataStore().saveSelectedClub(club);
    if (fromSplash) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (cntxt) => LoginProvider(
                  child: ClubProvider(
                      child: LoginScreen(
                          club: club,
                          mediaUrl: mediaUrl,
                          goToRegister: true)))));
    } else {
      Navigator.pop(context, true);
    }
  }
}
