import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Alert {
  static defaultAlert(BuildContext context, String title, String msg,
      {Function okAction}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (cntxt) {
        return CupertinoAlertDialog(
          title: Text('$title\n'),
          content: Text(msg),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Ok'),
              // isDefaultAction: true,
              onPressed: () {
                // print('Ok pressed');
                //bloc.clear();
                Navigator.of(cntxt).pop();
                if (okAction != null) {
                  okAction();
                }
              },
            )
          ],
        );
      },
    );
  }

  static okCancel(BuildContext context, String title, String msg,
      {Function okAction}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (cntxt) {
        return CupertinoAlertDialog(
          title: Text('$title\n'),
          content: Text(msg),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Ok'),
              // isDefaultAction: true,
              onPressed: () {
                // print('Ok pressed');
                //bloc.clear();
                Navigator.of(cntxt).pop();
                if (okAction != null) {
                  okAction();
                }
              },
            ),
            CupertinoDialogAction(
              child: Text('Cancel'),
              // isDefaultAction: true,
              onPressed: () {
                // print('Ok pressed');
                //bloc.clear();
                Navigator.of(cntxt).pop();
              },
            )
          ],
        );
      },
    );
  }
}
