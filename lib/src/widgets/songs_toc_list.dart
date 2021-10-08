import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../modals/song_responses.dart';
import '../utilities/constants.dart';
import '../utilities/settings.dart';
import '../utilities/Helper.dart';
import '../widgets/spacer.dart';
import '../screens/song_details.dart';
import '../bloc/song_bloc.dart';
import '../bloc/general_provider.dart';

class SongsTocList extends StatelessWidget {
  final List<SongModal> songs;
  final SongBloc songBloc;
  final GeneralBloc generalBloc;
  final String textStr;

  SongsTocList({
    @required this.songs,
    @required this.songBloc,
    @required this.generalBloc,
    this.textStr,
  });

//   @override
//   State<StatefulWidget> createState() {
//     return _SongsTocListState(
//         songs: songs, songBloc: songBloc, generalBloc: generalBloc);
//   }
// }

// class _SongsTocListState extends State<SongsTocList> {
  final ClubColourModeModal colours = Setting().colours();
  // final List<SongModal> songs;
  // final SongBloc songBloc;
  // final GeneralBloc generalBloc;
  final ScrollController scrollController = ScrollController();

  // _SongsTocListState(
  //     {@required this.songs,
  //     @required this.songBloc,
  //     @required this.generalBloc});

  // @override
  // void initState() {
  //   super.initState();
  //   scrollController.addListener(() {
  //     if (scrollController.position.userScrollDirection ==
  //         ScrollDirection.forward) {
  //       if (Helper.showTabbar) {
  //         Helper.showTabbar = false;
  //         generalBloc.changeDisplayTabbar(false);
  //       }
  //     } else if (scrollController.position.userScrollDirection ==
  //         ScrollDirection.reverse) {
  //       if (!Helper.showTabbar) {
  //         Helper.showTabbar = true;
  //         generalBloc.changeDisplayTabbar(true);
  //       }
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (Helper.showTabbar) {
          Helper.showTabbar = false;
          generalBloc.changeDisplayTabbar(false);
        }
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!Helper.showTabbar) {
          Helper.showTabbar = true;
          generalBloc.changeDisplayTabbar(true);
        }
      }
    });
    return _uiBuilder();
  }

  Widget _uiBuilder() {
    // for (SongModal s in songs) {
    //   print(
    //       'number in section: ${s.numberInSection}, sort order: ${s.sortOrder} - $textStr');
    // }
    // print('Building Songs Toc List');
    return ListView.builder(
      controller: scrollController,
      itemCount: songs.length,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.fromLTRB(0, 5, 10, 5),
          child: _listItem(context, songs[index]),
        );
      },
    );
  }

  Widget _listItem(BuildContext context, SongModal song) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => SongDetailScreen(
                      songId: song.id.toString(),
                      title: song.songNumber,
                      songBloc: songBloc,
                      songName: (song.isChorus
                          ? '${song.songChorus}'
                          : song.displayName),
                    )));
      },
      child: Row(
        children: [
          Container(
            width: 70,
            child: Text(
              song.songNumber,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: Constants.FONT_FAMILY_FUTURA,
                fontSize: 16,
                color: colours.bodyTextColour(),
              ),
            ),
          ),
          Space(horizontal: 5),
          Expanded(
            child: Container(
              child: Text(
                // song.songName.replaceAll('---', '\u2014'),
                song.displayName.replaceAll('---', '\u2014'),
                style: TextStyle(
                  fontFamily: Constants.FONT_FAMILY_FUTURA,
                  fontSize: 16,
                  color: colours.bodyTextColour(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
