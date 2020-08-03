import 'package:flutter/material.dart';
import 'package:fst_app_flutter/services/handle_heroku_requests.dart';
import 'package:fst_app_flutter/widgets/contact_tile.dart';
import 'package:fst_app_flutter/routing/routes.dart';
import 'contact_view_stateful.dart';

abstract class ContactViewState extends State<ContactViewStateful>
    with TickerProviderStateMixin {
  /// This [String] will be modified to include the search value entered by the user.
  /// Otherwise, it will be passed to the [getResultsJSON] like this.
  var baseParam = 'contact/?search=';

  /// Extra parameters to attach to the [baseParam] such as department or type.
  var extraParam = '';

  /// The default categories to filter by and their corresponding
  /// query parameter and value.
  ///
  /// Used to construct the [filterDropDown]
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
  List<dynamic> contacts = [];

  /// Currently selected dropdown item value. Allows for differential
  /// of text in the dropdown list for the item that is selected.
  var dropdownValue = 'All';

  /// Used to switch the state of the appBar to a search field in the [revealSearchField]
  /// function.
  Icon searchIcon = Icon(Icons.search);

  /// Used to switch between filters from [categories] in the [filterDropDown]
  /// function
  Icon filterIcon = Icon(Icons.filter_list, color: Colors.white);

  /// Used to switch the state of the appBar to a search field in the [revealSearchField]
  /// function.
  Widget appBarTitle = Text('Contacts');

  /// Returns the list to the position it was at before navigatimg to another route.
  ScrollController sc = ScrollController(keepScrollOffset: true);

  /// Controller for dropdown sliding animation.
  AnimationController ac;

  /// Controls the search text field.
  TextEditingController tec;

  /// Color change sequence for app bar animation.
  Animatable<Color> appBarBgColor;

  /// Allows app bar leading icon to be removed and added in [revealSearchField]
  Widget appBarLeading = BackButton();

  bool searchButtonPressed;
  bool drawerPressed;

  /// Load all contacts when page is loaded initially. Initilize animations and controllers.
  @override
  void initState() {
    super.initState();
    getResultsJSON('$baseParam$extraParam')
        .then((data) => contacts = data.toSet().toList());
    ac = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    appBarBgColor = TweenSequence([
      TweenSequenceItem(
          tween: ColorTween(
              begin: Color.fromRGBO(0, 62, 138, 1.0), end: Colors.blue[800]),
          weight: 1.0),
      TweenSequenceItem(
          tween: ColorTween(begin: Colors.blue[800], end: Colors.white),
          weight: 0.5)
    ]);
    tec = TextEditingController();
    tec.addListener(() {
      setState(() {
        baseParam = 'contact/?search=${tec.value.text}';
        contacts.clear();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    sc.dispose();
    ac.dispose();
    tec.dispose();
  }

  /// Subclasses should implement
  @override
  Widget build(BuildContext context);

  Widget buildAppBarArea(
      {@required double height,
      @required double animationIntervalStart,
      @required double animationIntervalEnd,
      @required List<Widget> actions,
      @required double elevation}) {
    return Container(
      height: height,
      child: AppBar(
        automaticallyImplyLeading: false,
        leading: appBarLeading,
        elevation: elevation,
        actions: actions,
        centerTitle: false,
        backgroundColor: appBarBgColor.evaluate(CurvedAnimation(
            parent: ac,
            curve: Interval(animationIntervalStart, animationIntervalEnd,
                curve: Curves.ease))),
        title: appBarTitle,
      ),
    );
  }

  Widget buildFilterDropdownArea(BuildContext context,
      {@required double slideDist,
      @required double posFromTop,
      @required double height,
      @required double width,
      @required bool isExpanded,
      @required double elevation}) {
    return Positioned(
        top: posFromTop,
        child: filterDropDown(context,
            height: height,
            width: width,
            isExpanded: isExpanded,
            elevation: elevation,
            slideDist: slideDist));
  }

  Widget buildContactListArea(
      {@required double posFromTop,
      @required double slideDist,
      @required double height,
      @required double width,
      @required double padH,
      @required double padV,
      @required posFromLeft,
      @required thickness,
      bool isDecorated = true}) {
    return Positioned(
      top: posFromTop,
      left: posFromLeft,
      child: Transform(
          transform: Matrix4.identity()..translate(0.0, slideDist),
          child: Container(
            height: height,
            width: width,
            padding: EdgeInsets.fromLTRB(padH, padV, padH, padV),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                verticalDirection: VerticalDirection.down,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(child: contactFutureBuilder(isDecorated:  isDecorated,thickness: thickness))
                ]),
          )),
    );
  } // build

  /// Builds the Search [IconButton] that goes in the [AppBar] actions.
  Widget searchButton() {
    return IconButton(icon: searchIcon, onPressed: revealSearchField);
  }

  /// Toggle appbar and dropdown button animations
  void toggleAnimation() => ac.isDismissed ? ac.forward() : ac.reverse();

  /// Toggles the [AppBar] between the page title and the search [TextField]
  void revealSearchField() {
    toggleAnimation();
    setState(() {
      appBarLeading = null;
      if (searchIcon.icon == Icons.search) {
        searchIcon = Icon(
          Icons.close,
          color: Colors.black45,
        );
        filterIcon = Icon(
          Icons.filter_list,
          color: Colors.white,
        );
        appBarTitle = TextField(
          controller: tec,
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search',
              filled: false,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
              )),
        );
      } else {
        appBarLeading = BackButton();
        searchIcon = Icon(
          Icons.search,
          color: Colors.white,
        );
        appBarTitle = Text('Contacts');
        filterIcon = Icon(
          Icons.filter_list,
          color: Colors.white,
        );
        baseParam = 'contact/?search=';
        contacts.clear();
        tec.clear();
      }
    });
  } // revealSearchField

  /// Builds a [ListView] of [ContactTile] for each member
  /// in the list of [contacts].
  Widget buildContactListView(
      {@required List<dynamic> contacts,
      bool hasDecoration,
      @required double thickness}) {
    return Scrollbar(
      controller: sc,
      child: ListView.builder(
          itemCount: contacts.length,
          semanticChildCount: contacts.length,
          itemBuilder: (BuildContext context, int index) {
            return ContactTile(
              hasDecoration: hasDecoration,
              title: contacts[index]['name'],
              subtitle: contacts[index]['description'],
              namedRoute: contactDetailRoute,
              arguments: contacts[index],
              thickness: thickness,
            );
          }),
    );
  } // buildContactCard

  /// Displays a [CircularProgressIndicator] while the list of contacts loads.
  /// Also displays message indicating that no matches were found if
  /// no matches were found and a message if an error occured.
  Widget contactFutureBuilder(
      {@required bool isDecorated, @required double thickness}) {
    return FutureBuilder(
      future: getResultsJSON('$baseParam$extraParam'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.none) {
          return Center(
              child: Text(
                  'Cannot load contacts. Check your internet connection.'));
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            contacts = snapshot.data.toSet().toList();
            if (contacts.length > 0) {
              return buildContactListView(
                  contacts: contacts,
                  hasDecoration: isDecorated,
                  thickness: thickness);
            } else {
              return Center(child: Text('No matches found'));
            }
          } else if (!snapshot.hasData || snapshot.hasError) {
            return Center(child: Text('An error occured'));
          } else {
            return Center(child: Text('No matches found'));
          }
        }
        return Container();
      },
    );
  } // _contactFutureBuilder

  /// Drop down button to filter the list of [contacts] by [categories].
  filterDropDown(BuildContext context,
      {@required double height,
      @required double width,
      @required bool isExpanded,
      @required double slideDist,
      @required double elevation}) {
    return Transform(
        transform: Matrix4.identity()..translate(0.0, slideDist),
        child: Card(
            margin: EdgeInsets.all(0.0),
            elevation: elevation,
            child: PreferredSize(
                child: Container(
                    color: Theme.of(context).accentColor,
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
                          value: dropdownValue,
                          items:
                              filterDropDownItemBuilder(context, width: width),
                          onChanged: (value) {
                            dropdownValue = value;
                          }),
                    )),
                preferredSize: Size.fromHeight(height))));
  }

  /// Builds the  dropdown list for [filterDropDown] from [categories].
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
            style: categories[i]['title'] == dropdownValue
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
} // _ContactPageState
