import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../bloc/song_provider.dart';
import '../bloc/general_provider.dart';
import '../bloc/notification_provider.dart';
import '../widgets/songs_toc_list.dart';
import '../widgets/songs_index_list.dart';
import '../widgets/alert.dart';
import '../widgets/spacer.dart';
// import '../widgets/club_icon.dart';
import '../modals/song_responses.dart';
import '../modals/error_response.dart';
import '../utilities/constants.dart';
import '../utilities/settings.dart';
import '../utilities/Helper.dart';
import 'navigation_drawer.dart';
import 'notifications.dart';

class SongsTabScreen extends StatefulWidget {
  final GeneralBloc generalBloc;

  SongsTabScreen({@required this.generalBloc});

  @override
  State<SongsTabScreen> createState() {
    return _SongsTabScreenState(generalBloc: generalBloc);
  }
}

class _SongsTabScreenState extends State<SongsTabScreen>
    with AutomaticKeepAliveClientMixin<SongsTabScreen> {
  ClubColourModeModal colours = Setting().colours();
  final GeneralBloc generalBloc;
  SongBloc songBloc;
  List<SongModal> allSongs = [];

  _SongsTabScreenState({@required this.generalBloc});

  @override
  bool get wantKeepAlive => true;

  Future<bool> _onPop() async {
    Helper.HOME_BACK_CLICKED = true;
    Helper.HANDLE_BACK(context);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    colours = Setting().colours();
    if (songBloc == null) songBloc = SongProvider.of(context);
    songBloc.changeViewType(SongsListView.typeTOC);
    return WillPopScope(
      child: Scaffold(
        appBar: _appBar(),
        body: _body(songBloc),
        endDrawer: GeneralProvider(child: NavigationDrawer()),
        backgroundColor: colours.bgColour(),
      ),
      onWillPop: _onPop,
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(
        'Songs',
        style: TextStyle(
          fontSize: 24,
          fontFamily: Constants.FONT_FAMILY_TIMES,
          color: colours.bgColour(),
        ),
      ),
      iconTheme: IconThemeData(color: colours.bgColour()),
      backgroundColor: colours.headlineColour(),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      // leading: ClubIconWidget(),
      actions: [_notificationIcon(), _menuIcon()],
    );
  }

  Widget _notificationIcon() {
    return GestureDetector(
      child: Container(
        // width: 30,
        // height: 30,
        color: Colors.transparent,
        padding: EdgeInsets.fromLTRB(10, 0, 7, 0),
        child: Icon(
          Icons.notifications_rounded,
          size: 30,
          color: colours.bgColour(),
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    NotificationProvider(child: NotificationsScreen())));
      },
    );
  }

  Widget _menuIcon() {
    return GestureDetector(
      child: Container(
        // width: 30,
        // height: 30,
        color: Colors.transparent,
        padding: EdgeInsets.fromLTRB(7, 0, 15, 0),
        child: Icon(
          Icons.menu_rounded,
          size: 30,
          color: colours.bgColour(),
        ),
      ),
      onTap: () {
        Scaffold.of(context).openEndDrawer();
      },
    );
  }

  Widget _body(SongBloc songBloc) {
    // print('Building Songs Tab');
    if (allSongs.length > 0) {
      return _viewBuilder(context, songBloc, allSongs);
    }
    return FutureBuilder(
      future: songBloc.fetchSongs(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data;
          // print('data');
          // print(data);
          if (data is List<SongModal>) {
            // print('building list');
            allSongs = data;
            return _viewBuilder(
                context, songBloc, allSongs); //_listBuilder(songBloc, data);
          } else if (data is ErrorResponseModel) {
            Alert.defaultAlert(context, 'Error', data.message);
          }
        } else {
          return Center(
              child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(colours.bodyTextColour())));
        }
        return Text(''); //
      },
    );
  }

  Widget _viewBuilder(
      BuildContext context, SongBloc songBloc, List<SongModal> songs) {
    return Column(
      children: [
        _tabBuilder(songBloc),
        Divider(),
        _searchBar(context, songBloc),
        Divider(),
        Space(verticle: 5),
        Expanded(child: _listBuilder(songBloc, songs))
      ],
    );
  }

  Widget _tabBuilder(SongBloc songBloc) {
    // return Row(
    //   children: [
    //     _tab('TOC View', 80, () {
    //       songBloc.changeViewType(SongsListView.typeTOC);
    //     }),
    //     _tab('Index View', 90, () {
    //       songBloc.changeViewType(SongsListView.typeIndex);
    //     }),
    //   ],
    // );
    return StreamBuilder(
      stream: songBloc.viewType,
      builder: (context, snapshot) {
        bool tocSelected = false;
        bool indexSelected = false;
        if (snapshot.hasData) {
          if (snapshot.data == SongsListView.typeTOC) {
            tocSelected = true;
          } else {
            indexSelected = true;
          }
        } else {
          tocSelected = true;
        }
        return Row(
          children: [
            _tab('TOC View', 80, tocSelected, () {
              songBloc.changeViewType(SongsListView.typeTOC);
            }),
            _tab('Index View', 90, indexSelected, () {
              songBloc.changeViewType(SongsListView.typeIndex);
            }),
          ],
        );
      },
    );
  }

  Widget _tab(String title, double width, bool isSelected, Function onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 26,
        width: width,
        padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
        margin: EdgeInsets.fromLTRB(8, 8, 8, 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: colours.accentColour(),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected
                  ? colours.bgColour()
                  : colours.bgColour().withOpacity(0.5),
              fontFamily: Constants.FONT_FAMILY_FUTURA,
            ),
          ),
        ),
      ),
    );
  }

  // final searchController = TextEditingController();
  // TextSelection cachedSelection;

  Widget _searchBar(BuildContext context, SongBloc songBloc) {
    // var searchController = TextEditingController();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: StreamBuilder(
        stream: songBloc.searchText,
        builder: (cntxt, snapshot) {
          // if (snapshot.hasData) {
          //   // searchController.text = snapshot.data;
          //   // searchController.selection = TextSelection.fromPosition(
          //   //     TextPosition(offset: searchController.text.length));

          //   searchController.text = snapshot.data;

          //   if (cachedSelection == null) {
          //     searchController.selection = TextSelection.fromPosition(
          //         TextPosition(offset: searchController.text.length));
          //   } else {
          //     searchController.selection = cachedSelection;
          //   }
          // }
          return TextField(
            // controller: searchController,
            cursorColor: colours.bodyTextColour(),
            style: TextStyle(
              fontFamily: Constants.FONT_FAMILY_FUTURA,
              color: colours.bodyTextColour(),
            ),
            decoration: InputDecoration(
              hintText: 'Search here',
              hoverColor: Colors.yellow,
              suffixIcon: IconButton(
                onPressed: () {
                  // searchController.clear();
                  FocusScope.of(context).unfocus();
                  songBloc.changeSearchText('');
                },
                icon: Icon(
                  Icons.clear,
                  color: colours.bodyTextColour(),
                ),
              ),
              hintStyle: TextStyle(
                fontFamily: Constants.FONT_FAMILY_FUTURA,
                color: colours.bodyTextColour().withOpacity(0.5),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: colours.bodyTextColour(),
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: colours.bodyTextColour(),
                ),
              ),
            ),
            // onChanged: songBloc.changeSearchText,
            onChanged: (text) {
              // cachedSelection = searchController.selection;
              songBloc.changeSearchText(text);
            },
          );
        },
      ),
    );
  }

  Widget _listBuilder(SongBloc songBloc, List<SongModal> allSongs) {
    return StreamBuilder(
      stream: songBloc.searchText,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final searchText = snapshot.data;
          if (searchText == '') {
            // print('render empty list ${allSongs.length}');
            return _listView(songBloc, allSongs);
          }
          // print('Searching for: $searchText');
          var searchResultName = allSongs
              .where((song) => (song.songName ?? '')
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))
              .toList();
          var searchResultNumber = allSongs
              .where((song) => (song.songNumber ?? '')
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))
              .toList();
          var searchResultFirstLine = allSongs
              .where((song) => (song.songFirstline ?? '')
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))
              .toList();
          var searchResultChorus = allSongs.where((song) {
            String chorus = song.songChorus ?? '';
            return chorus.toLowerCase().contains(searchText.toLowerCase());
          }).toList();

          var searchResult = searchResultName +
              searchResultNumber +
              searchResultFirstLine +
              searchResultChorus;

          Map<int, SongModal> mp = {};
          for (SongModal item in searchResult) {
            mp[item.id] = item;
          }
          var filteredList = mp.values.toList();
          // print('render filter list ${filteredList.length}');
          return _listView(songBloc, filteredList);
        } else {
          // print('render else list ${allSongs.length}');
          return _listView(songBloc, allSongs);
        }
      },
    );
  }

  Widget _listView(SongBloc songBloc, List<SongModal> songs) {
    return StreamBuilder(
      stream: songBloc.viewType,
      builder: (context, snapshot) {
        songs.forEach((s) {
          String sName = '';
          if ((s.songName != null) && (s.songName != '')) {
            sName = s.songName;
          } else if ((s.songFirstline != null) && (s.songFirstline != '')) {
            sName = s.songFirstline;
          }
          s.displayName = sName;
        });
        if (snapshot.hasData) {
          if (snapshot.data == SongsListView.typeTOC) {
            songs.sort((a, b) {
              int cmp = a.sortOrder.compareTo(b.sortOrder);
              if (cmp != 0) return cmp;
              return a.numberInSection.compareTo(b.numberInSection);
            });

            return _tocView(songBloc, songs, '');
          }
          List<SongModal> isongs = List.from(songs);
          songs.forEach((s) {
            if (s.songChorus != null) {
              if ((s.songChorus != '') && (s.songChorus != null)) {
                SongModal s1 = new SongModal.copyWith(s);
                s1.isChorus = true;
                s1.displayName = s1.songChorus;
                isongs.add(s1);
              }
            }
          });
          // isongs.forEach((s) {
          //   String sName = '';
          //   if ((s.songName != null) && (s.songName != '')) {
          //     sName = s.songName;
          //   } else if ((s.songFirstline != null) && (s.songFirstline != '')) {
          //     sName = s.songFirstline;
          //   }
          //   s.displayName = sName;
          // });
          isongs.sort((a, b) {
            String nameA = a.displayName
                .toLowerCase()
                .replaceAll('"', '')
                .replaceAll('\'', '')
                .replaceAll('!', '')
                .replaceAll(',', '');
            String nameB = b.displayName
                .toLowerCase()
                .replaceAll('"', '')
                .replaceAll('\'', '')
                .replaceAll('!', '')
                .replaceAll(',', '');
            return nameA.compareTo(nameB);
          });
          return _indexView(songBloc, isongs);
        } else {
          songs.sort((a, b) {
            int cmp = a.sortOrder.compareTo(b.sortOrder);
            if (cmp != 0) return cmp;
            return a.numberInSection.compareTo(b.numberInSection);
          });

          return _tocView(songBloc, songs, 'e');
        }
      },
    );
  }

  Widget _tocView(SongBloc songBloc, List<SongModal> songs, String s) {
    return SongsTocList(
      songs: songs,
      songBloc: songBloc,
      generalBloc: generalBloc,
      textStr: s,
    );
  }

  Widget _indexView(SongBloc songBloc, List<SongModal> songs) {
    return SongsIndexList(
      songs: songs,
      songBloc: songBloc,
      generalBloc: generalBloc,
    );
  }
}
