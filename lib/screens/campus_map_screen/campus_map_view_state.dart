import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fst_app_flutter/models/enums/department.dart';
import 'package:fst_app_flutter/models/from_postgres/map/campus_map.dart';
import 'package:fst_app_flutter/models/from_postgres/map/geo_json_objects/feature_collection.dart';
import 'package:fst_app_flutter/models/from_postgres/map/geo_json_objects/geo_json_type.dart';
import 'package:fst_app_flutter/models/from_postgres/map/properties.dart';
import 'package:fst_app_flutter/models/preferences/theme_model.dart';
import 'package:fst_app_flutter/screens/campus_map_screen/campus_map_view_stateful.dart';
import 'package:fst_app_flutter/utils/app_theme.dart';
import 'package:fst_app_flutter/utils/permissions.dart';
import 'package:fst_app_flutter/widgets/map_widgets/data_window.dart';
import 'package:fst_app_flutter/widgets/shape_borders/arrowed_tooltip.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class CampusMapViewState extends State<CampusMapViewStateful>
    with TickerProviderStateMixin {
  Set<Polygon> polygons = {};
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  Completer<GoogleMapController> _controller = Completer();

  final ThemeModel themeModel;

  Properties currentInfo;
  bool isFeatureSelected;
  Color appbarColor;
  Tween<double> sizeAnimation;
  ColorTween appBarOpacity;

  var leading;

  AnimationController dataWindowController;

  AnimationController appBarOpacityController;

  CampusMapViewState(this.themeModel);

  @override
  Widget build(BuildContext context) {
    requestPermission(Permission.locationWhenInUse);
    return buildGoogleMap();
  }

  Widget buildAppBar(BuildContext context) {
    return AnimatedBuilder(
        animation: appBarOpacityController,
        builder: (BuildContext context, Widget child) {
          return Container(
              height: kToolbarHeight + MediaQuery.of(context).padding.top,
              alignment: Alignment.center,
              child: AppBar(
                automaticallyImplyLeading: false,
                leading: isFeatureSelected
                    ? IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            isFeatureSelected = false;
                            hideDataWindow();
                            makeAppBarTranslucent();
                          });
                        })
                    : BackButton(),
                centerTitle: false,
                title:
                    isFeatureSelected ? Text(currentInfo.title) : Text('Map'),
                backgroundColor: appBarOpacity.evaluate(CurvedAnimation(
                    parent: appBarOpacityController, curve: Curves.ease)),
              ));
        });
  }

  Widget buildGoogleMap() {
    return FutureBuilder(
      future: insertMapFeatures(),
      builder: (context, snapshot) => GoogleMap(
        myLocationButtonEnabled: true,
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + kToolbarHeight),
        buildingsEnabled: true,
        markers: markers,
        initialCameraPosition:
            CameraPosition(target: LatLng(18.005208, -76.750198), zoom: 17.5),
        mapType: MapType.satellite,
        compassEnabled: true,
        myLocationEnabled: true,
        onMapCreated: (controller) {
          _controller.complete(controller);
          setState(() {});
        },
        rotateGesturesEnabled: true,
        scrollGesturesEnabled: !isFeatureSelected,
        trafficEnabled: false,
        zoomGesturesEnabled: true,
        mapToolbarEnabled: true,
        polygons: polygons,
        polylines: polylines,
      ),
    );
  }

  Positioned buildPositionedDataWindow(
      BuildContext context, ArrowedTooltip shape) {
    return Positioned(
        top: MediaQuery.of(context).padding.top + kToolbarHeight,
        child: AnimatedOpacity(
            opacity: isFeatureSelected ? 1.0 : 0.0,
            duration: Duration(milliseconds: 700),
            child: SizeTransition(
              axis: shape is DownArrowTooltip? Axis.vertical : Axis.horizontal,
              sizeFactor: sizeAnimation.animate(CurvedAnimation(
                  parent: dataWindowController, curve: Curves.ease)),
              child: DataWindow(
                properties: currentInfo,
                shape: shape,
              ),
            )));
  }

  @override
  void dispose() {
    dataWindowController.dispose();
    appBarOpacityController.dispose();
    super.dispose();
  }

  Set<Polyline> extractLineStringsToGoogleMaps(FeatureCollection col) {
    return col.features
        .where((feature) =>
            feature.geometry.type == GeoJsonType.lineString)
        .map((e) => Polyline(
              polylineId: PolylineId('${e.id}'),
              color: e.properties.associatedWith.departmentColour.withAlpha(90),
              jointType: JointType.round,
              endCap: Cap.roundCap,
              startCap: Cap.roundCap,
              width: 10,
              points: e.geometry.extractLatLng(),
            ))
        .toSet();
  }

  Set<Marker> extractPointsToGoogleMaps(FeatureCollection col) {
    return col.features
        .where((feature) => feature.geometry.type == GeoJsonType.point)
        .map((e) => Marker(
            flat: true,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure),
            onDragEnd: (value) {},
            markerId: MarkerId('${e.id}'),
            onTap: () {
              setState(() {
                makeAppBarOpaque();
                currentInfo = e.properties;
                isFeatureSelected = true;
                showDataWindow();
              });
            },
            draggable: false,
            position: e.geometry.extractLatLng()[0],
            alpha: 0.8))
        .toSet();
  }

  Set<Polygon> extractPolygonsToGoogleMaps(FeatureCollection col) {
    return col.features
        .where(
            (feature) => feature.geometry.type == GeoJsonType.polygon)
        .map((e) => Polygon(
            polygonId: PolygonId('${e.id}'),
            fillColor:
                e.properties.associatedWith.departmentColour.withAlpha(70),
            strokeWidth: 1,
            strokeColor:
                e.properties.associatedWith.departmentColour.withAlpha(70),
            points: e.geometry.extractLatLng()))
        .toSet();
  }

  TickerFuture hideDataWindow() => dataWindowController.reverse();

  @override
  void initState() {
    super.initState();
    isFeatureSelected = false;
    currentInfo = Properties();
    leading = BackButton();
    sizeAnimation = Tween(begin: 0.0, end: 1.0);
    dataWindowController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    appBarOpacityController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    appBarOpacity = ColorTween(
        begin: AppTheme.getFromModel(themeModel).primaryColor.withAlpha(70),
        end: AppTheme.getFromModel(themeModel).primaryColor);
  }

  insertMapFeatures() async {
    await CampusMap.locations.then((features) {
      polygons = extractPolygonsToGoogleMaps(features) ?? {};
      markers = extractPointsToGoogleMaps(features) ?? {};
      polylines = extractLineStringsToGoogleMaps(features) ?? {};
    });
  }

  TickerFuture makeAppBarOpaque() => appBarOpacityController.forward();

  TickerFuture makeAppBarTranslucent() => appBarOpacityController.reverse();

  TickerFuture showDataWindow() => dataWindowController.forward();
}
