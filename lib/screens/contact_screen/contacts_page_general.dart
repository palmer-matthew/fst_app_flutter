import 'package:flutter/material.dart';
import 'package:fst_app_flutter/services/handle_heroku_requests.dart';
import 'package:fst_app_flutter/screens/contact_screen/contact_detail_page.dart';
import 'package:fst_app_flutter/widgets/contact_tile.dart';

class ContactPage extends StatefulWidget {
  static const routeName = '/contact';

  const ContactPage({Key key}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
} // ContactPage definition

class _ContactPageState extends State<ContactPage> {
  /// This [String] will be modified to include the search value entered by the user.
  /// Otherwise, it will be passed to the [getResultsJSON] like this.
  var _baseParam = 'contact/?search=';

  /// Extra parameters to attach to the [_baseParam] such as department or type.
  var _extraParam = '';

  /// The default categories to filter by and their corresponding
  /// query parameter and value.
  ///
  /// Used to construct the [_filterDropDown]
  final List<dynamic> _categories = [
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
  List<dynamic> _contacts = [];

  /// Currently selected dropdown item value. Allows for differential 
  /// of text in the dropdown list for the item that is selected.
  var _dropdownValue = 'All';

  /// Used to switch the state of the appBar to a search field in the [_revealSearchField]
  /// function.
  Icon _searchIcon = Icon(Icons.search);

  /// Used to switch between filters from [_categories] in the [_filterDropDown]
  /// function
  Icon _filterIcon = Icon(Icons.filter_list, color: Colors.white);

  /// Used to switch the state of the appBar to a search field in the [_revealSearchField]
  /// function.
  Widget _appBarTitle = Text('Contacts');

  /// Returns the list to the position it was at before navigatimg to another route
  ScrollController _sc = ScrollController(keepScrollOffset: true);

  /// Allows for changing the appbar colour in [_revealSearchField]
  Color _appBarColor;

  /// Colour behind the dropdown button. Toggles between blue and white in [_revealSearchField]
  Color _dropdownBackground = Colors.blue[800];

  /// Colour of the selected item's text on the drop down button. 
  /// Toggles between white and black in [_revealSearchField]
  Color _dropdownSelected = Colors.white;

  /// The preferred size of the dropdown button. 
  /// Toggles between [kToolbarHeight] and `0.0` in [_revealSearchField].
  var _prefSize = kToolbarHeight;

  /// Load all contacts when page is loaded initially
  @override
  void initState() {
    getResultsJSON('$_baseParam$_extraParam')
        .then((data) => _contacts = data.toSet().toList());
    super.initState();
  }


  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // width and height calculations made using the [MediaQueryData]
    var mq = MediaQuery.of(context);
    // horizontal and vertical padding for the list of contacts
    var padH = mq.size.width * 0.1;
    var padV = (mq.size.height - (kToolbarHeight * 2)) * 0.07;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _appBarColor,
        title: _appBarTitle,
        actions: <Widget>[
          IconButton(icon: _searchIcon, onPressed: _revealSearchField),
        ],
        bottom: _filterDropDown(context),
        centerTitle: false,
      ),
      body: mq.orientation == Orientation.portrait
          ? SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Container(
                height: mq.size.height - (kToolbarHeight * 2),
                width: mq.size.width,
                padding:
                    EdgeInsets.fromLTRB(padH, padV, padH, padV),
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    verticalDirection: VerticalDirection.down,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded(child: _contactFutureBuilder())
                    ]),
              ),
            )
          : Container(),
    );
  } // build

  /// Toggles the [AppBar] between the page title and the search [TextField]
  void _revealSearchField() {
    setState(() {
      if (_searchIcon.icon == Icons.search) {
        _appBarColor = Colors.white;
        _searchIcon = Icon(
          Icons.close,
          color: Colors.black45,
        );
        _filterIcon = Icon(
          Icons.filter_list,
          color: Colors.white,
        );
        _prefSize = 0.0;
        _dropdownSelected = Colors.black45;
        _dropdownBackground = Colors.white;
        _appBarTitle = TextField(
          onChanged: (value) {
            setState(() {
              _baseParam = 'contact/?search=$value';
              _contacts.clear();
            });
          },
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              //contentPadding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
              hintText: 'Search',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                //borderRadius: BorderRadius.all(Radius.circular(40.0)),
                borderSide: BorderSide.none,
              )),
        );
      } else {
        _dropdownBackground = Theme.of(context).accentColor;
        _searchIcon = Icon(
          Icons.search,
          color: Colors.white,
        );
        _appBarTitle = Text('Contacts');
        _appBarColor = Theme.of(context).appBarTheme.color;
        _filterIcon = Icon(
          Icons.filter_list,
          color: Colors.white,
        );
        _baseParam = 'contact/?search=';
        _contacts.clear();
        _prefSize = kToolbarHeight;
        _dropdownSelected = Colors.white;
      }
    });
  } // revealSearchField

  /// Builds a [ListView] of [ContactTile] for each member
  /// in the list of [contacts].
  Widget _buildContactListView(List<dynamic> contacts) {
    return Scrollbar(
      controller: _sc,
      child: ListView.builder(
          itemCount: contacts.length,
          semanticChildCount: contacts.length,
          itemBuilder: (BuildContext context, int index) {
            return ContactTile(
                title: contacts[index]['name'],
                subtitle: contacts[index]['description'],
                namedRoute: ContactDetailPage.routeName,
                arguments: contacts[index]);
          }),
    );
  } // buildContactCard

  /// Displays a [CircularProgressIndicator] while the list of contacts loads.
  /// Also displays message indicating that no matches were found if
  /// no matches were found and a message if an error occured.
  Widget _contactFutureBuilder() {
    return FutureBuilder(
      future: getResultsJSON('$_baseParam$_extraParam'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.none) {
          return Center(
              child: Text(
                  'Cannot load contacts. Check your internet connection.'));
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            _contacts = snapshot.data.toSet().toList();
            if (_contacts.length > 0) {
              return _buildContactListView(_contacts);
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

  /// Drop down button to filter the list of [_contacts] by [_categories].
  _filterDropDown(BuildContext context) {
    return PreferredSize(
        child: Container(
            color: _dropdownBackground,
            height: _prefSize,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.centerLeft,
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                  //style: TextStyle(color: Colors.red),
                  selectedItemBuilder: (context) {
                    return _categories
                        .map((e) => Align(
                              alignment: Alignment.centerLeft,
                              child: Text(e['title'],
                                  style: TextStyle(
                                      color: _dropdownSelected,
                                      fontWeight: FontWeight.w600)),
                            ))
                        .toList();
                  },
                  isExpanded: true,
                  icon: _filterIcon,
                  value: _dropdownValue,
                  items: _filterDropDownItemBuilder(context),
                  onChanged: (value) {
                    _dropdownValue = value;
                  }),
            )),
        preferredSize: Size.fromHeight(_prefSize));
  }

  /// Builds the  dropdown list for [_filterDropDown] from [_categories].
  List<DropdownMenuItem<dynamic>> _filterDropDownItemBuilder(context) {
    return List.generate(_categories.length, (i) {
      return DropdownMenuItem(
        child: Container(
          alignment: Alignment.centerLeft,
          height: kMinInteractiveDimension,
          width: MediaQuery.of(context).size.width,
          child: Text(
            _categories[i]['title'],
            style: _categories[i]['title'] == _dropdownValue
                ? TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.w800)
                : null,
          ),
        ),
        onTap: () {
          setState(
            () {
              _extraParam =
                  '&${_categories[i]['queryParam']}=${_categories[i]['value']}';
            },
          );
        },
        value: _categories[i]['title'],
      );
    });
  }
} // _ContactPageState
