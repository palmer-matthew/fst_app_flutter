import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fst_app_flutter/widgets/app_drawer/app_drawer.dart';
import 'package:fst_app_flutter/widgets/card_container/card_container.dart';

class HomeMobilePortrait extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("FST Go"),
        centerTitle: false,
      ),
      drawer: AppDrawer(),
      body: Stack(fit: StackFit.passthrough, children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
            left: 30.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: queryData.size.height * 0.02,
              ),
              Text(
                "Welcome to the\nFaculty of Greatness",
                style: TextStyle(
                    //color: Color(0xff322F51),
                    fontWeight: FontWeight.bold,
                    fontSize: queryData.size.width * 0.055966),
              ),
              SizedBox(
                height: queryData.size.height * 0.02,
              ),
              CardContainer(),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              height: queryData.size.height * 0.1442,
              width: queryData.size.width,
              child:  FittedBox(
                  fit: BoxFit.fill,
                  child:              
                  
                  SvgPicture.asset('assets/home.svg'))),
        )
      ]),
    );
  }
}

class HomeMobileLandscape extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);

    return Scaffold(
      body: Row(
        children: <Widget>[
          AppDrawer(),
          Expanded(
            child: Stack(children: <Widget>[
              Align(
                alignment: Alignment.bottomCenter,
                child: Opacity(
                  opacity: 0.43,
                  child: Container(
                      height: queryData.size.height * 0.77,
                      width: queryData.size.width,
                      child: FittedBox(
                          fit: BoxFit.fill,
                          child: Image(
                            width: 50,
                            image: AssetImage("assets/home_art.png"),
                          ))),
                ),
              ),
              Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                    Text(
                      "Welcome to the Faculty of Greatness",
                      style: TextStyle(
                          //color: Color(0xff322F51),
                          fontWeight: FontWeight.bold,
                          fontSize: queryData.size.shortestSide * 0.055966),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[CardContainer()])
                  ])),
            ]),
          ),
        ],
      ),
    );
  }
}
