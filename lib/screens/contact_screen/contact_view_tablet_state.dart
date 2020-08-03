import 'package:flutter/material.dart';
import 'package:fst_app_flutter/screens/contact_screen/contact_state.dart';

class ContactViewTabletPortraitState extends ContactViewState {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

class ContactViewTabletLandscapeState extends ContactViewState {
  AnimationController fc;

  Color filterOptionBgColor;

  String currentFilter = 'All';

  @override
  void initState() {
    super.initState();
    fc = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context);
    var screenHeight = mq.size.height;
    var screenWidth = mq.size.width;
    var sidepanelWidth = screenWidth * 0.25 + kMinInteractiveDimension;

    return Scaffold(
      body: SafeArea(
          child: AnimatedBuilder(
        animation: ac,
        builder: (context, child) => Stack(
          children: <Widget>[
            SlideTransition(
              position:
                  Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(0.25, 0.0))
                      .animate(CurvedAnimation(parent: fc, curve: Curves.ease)),
              child: Stack(
                children: [
                  buildContactListArea(
                      posFromTop: kToolbarHeight,
                      slideDist: 0.0,
                      height: screenHeight - kToolbarHeight,
                      width: screenWidth - kMinInteractiveDimension,
                      padH: screenWidth * 0.07,
                      padV: screenHeight * 0.05,
                      posFromLeft: kMinInteractiveDimension, thickness: 7.0),
                ],
              ),
            ),
            Container(),
            filterDrawer(
                bgColor: Theme.of(context).accentColor,
                width: sidepanelWidth,
                height: screenHeight - kToolbarHeight,
                posFromTop: kToolbarHeight),
            Container(),
            buildAppBarArea(
                height: kToolbarHeight,
                animationIntervalStart: 0.0,
                animationIntervalEnd: 1.0,
                actions: <Widget>[searchButton()],
                elevation: 4.0)
          ],
        ),
      )),
    );
  }

  Widget filterDrawer({
    @required double width,
    @required double height,
    @required Color bgColor,
    @required double posFromTop,
  }) {
    return SlideTransition(
        position:
            Tween<Offset>(begin: Offset(-0.25, 0.0), end: Offset(0.0, 0.0))
                .animate(CurvedAnimation(
                    parent: fc,
                    curve: Curves.elasticOut,
                    reverseCurve: Curves.elasticIn)),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: posFromTop,
              child: Container(
                color: bgColor,
                width: width,
                height: height,
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(right: kMinInteractiveDimension, left: width*0.05),
                  child: ListView.builder(
                    itemBuilder: (context, i) =>
                        filterDrawerListBuilder(context, i, height),
                    itemCount: categories.length,
                    semanticChildCount: categories.length,
                  ),
                ),
              ),
            ),
            Container(),
            Positioned(
              top: posFromTop,
              left: width - kMinInteractiveDimension,
              child: InkWell(
                onTap: () => toggleDrawer(),
                child: Container(
                    height: height,
                    width: kMinInteractiveDimension,
                    color: bgColor,
                    child: Center(
                      child: IconButton(
                          icon: Icon(
                            Icons.arrow_right,
                            color: Colors.white,
                          ),
                          onPressed: () => toggleDrawer()),
                    )),
              ),
            ),
            Container(),
          ],
        ));
  }

  toggleDrawer() => fc.isDismissed ? fc.forward() : fc.reverse();

  filterDrawerListBuilder(context, i, height) {
    return InkWell(
      onTap: () {
        setState(() {
          extraParam =
              '&${categories[i]['queryParam']}=${categories[i]['value']}';
          currentFilter = categories[i]['title'];
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: height * 0.01, top: height * 0.01),
        height: (height / categories.length) - ((height * 0.01) * 2),
        decoration: BoxDecoration(
            color: currentFilter == categories[i]['title']?  Color.lerp(Colors.blue[600],Colors.blue[700],0.5) :filterOptionBgColor,
            borderRadius: BorderRadius.circular(40.0)),
        child: ListTile(
          title: Text(
            categories[i]['title'],
            softWrap: true,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
