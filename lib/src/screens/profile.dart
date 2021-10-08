import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import '../utilities/constants.dart';
import '../utilities/settings.dart';
import '../bloc/profile_provider.dart';
import '../bloc/club_provider.dart';
import '../bloc/change_password_provider.dart';
import '../bloc/general_provider.dart';
import '../modals/user_responses.dart';
import '../modals/error_response.dart';
import '../widgets/spacer.dart';
import '../widgets/loader.dart';
import '../widgets/alert.dart';
import 'change_password.dart';
import 'navigation_drawer.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin<ProfileScreen> {
  final ClubColourModeModal colours = Setting().colours();
  ProfileBloc profileBloc;
  ClubBloc clubBloc;

  @override
  bool get wantKeepAlive => true;

  bool setData = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // print('BUILDING PROFILE');
    if (profileBloc == null) profileBloc = ProfileProvider.of(context);
    if (clubBloc == null) clubBloc = ClubProvider.of(context);
    return Scaffold(
      appBar: _appBar(),
      body: _body(context, profileBloc, clubBloc),
      endDrawer: GeneralProvider(child: NavigationDrawer()),
      backgroundColor: colours.bgColour(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      leading: _backButton(),
      title: Text(
        'Profile',
        style: TextStyle(
          fontSize: 24,
          fontFamily: Constants.FONT_FAMILY_TIMES,
          color: colours.bgColour(),
        ),
      ),
      iconTheme: IconThemeData(color: colours.bgColour()),
      backgroundColor: colours.headlineColour(),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    );
  }

  Widget _backButton() {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: colours.bgColour(),
      ),
      onPressed: () => Navigator.pop(context),
    );
  }

  Widget _body(
      BuildContext context, ProfileBloc profileBloc, ClubBloc clubBloc) {
    //profileBloc.setData();
    return FutureBuilder(
      future: profileBloc.fetchProfile(),
      builder: (cntxt, snapshot) {
        // print('Snapshot');
        // print(snapshot.data);
        if (snapshot.hasData) {
          var data = snapshot.data;
          String profileImageUrl;
          if (data is UserModal) {
            if (!setData) {
              profileBloc.setData(data);
              setData = true;
            }

            if ((data.profileImage != null) && (data.profileImage != '')) {
              profileImageUrl = data.profileImageUrl + data.profileImage;
            }
          }
          // return _profileForm(context, profileBloc);
          return _viewBuilder(profileBloc, clubBloc, profileImageUrl);
        } else {
          return Center(
              child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(colours.bodyTextColour())));
        }
      },
    );
  }

  Widget _viewBuilder(
      ProfileBloc profileBloc, ClubBloc clubBloc, String profileImageUrl) {
    return StreamBuilder(
      stream: profileBloc.clubId,
      builder: (clubContext, clubSnapshot) {
        if (clubSnapshot.hasData) {
          String clubId = clubSnapshot.data;
          return FutureBuilder(
            future: clubBloc.fetchClubInfo(clubId),
            builder: (clubInfoContext,
                AsyncSnapshot<ClubDataModal> clubInfoSnapshot) {
              // print('Club info has data ${clubInfoSnapshot.hasData}');
              if (clubInfoSnapshot.hasData) {
                return _profileForm(
                    context,
                    profileBloc,
                    profileImageUrl,
                    clubInfoSnapshot.data.schools,
                    clubInfoSnapshot.data.yearSchools);
              } else {
                return Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            colours.bodyTextColour())));
              }
            },
          );
        } else {
          return Center(
              child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(colours.bodyTextColour())));
        }
      },
    );
    /*return FutureBuilder(
      future: clubBloc.fetchClubInfo(clubId),
      builder:
          (clubInfoContext, AsyncSnapshot<ClubDataModal> clubInfoSnapshot) {
        // print('Club info has data ${clubInfoSnapshot.hasData}');
        if (clubInfoSnapshot.hasData) {
          return _registerForm(context, profileBloc,
              clubInfoSnapshot.data.schools, clubInfoSnapshot.data.yearSchools);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );*/
  }

  Widget _profileForm(
      BuildContext context,
      ProfileBloc profileBloc,
      String profileImageUrl,
      List<ClubSchoolModal> schools,
      List<ClubSchoolYearModal> years) {
    // Widget _profileForm(BuildContext context, ProfileBloc profileBloc) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Space(verticle: 20),
            _icon(profileBloc, profileImageUrl),
            Space(verticle: 10),
            _emailField(profileBloc),
            Space(verticle: 10),
            _passwordField(context, profileBloc),
            Space(verticle: 10),
            _firstNameField(profileBloc),
            Space(verticle: 10),
            _lastNameField(profileBloc),
            Space(verticle: 10),
            _mobileField(profileBloc),
            Space(verticle: 10),
            _genderField(profileBloc),
            Space(verticle: 20),
            Text('School',
                style: TextStyle(fontFamily: Constants.FONT_FAMILY_FUTURA)),
            _schoolsDropDownBuilder(context, profileBloc, schools),
            _schoolOthers(profileBloc),
            Space(verticle: 20),
            Text('I am a...',
                style: TextStyle(fontFamily: Constants.FONT_FAMILY_FUTURA)),
            _schoolYearsDropDownBuilder(context, profileBloc, years),
            _schoolYearOthers(profileBloc),
            Space(verticle: 20),
            _updateButton(context, profileBloc),
            Space(verticle: 50),
          ],
        ),
      ),
    );
  }

  Widget _icon(ProfileBloc profileBloc, String profileImageUrl) {
    final double imageSize = 70;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          StreamBuilder(
            stream: profileBloc.iconPath,
            builder: (iconContext, snapshot) {
              if (snapshot.hasData) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(imageSize / 2),
                  child: Image.file(
                    File(snapshot.data),
                    height: imageSize,
                    width: imageSize,
                    fit: BoxFit.cover,
                  ),
                );
              } else if (profileImageUrl != null) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(imageSize / 2),
                  child: Image.network(
                    profileImageUrl,
                    fit: BoxFit.cover,
                    width: imageSize,
                    height: imageSize,
                  ),
                );
              }
              return Icon(Icons.account_circle_outlined, size: imageSize);
            },
          ),
          TextButton(
            onPressed: () {
              pickImageOption(profileBloc);
            },
            child: Text(
              'Change profile Picture',
              style: TextStyle(
                fontFamily: Constants.FONT_FAMILY_FUTURA,
                color: colours.headlineColour(),
              ),
            ),
          )
        ],
      ),
    );
  }

  void pickImageOption(ProfileBloc profileBloc) {
    showDialog(
      context: context,
      builder: (BuildContext cntxt) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
            height: 250,
            padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose Option',
                  style: TextStyle(
                    fontFamily: Constants.FONT_FAMILY_FUTURA,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Space(verticle: 20),
                TextButton(
                  onPressed: () {
                    pickImage(profileBloc, ImageSource.camera);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Camera',
                    style: TextStyle(
                      fontFamily: Constants.FONT_FAMILY_FUTURA,
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Space(verticle: 15),
                TextButton(
                  onPressed: () {
                    pickImage(profileBloc, ImageSource.gallery);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Gallery',
                    style: TextStyle(
                      fontFamily: Constants.FONT_FAMILY_FUTURA,
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Space(verticle: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontFamily: Constants.FONT_FAMILY_FUTURA,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void pickImage(ProfileBloc profileBloc, ImageSource source) async {
    try {
      PickedFile pickedFile =
          await ImagePicker().getImage(source: source, imageQuality: 20);
      if (pickedFile == null) {
        return;
      }
      // print('The file');
      //print(pickedFile.path);
      File file = File(pickedFile.path);
      // print(file.path);
      // profileBloc.changeMakeUpdates(true);
      // profileBloc.changeIconPath(file.path);
      //update(file.path);
      // print('File length');
      // print(await file.length());

      File cropFile = await ImageCropper.cropImage(
        sourcePath: file.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      );
      profileBloc.changeMakeUpdates(true);
      profileBloc.changeIconPath(cropFile.path);
    } catch (e) {
      print('The exception');
      print(e);
    }
  }

  Widget _emailField(ProfileBloc profileBloc) {
    return Stack(
      children: [
        StreamBuilder(
          stream: profileBloc.email,
          builder: (context, snapshot) {
            final controller = TextEditingController();
            controller.text = snapshot.data;
            // controller.value = controller.value.copyWith(text: snapshot.data);
            controller.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length));
            return TextField(
              controller: controller,
              enabled: false,
              autocorrect: false,
              enableSuggestions: false,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(fontFamily: Constants.FONT_FAMILY_FUTURA),
              decoration: InputDecoration(
                hintText: 'you@example.com',
                labelText: 'Email',
                errorText: snapshot.error,
              ),
              //onChanged: profileBloc.changeEmail,
            );
          },
        ),
        // Container(
        //   color: Colors.transparent,
        //   height: 60,
        //   width: size.width - 40,
        // )
      ],
    );
  }

  Widget _passwordField(BuildContext context, ProfileBloc profileBloc) {
    Size size = MediaQuery.of(context).size;
    final controller = TextEditingController();
    controller.text = 'password';
    // controller.value = controller.value.copyWith(text: snapshot.data);
    controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length));
    return Stack(
      children: [
        TextField(
          enabled: false,
          controller: controller,
          autocorrect: false,
          enableSuggestions: false,
          obscureText: true,
          style: TextStyle(fontFamily: Constants.FONT_FAMILY_FUTURA),
          decoration: InputDecoration(
            hintText: 'password',
            labelText: 'Password',
          ),
        ),
        GestureDetector(
          child: Container(
            color: Colors.transparent,
            height: 60,
            width: size.width - 40,
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        ChangePasswordProvider(child: ChangePasswordScreen())));
          },
        )
      ],
    );
  }

  Widget _firstNameField(ProfileBloc profileBloc) {
    return StreamBuilder(
      stream: profileBloc.firstName,
      builder: (context, snapshot) {
        final controller = TextEditingController();
        controller.text = snapshot.data;
        // controller.value = controller.value.copyWith(text: snapshot.data);
        controller.selection = TextSelection.fromPosition(
            TextPosition(offset: controller.text.length));
        return TextField(
          controller: controller,
          autocorrect: false,
          enableSuggestions: false,
          textCapitalization: TextCapitalization.words,
          style: TextStyle(fontFamily: Constants.FONT_FAMILY_FUTURA),
          decoration: InputDecoration(
            hintText: 'Enter your first name',
            labelText: 'First name',
            errorText: snapshot.error,
          ),
          onChanged: (text) {
            profileBloc.changeMakeUpdates(true);
            profileBloc.changeFirstName(text);
          },
        );
      },
    );
  }

  Widget _lastNameField(ProfileBloc profileBloc) {
    return StreamBuilder(
      stream: profileBloc.lastName,
      builder: (context, snapshot) {
        final controller = TextEditingController();
        controller.text = snapshot.data;
        // controller.value = controller.value.copyWith(text: snapshot.data);
        controller.selection = TextSelection.fromPosition(
            TextPosition(offset: controller.text.length));
        return TextField(
          controller: controller,
          autocorrect: false,
          enableSuggestions: false,
          textCapitalization: TextCapitalization.words,
          style: TextStyle(fontFamily: Constants.FONT_FAMILY_FUTURA),
          decoration: InputDecoration(
            hintText: 'Enter your last name',
            labelText: 'Last name',
            errorText: snapshot.error,
          ),
          onChanged: (text) {
            profileBloc.changeMakeUpdates(true);
            profileBloc.changeLastName(text);
          },
        );
      },
    );
  }

  Widget _mobileField(ProfileBloc profileBloc) {
    return StreamBuilder(
      stream: profileBloc.mobile,
      builder: (context, snapshot) {
        final controller = TextEditingController();
        controller.text = snapshot.data;
        // controller.value = controller.value.copyWith(text: snapshot.data);
        controller.selection = TextSelection.fromPosition(
            TextPosition(offset: controller.text.length));
        return TextField(
          controller: controller,
          autocorrect: false,
          enableSuggestions: false,
          keyboardType: TextInputType.phone,
          style: TextStyle(fontFamily: Constants.FONT_FAMILY_FUTURA),
          decoration: InputDecoration(
            hintText: 'Enter Mobile Number',
            labelText: 'Mobile Number',
            errorText: snapshot.error,
          ),
          onChanged: (text) {
            profileBloc.changeMakeUpdates(true);
            profileBloc.changeMobile(text);
          },
        );
      },
    );
  }

  Widget _genderField(ProfileBloc profileBloc) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        StreamBuilder(
          stream: profileBloc.gender,
          builder: (context, snapshot) {
            final controller = TextEditingController();
            controller.text = snapshot.data;
            // controller.value = controller.value.copyWith(text: snapshot.data);
            controller.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length));
            return TextField(
              enabled: false,
              controller: controller,
              autocorrect: false,
              enableSuggestions: false,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(fontFamily: Constants.FONT_FAMILY_FUTURA),
              decoration: InputDecoration(
                hintText: '',
                labelText: 'Gender',
                errorText: snapshot.error,
              ),
              // onChanged: profileBloc.changeGender,
            );
          },
        ),
        Container(
          color: Colors.transparent,
          height: 60,
          width: size.width - 40,
        )
      ],
    );
  }

  Widget _schoolsDropDownBuilder(BuildContext context, ProfileBloc profileBloc,
      List<ClubSchoolModal> schools) {
    return StreamBuilder(
      stream: profileBloc.school,
      builder: (schoolContext, snapshot) {
        if (snapshot.hasData) {
          var v = snapshot.data;
          profileBloc.changeSchoolOthers((v == 'Other') ? '' : null);
        }
        return DropdownButton<String>(
          isExpanded: true,
          style: TextStyle(
              fontFamily: Constants.FONT_FAMILY_FUTURA, color: Colors.black),
          value: profileBloc.schoolValue(),
          items: schools.map((ClubSchoolModal club) {
            return new DropdownMenuItem<String>(
              value: club.title,
              child: new Text(club.title),
            );
          }).toList(),
          onChanged: (value) {
            String val = (value.toLowerCase() == 'other') ? '' : null;
            // print('school dropdown');
            // print(val);
            profileBloc.changeSchoolOthers((value == 'Other') ? '' : null);
            profileBloc.changeSchool(value);
            profileBloc.changeMakeUpdates(true);
          },
          onTap: () {
            FocusScope.of(context).unfocus();
          },
        );
      },
    );
  }

  Widget _schoolOthers(ProfileBloc profileBloc) {
    return StreamBuilder(
      stream: profileBloc.schoolOthers,
      builder: (context, snapshot) {
        // print('Other');
        // print(snapshot.data);
        if (snapshot.hasData) {
          final controller = TextEditingController();
          controller.text = snapshot.data;
          controller.selection = TextSelection.fromPosition(
              TextPosition(offset: controller.text.length));
          return TextField(
            controller: controller,
            autocorrect: false,
            enableSuggestions: false,
            style: TextStyle(fontFamily: Constants.FONT_FAMILY_FUTURA),
            decoration: InputDecoration(
              hintText: 'Enter School Name',
              labelText: 'School/Others',
              errorText: snapshot.error,
            ),
            onChanged: (text) {
              profileBloc.changeMakeUpdates(true);
              profileBloc.changeSchoolOthers(text);
            },
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _schoolYearsDropDownBuilder(BuildContext context,
      ProfileBloc profileBloc, List<ClubSchoolYearModal> years) {
    return StreamBuilder(
      stream: profileBloc.schoolYear,
      builder: (schoolContext, snapshot) {
        if (snapshot.hasData) {
          var v = snapshot.data;
          profileBloc.changeSchoolYearOthers((v == 'Other') ? '' : null);
        }
        return DropdownButton<String>(
          isExpanded: true,
          style: TextStyle(
              fontFamily: Constants.FONT_FAMILY_FUTURA, color: Colors.black),
          value: profileBloc.schoolYearValue(),
          items: years.map((ClubSchoolYearModal year) {
            return new DropdownMenuItem<String>(
              value: year.title,
              child: new Text(year.title),
            );
          }).toList(),
          onChanged: (value) {
            profileBloc.changeSchoolYearOthers((value == 'Other') ? '' : null);
            profileBloc.changeSchoolYear(value);
            profileBloc.changeMakeUpdates(true);
          },
          onTap: () {
            FocusScope.of(context).unfocus();
          },
        );
      },
    );
  }

  Widget _schoolYearOthers(ProfileBloc profileBloc) {
    return StreamBuilder(
      stream: profileBloc.schoolYearOthers,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final controller = TextEditingController();
          controller.text = snapshot.data;
          controller.selection = TextSelection.fromPosition(
              TextPosition(offset: controller.text.length));
          return TextField(
            controller: controller,
            autocorrect: false,
            enableSuggestions: false,
            style: TextStyle(fontFamily: Constants.FONT_FAMILY_FUTURA),
            decoration: InputDecoration(
              hintText: 'Fill in your current year in school or status',
              labelText: 'Year in school/Status',
              errorText: snapshot.error,
            ),
            onChanged: (text) {
              profileBloc.changeMakeUpdates(true);
              profileBloc.changeSchoolYearOthers(text);
            },
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _updateButton(BuildContext context, ProfileBloc profileBloc) {
    return ElevatedButton(
      child: Text(
        'Update',
        style: TextStyle(
          fontFamily: Constants.FONT_FAMILY_FUTURA,
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: colours.headlineColour(),
        minimumSize: Size.fromHeight(40),
      ),
      onPressed: () {
        FocusScope.of(context).unfocus();
        _performUpdate(context, profileBloc);
      },
    );
  }

  /*Widget _updateButton(BuildContext context, ProfileBloc profileBloc) {
    return Container(
      width: double.infinity,
      child: StreamBuilder(
        stream: profileBloc.makeUpdates,
        builder: (submitContext, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data) {
              return ElevatedButton(
                child: Text(
                  'Update',
                  style: TextStyle(
                    fontFamily: Constants.FONT_FAMILY_FUTURA,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: colours.headlineColour(),
                  minimumSize: Size.fromHeight(40),
                ),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  _performUpdate(context, profileBloc);
                },
              );
            } else {
              return Container();
            }
          } else {
            return Container();
          }
        },
      ),
    );
  }*/

  void _performUpdate(BuildContext context, ProfileBloc profileBloc) async {
    Loader.showLoading(context);
    final res = await profileBloc.updateProfile();
    Navigator.pop(context);
    if (res is ErrorResponseModel) {
      Alert.defaultAlert(context, 'Register', res.message);
      // } else if (res is UserModal) {
      //   if (res != null) {
      //     await DataStore().saveUser(res);
      //   } else {
      //     Alert.defaultAlert(context, 'Error', 'Failed to Update.');
      //   }
    } else if (res is String) {
      Alert.defaultAlert(context, 'Success', res, okAction: () {
        Navigator.pop(context);
      });
    } else {
      Alert.defaultAlert(context, 'Error', 'Try later.');
    }
  }
}
