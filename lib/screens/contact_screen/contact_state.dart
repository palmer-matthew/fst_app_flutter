import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fst_app_flutter/models/from_postgres/contact/contact_model.dart';
import 'package:fst_app_flutter/models/preferences/theme_model.dart';
import 'package:fst_app_flutter/routing/routes.dart';
import 'package:fst_app_flutter/screens/contact_screen/contact_view_stateful.dart';
import 'package:fst_app_flutter/services/handle_heroku_requests.dart';
import 'package:fst_app_flutter/utils/app_theme.dart';
import 'package:fst_app_flutter/widgets/animated_icons/rive_animated_icon_button.dart';
import 'package:fst_app_flutter/widgets/contact_widgets/contact_tile.dart';

/// The base class for all contact view states for different screen sizes and orientations.
abstract class ContactViewState extends State<ContactViewStateful>
    with TickerProviderStateMixin {
  /// This [String] will be modified to include the search value entered by the user.
  /// Otherwise, it will be passed to the [getResults] like this.
  var baseParam = 'contact/?search=';

  /// Extra parameters to attach to the [baseParam] such as department or type.
  var extraParam = '';

  /// The default categories to filter by and their corresponding
  /// query parameter and value.
  ///
  /// Used to construct the [filterDropdown]
  final List<dynamic> categories = [
    {'title': 'All', 'queryParam': '', 'value': ''},
    {'title': 'Emergency', 'queryParam': 'type', 'value': 'EMERGENCY'},
    {
      'title': 'Chemistry Department',
      'queryParam': 'department',
      'value': 'CHEM'
    },
    {
      'title': 'Computing Department',
      'queryParam': 'department',
      'value': 'COMP'
    },
    {
      'title': 'Geography and Geology Department',
      'queryParam': 'department',
      'value': 'GEO'
    },
    {
      'title': 'Life Sciences Department',
      'queryParam': 'department',
      'value': 'LIFE'
    },
    {
      'title': 'Mathematics Department',
      'queryParam': 'department',
      'value': 'MATH'
    },
    {
      'title': 'Physics Department',
      'queryParam': 'department',
      'value': 'PHYS'
    },
    {
      'title': 'Faculty Wide Contacts',
      'queryParam': 'department',
      'value': 'OTHER'
    },
    {'title': 'Other Contacts', 'queryParam': 'type', 'value': 'OTHER'},
  ];

  /// a list to store all contacts that were a returned from the query
  List<Contact> contacts = [];

  /// Currently selected dropdown item value. Allows for differential
  /// of text in the dropdown list for the item that is selected.
  String currentFilter = 'All';

  /// Used to switch between filters from [categories] in the [filterDropdown]
  /// function
  Icon filterIcon = Icon(Icons.filter_list, color: Colors.white);

  /// Used to switch the state of the appBar to a search field in the [revealSearchField]
  /// function.
  Widget appBarTitle = Text('Contacts');

  /// Returns the list to the position it was at before navigating to another route.
  ScrollController scrollController = ScrollController(keepScrollOffset: true);

  /// Controls the search text field.
  TextEditingController searchController;

  /// Color change sequence for app bar animation.
  Animatable<Color> appBarBgColor;

  /// Allows app bar leading icon to be removed and added in [revealSearchField]
  Widget appBarLeading = BackButton();

  /// Controller for animations related to the [filterDropdown] hiding when
  /// [revealSearchField] is called
  AnimationController dropdownController;

  /// Controller for animations related to the appBar changing from blue to white
  /// when [revealSearchField] is called.
  AnimationController appBarColorController;

  /// Whether or not all the actions are displayed on the appBar. This value is
  /// toggle in [revealSearchField].
  bool extraActions = true;

  ThemeModel themeModel;

  ContactViewState({@required this.themeModel});
  HerokuRequest<Contact> request;

  /// Load all contacts when page is loaded initially. Initilize animations and controllers.
  @override
  void initState() {
    super.initState();
    request = HerokuRequest();
    request
        .getResults('$baseParam$extraParam', true, (data) => Contact(data))
        .then((data) => contacts = data.toSet().toList());
    appBarColorController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    dropdownController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    searchController = TextEditingController();
    searchController.addListener(() {
      setState(() {
        baseParam = 'contact/?search=${searchController.value.text}';
        contacts.clear();
      });
    });
  }

  /// Dispose all disposable controllers.
  @override
  void dispose() {
    scrollController.dispose();
    appBarColorController.dispose();
    dropdownController.dispose();
    searchController.dispose();
    super.dispose();
  }

  /// Subclasses should implement
  @override
  Widget build(BuildContext context);

  /// Toggle dropdown button hiding animation.
  TickerFuture toggleFilterDropdownAnimation() => dropdownController.isDismissed
      ? dropdownController.forward()
      : dropdownController.reverse();

  /// Toggle appBar colour animation.
  TickerFuture toggleAppBarAnimation() => appBarColorController.isDismissed
      ? appBarColorController.forward()
      : appBarColorController.reverse();

  /// Toggles the [AppBar] between the page title and the search [TextField] and
  /// hiding the [filterDropdown].
  void revealSearchField({@required double searchFieldWidth}) {
    if (dropdownController.isDismissed) {
      toggleAppBarAnimation();
      toggleFilterDropdownAnimation().then((value) {
        appBarLeading = null;
        extraActions = false;
        appBarTitle = Container(
          width: searchFieldWidth,
          height: kToolbarHeight,
          child: TextField(
            enableSuggestions: true,
            autocorrect: true,
            autofocus: true,
            toolbarOptions: ToolbarOptions(paste: true),
            controller: searchController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search',
                filled: false,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                )),
          ),
        );
      });
    } else {
      toggleAppBarAnimation();
      extraActions = true;
      toggleFilterDropdownAnimation().then((value) {
        appBarLeading = BackButton();
        appBarTitle = Text('Contacts');
        baseParam = 'contact/?search=';
        contacts.clear();
        searchController.clear();
      });
    }
  } // revealSearchField

  /// Builds the app bar with specified [height], [elevation], [actions] and
  /// sets when [animationIntervalStart] and [animationIntervalEnd].
  Widget buildAppBarArea(
      {@required double height,
      @required double animationIntervalStart,
      @required double animationIntervalEnd,
      @required List<Widget> actions,
      @required double elevation}) {
    ThemeData theme = AppTheme.getTheme(themeModel.selectedTheme,
        SchedulerBinding.instance.window.platformBrightness);
    var opacity = (4.5 * math.log(4.0 + 1) + 2) / 100.0;
    var overlayColor = theme.colorScheme.onSurface.withOpacity(opacity);

    appBarBgColor = ColorTween(
        begin: themeModel.isDark
            ? Color.alphaBlend(overlayColor, theme.primaryColor)
            : theme.primaryColor,
        end: themeModel.isDark? Color.alphaBlend(overlayColor, theme.scaffoldBackgroundColor): theme.scaffoldBackgroundColor);
    return AnimatedBuilder(
      animation: appBarColorController,
      builder: (BuildContext context, Widget child) {
        return StatefulBuilder(
          builder: (BuildContext context,
              void Function(void Function()) changeState) {
            return Container(
              height: height,
              child: AppBar(
                automaticallyImplyLeading: false,
                leading: appBarLeading,
                elevation: elevation,
                actions: [
                  if (extraActions) ...actions else Container(),
                  RiveIconButton(
                    name: 'search_clear',
                    animationName:
                        themeModel.isDark ? 'white_to_white' : 'white_to_black',
                    setStateFunction: () {
                      this.revealSearchField(
                          searchFieldWidth: MediaQuery.of(context).size.width);
                    },
                  )
                ],
                centerTitle: false,
                backgroundColor: appBarBgColor.evaluate(CurvedAnimation(
                    parent: appBarColorController, curve: Curves.ease)),
                title: appBarTitle,
              ),
            );
          },
        );
      },
    );
  } // buildAppBarArea

  /// Drop down button to filter the list of [contacts] by [categories].
  /// It has [elevation] and its use of space is determined by whether or not
  /// it [isExpanded].
  filterDropdown(BuildContext context,
      {@required double height,
      @required double width,
      @required bool isExpanded,
      @required double elevation}) {
    return SlideTransition(
        position: Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(0.0, -1.0))
            .animate(CurvedAnimation(
                parent: dropdownController, curve: Curves.ease)),
        child: Card(
            margin: EdgeInsets.zero,
            elevation: elevation,
            child: PreferredSize(
                child: Container(
                    color: themeModel.isDark
                        ? ElevationOverlay.applyOverlay(
                            context, Theme.of(context).primaryColor, 4.0)
                        : Theme.of(context).accentColor,
                    height: height,
                    width: width,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.centerLeft,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                          selectedItemBuilder: (context) {
                            return categories
                                .map((e) => Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(e['title'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600)),
                                    ))
                                .toList();
                          },
                          isExpanded: isExpanded,
                          icon: filterIcon,
                          value: currentFilter,
                          items:
                              filterDropDownItemBuilder(context, width: width),
                          onChanged: (value) {
                            currentFilter = value;
                          }),
                    )),
                preferredSize: Size.fromHeight(height))));
  }

  /// Builds the  dropdown list for [filterDropdown] from [categories].
  List<DropdownMenuItem<dynamic>> filterDropDownItemBuilder(context,
      {@required double width}) {
    return List.generate(categories.length, (i) {
      return DropdownMenuItem(
        child: Container(
          alignment: Alignment.centerLeft,
          height: kMinInteractiveDimension,
          width: width,
          child: Text(
            categories[i]['title'],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: categories[i]['title'] == currentFilter
                ? TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.w800)
                : null,
          ),
        ),
        onTap: () {
          setState(
            () {
              extraParam =
                  '&${categories[i]['queryParam']}=${categories[i]['value']}';
            },
          );
        },
        value: categories[i]['title'],
      );
    });
  }

  /// Builds a [Positioned] [filterDropdown].
  ///
  /// The distance from the top of the screen will be [posFromTop].
  ///
  /// The drop down will be [height] tall and [width] wide.
  ///
  /// It will have an [elevation] and the space the dropdown
  /// uses will be determined by whether or not it [isExpanded].
  Widget buildFilterDropdownArea(BuildContext context,
      {@required double posFromTop,
      @required double height,
      @required double width,
      @required bool isExpanded,
      @required double elevation}) {
    return Positioned(
        top: posFromTop,
        child: filterDropdown(
          context,
          height: height,
          width: width,
          isExpanded: isExpanded,
          elevation: elevation,
        ));
  } // buildFilterDropdownArea

  /// Builds a [ListView] of [ContactTile] for each member
  /// in the list of [contacts]. [hasDecoration], [thickness], [subtitleStyle]
  /// and [titleStyle] determine the style of the [ContactTile].
  Widget buildContactListView(
      {@required List<Contact> contacts,
      TextStyle subtitleStyle,
      TextStyle titleStyle}) {
    return Scrollbar(
      controller: scrollController,
      child: ListView.builder(
          key: PageStorageKey('scrollPosition'),
          controller: scrollController,
          itemCount: contacts.length,
          semanticChildCount: contacts.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(children: [
              ContactTile(
                subtitleStyle: subtitleStyle,
                titleStyle: titleStyle,
                title: contacts[index].name,
                subtitle: contacts[index].description,
                namedRoute: contactDetailRoute,
                arguments: contacts[index],
              ),
              //Divider( thickness: 1.0,color: Theme.of(context).accentColor)
            ]);
          }),
    );
  } // buildContactCard

  /// Displays a [CircularProgressIndicator] while the list of contacts is fectched
  /// by [getResults] and built by [buildContactListView].
  /// Also displays message indicating that no matches were found if
  /// no matches were found and an error message if an error occured.
  Widget contactFutureBuilder(
      {@required double padH,
      @required double padV,
      @required double height,
      @required double width,
      TextStyle subtitleStyle,
      TextStyle titleStyle}) {
    return Container(
        height: height,
        width: width,
        padding: EdgeInsets.fromLTRB(padH, padV, padH, padV),
        child: Column(
            mainAxisSize: MainAxisSize.max,
            verticalDirection: VerticalDirection.down,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  child: FutureBuilder(
                initialData: contacts,
                future: request.getResults(
                    '$baseParam$extraParam', true, (data) => Contact(data)),
                builder: (context, snapshot) {
                  var mq = MediaQuery.of(context);
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return RefreshIndicator(
                        onRefresh: () {
                          return request
                              .getResults('$baseParam$extraParam', true,
                                  (data) => Contact(data))
                              .then((value) {
                            setState(() {
                              contacts = value;
                            });
                          });
                        },
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  child: Center(
                                      child: Text(
                                    'No connection specified.',
                                    textAlign: TextAlign.center,
                                  )),
                                ),
                              ),
                            ]),
                      );
                      break;
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                      break;
                    case ConnectionState.active:
                      return Center(child: CircularProgressIndicator());
                      break;
                    case ConnectionState.done:
                      if (snapshot.hasData) {
                        contacts = snapshot.data.toSet().toList();
                        if (contacts.length > 0) {
                          return buildContactListView(
                            titleStyle: titleStyle,
                            subtitleStyle: subtitleStyle,
                            contacts: contacts,
                          );
                        } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(child: SvgPicture.asset(themeModel.isDark? 'assets/undraw_no_data_qbuo_dark.svg':'assets/undraw_no_data_qbuo.svg' ,height: mq.size.height/3.5,)),
                            Flexible(child: Text("No matches"))
                          ],
                        );

                        }
                      } else if (!snapshot.hasData || snapshot.hasError) {
                        return RefreshIndicator(
                          onRefresh: () {
                            return request
                                .getResults('$baseParam$extraParam', true,
                                    (data) => Contact(data))
                                .then((value) {
                              setState(() {
                                contacts = value;
                              });
                            });
                          },
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    child: Center(
                                        child: Text(
                                      'Cannot load contacts. Check your internet connection.',
                                      textAlign: TextAlign.center,
                                    )),
                                  ),
                                ),
                              ]),
                        );
                      } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(child: SvgPicture.asset(themeModel.isDark? 'assets/undraw_no_data_qbuo_dark.svg':'assets/undraw_no_data_qbuo.svg' ,height: mq.size.height/3.5,)),
                            Flexible(child: Text("No matches"))
                          ],
                        );
                      }
                      break;
                  }
                  return Container();
                },
              ))
            ]));
  } // contactFutureBuilder

  /// Builds a [Positioned] contact list using [contactFutureBuilder].
  ///
  /// Its base height is [height] and base width is [width].
  ///
  /// This list moves/resizes when [revealSearchField] is called.
  ///
  /// The trigger and duration of the the animation is controlled by [controller].
  ///
  /// At the start of the animation the list will be a distance of [posFromTop]
  /// from the top of the screen. [posFromLeft] is the distance from the left
  /// of the screen. [posFromRight] is the distance from the right of the screen.
  /// [posFromBottom] is the distance from the bottom of the screen.
  ///
  /// At the end of the animation, the list will be a distance of [growTop] from the
  /// top of the screen. [growLeft], [growRight] and [growBottom] are the left, right
  /// and bottom distances respectively.
  ///
  /// The amount of padding on the left and right of the list will be [padH] and the padding
  /// at the top and bottom will be [padV].
  ///
  /// The title on each [ContactTile] will have a [titleStyle] and the subtitle
  /// will have a [subtitleStyle].
  ///
  /// The line between each [ContactTile] will be [thickness] in width if [isDecorated] is true.
  ///
  Widget buildMovingContactListArea({
    @required double posFromTop,
    @required double posFromLeft,
    @required double posFromRight,
    @required double posFromBottom,
    @required double growTop,
    @required double growLeft,
    @required double growRight,
    @required double growBottom,
    @required AnimationController controller,
    @required double height,
    @required double width,
    @required double padH,
    @required double padV,
    TextStyle titleStyle,
    TextStyle subtitleStyle,
  }) {
    return PositionedTransition(
        rect: RelativeRectTween(
                begin: RelativeRect.fromLTRB(
                    posFromLeft, posFromTop, posFromRight, posFromBottom),
                end: RelativeRect.fromLTRB(
                    growLeft, growTop, growRight, growBottom))
            .animate(CurvedAnimation(parent: controller, curve: Curves.ease)),
        child: contactFutureBuilder(
          titleStyle: titleStyle,
          subtitleStyle: subtitleStyle,
          height: height,
          padH: padH,
          padV: padV,
          width: width,
        ));
  } // buildMovingContactListArea

  /// Similar to [buildMovingContactListArea] except that this list area builder does
  /// not have any animated movement and no parameters to control an animation.
  ///
  /// [posFromTop] and [posFromLeft] are the only necessary positioning.
  Widget buildFixedContactListArea({
    @required double posFromTop,
    @required double height,
    @required double width,
    @required double padH,
    @required double padV,
    @required double posFromLeft,
    TextStyle titleStyle,
    TextStyle subtitleStyle,
  }) {
    return Positioned(
        top: posFromTop,
        left: posFromLeft,
        child: contactFutureBuilder(
          titleStyle: titleStyle,
          subtitleStyle: subtitleStyle,
          height: height,
          padH: padH,
          padV: padV,
          width: width,
        ));
  } // buildStaticContactListArea

} // ContactViewState
