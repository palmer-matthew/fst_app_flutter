import 'package:flutter/material.dart';

/// A stateful version of the [PopupRoute] for the app preferences screen.
class StatefulPopupRoute extends PopupRoute {
  Widget page;

  StatefulPopupRoute({RouteSettings settings, this.page})
      : super(
          settings: settings,
        );

  @override
  Color get barrierColor => Colors.black54;

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => 'Stateful popup barrier';

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return page;
  }

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);
}
