import 'package:flutter/material.dart';
import 'package:fst_app_flutter/screens/scholarship_screen/scholarshipview.dart';

class ScholarshipHome extends StatelessWidget {
  const ScholarshipHome({Key key}) : super(key: key);

  final String name = "Scholarship Name";

  Widget _buildAppBar(){
    return AppBar(
      automaticallyImplyLeading: true,
      backgroundColor: Colors.blue.shade900,
      title: Text(
        "Scholarships",
        style: TextStyle(
          fontFamily: "Monsterrat",
          color: Colors.white,
        ),
      ),
      actions: <Widget>[
        Icon(
          Icons.search,
          color: Colors.white,
        ),
      ],
    );
  }

  Widget _buildTextField(){
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
          borderRadius: BorderRadius.all(const Radius.circular(70)),
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: 2,
          horizontal: 15,
        ),
        hintText: "Search",
        suffixIcon: Icon(
          Icons.search,
        ),
        fillColor: Colors.grey.shade200,
        filled: true,
      ),
    );
  }

  Widget _buildTempList(){
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              title: Text(name),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 18,
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ScholarshipView(title: name),
                ));
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: <Widget>[
            _buildTextField(),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: _buildTempList(),
            ),
          ],
        ),
      ),
    );
  }
}