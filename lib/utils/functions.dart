import 'package:flutter/material.dart';
import 'package:noteapp/utils/constants.dart';

void pop(context) {
  Navigator.of(context).pop();
}

void push({@required BuildContext context, @required String route}) {
  if (route == "" || route == null) push(context: context, route: kErrorLink);
  Navigator.of(context).pushNamed(route);
}

void resetRoute(BuildContext context) {
  Navigator.of(context).popUntil((route) => route.isFirst);
}

void showAlert({
  @required BuildContext context,
  title,
  @required body,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title ?? kAppName,
          style: TextStyle(
            color: Colors.red,
          )),
      content: Text(body),
      actions: <Widget>[
        FlatButton(
          onPressed: () =>
              Navigator.of(context, rootNavigator: true).pop('dialog'),
          child: Icon(Icons.block),
        ),
      ],
    ),
  );
}

void showSnack({BuildContext context, String content}) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(content),
  ));
}
