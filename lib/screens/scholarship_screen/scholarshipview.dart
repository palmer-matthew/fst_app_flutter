import 'package:flutter/material.dart';

class ScholarshipView extends StatelessWidget {
  // final Scholarship current;
  final String title; 
  const ScholarshipView({this.title});

  Widget _buildAppBar(){
    return AppBar(
        title: Text(title),
        backgroundColor: Colors.blue.shade900,
        elevation: 0,
      );
  }

  Widget _buildHeader(String text){
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.blue.shade900,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _setParagraph(String text){
    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: Colors.black,
          fontSize: 15,
        ),
        children: <TextSpan>[
          TextSpan(
            text: text,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
        child: ListView(
          children: <Widget>[
            _buildHeader("Description"),
            SizedBox(height: 20),
            _setParagraph("Stuff for the paragraph 1"),
            SizedBox(height: 20),
            _buildHeader("Details"),
            SizedBox(height: 20),
            _setParagraph("Stuff for the paragraph 2"),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}