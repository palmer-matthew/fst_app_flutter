import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

/// An animated [IconButton] that uses an animation created in Rive (Flare).
class RiveIconButton extends StatefulWidget {
  /// The name of the Rive(Flare) file in assets.
  final String name;
  /// The name of the animation to play.
  final String animationName;
  /// The function that will be called whenever the button is pressed.
  final Function setStateFunction;

  /// This button requires the [name] of the Rive file, 
  /// [animationName] and [setStateFunction].
  RiveIconButton({
    Key key,
    @required this.name,
    @required this.animationName,
    @required this.setStateFunction,
  })  : assert(name != null),
        assert(animationName != null),
        assert(setStateFunction != null),
        super(key: key);

  @override
  _RiveIconButtonState createState() => _RiveIconButtonState();
}

class _RiveIconButtonState extends State<RiveIconButton> {
  String get name => widget.name;
  String get animationName => widget.animationName;
  Function get parentStateFunction => widget.setStateFunction;
  bool isOpen;
  bool isPressed;

  @override
  void initState() {
    super.initState();
    isOpen = false;
    isPressed = false;
  }

  /// Determines which animation should be played based on the state of the button.
  whichAnimation() {
    if (isPressed) {
      if (isOpen) {
        return animationName;
      } else {
        return animationName + '_reverse';
      }
    } else {
      return 'idle';
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.all(10.0),
      onPressed: () {
        setState(() {
          isOpen = !isOpen;
          isPressed = true;
          try {
            parentStateFunction();
          } catch (e) {}
        });
      },
      icon: FlareActor(
        'assets/rive/animated_icons/$name.flr',
        alignment: Alignment.center,
        animation: whichAnimation(),
      ),
    );
  }
}
