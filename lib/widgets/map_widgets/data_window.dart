import 'package:flutter/material.dart';
import 'package:fst_app_flutter/models/from_postgres/map/properties.dart';
import 'package:fst_app_flutter/widgets/shape_borders/arrowed_tooltip.dart';

/// A window that displays the [Feature] data for the corresponding [Marker] when tapped.
class DataWindow extends StatefulWidget {
  /// The [Feature] [Properties].
  final Properties properties;
  /// The window's shape.
  final ArrowedTooltip shape;
  DataWindow({Key key, @required this.properties, @required this.shape})
      : super(key: key);

  @override
  DataWindowState createState() => DataWindowState();
}

class DataWindowState extends State<DataWindow> {
  Properties get properties => widget.properties;
  ArrowedTooltip get shape => widget.shape;

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context);
    var fullHeight = shape is DownArrowTooltip
        ? (mq.size.height / 2) - mq.padding.top - kToolbarHeight - 10.0
        : mq.size.height - mq.padding.top - kToolbarHeight;

    var fullWidth =
        shape is DownArrowTooltip ? mq.size.width : (mq.size.width / 2) - 10.0;
    return Container(
      height: fullHeight,
      width: fullWidth,
      child: Material(
        child: Padding(
          padding: shape is DownArrowTooltip
              ? EdgeInsets.only(
                  top: 24.0,
                  bottom: shape.arrowLength + 24.0,
                  left: 24.0,
                  right: 24.0)
              : EdgeInsets.only(
                  top: 24.0,
                  bottom: 24.0,
                  left: 24.0,
                  right: shape.arrowLength + 24.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              properties?.description?.isEmpty ?? false
                  ? Container()
                  : ListTile(
                      title: Text('Description'),
                      subtitle: Text(properties?.description ?? ''),
                    ),
              properties?.altName?.isEmpty ?? false
                  ? ListTile(
                      title: Text('Alternate name(s)'), subtitle: Text('None'))
                  : ListTile(
                      title: Text('Alternate name'),
                      subtitle: Text(properties?.altName ?? ''),
                    ),
            ],
          ),
        ),
        elevation: 2.0,
        shape: shape,
      ),
    );
  }
}
