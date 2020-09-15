import 'dart:convert';
import 'package:http/http.dart' as http;

/// A class for fetching and parsing data from the app's Heroku Postgres
/// database into a list of objects of type [T].
class HerokuRequest<T> {
  /// The [query] should be the end of the url for sending a request to the Heroku
  /// server or a full url for somewhere else.
  ///
  /// eg. To get all contacts from the Chemistry department, I should pass
  /// ```
  /// 'contact/?department=CHEM'
  /// ```
  ///
  /// Indicate that the [query] is for the app's Heroku database pass [queryIsForFSTHeroku] and `true`,
  /// otherwise `false`.
  ///
  /// The response body is returned as a [String].
  Future<String> _getResultsString(
      dynamic query, bool queryIsForFSTHeroku) async {
    String queryString = query.toString();
    String url;
    if (queryIsForFSTHeroku) {
      url = 'https://fst-app-2.herokuapp.com/$queryString';
    } else {
      url = queryString;
    }

    http.Response response = await http.get(Uri.encodeFull(url));
    if (response.statusCode == 200)
      return response.body;
    else
      return '';
  }

  /// Parses the response from [_getResultsString] and returns a [List] of
  /// `dynamic` objects. The objects are in JSON format which is decoded to
  /// [List<Map<dynamic,dynamic>>] format in flutter.
  ///
  /// A [Map] can be treated like a dictionary in Python in terms of
  /// declaration and accessing its members.
  ///
  /// Then each map in the list of maps is then parsed by the [constructor] to return a
  /// list of type [List<T>].
  Future<List<T>> getResults(dynamic valueToQuery, bool queryIsForFSTHeroku,
      _Instantiator<T> constructor) async {
    return _getResultsString(valueToQuery, queryIsForFSTHeroku)
        .then((responseBody) {
      try {
        List<dynamic> dataJson = jsonDecode(responseBody);
        List<T> data =
            List.generate(dataJson.length, (i) => constructor(dataJson[i]));
        return data;
      } catch (e) {
        return <T>[];
      }
    });
  }
}

/// Used in [HerokuRequest.getResults] to make a list of objects of the model class of type [T].
typedef S _Instantiator<S>(dynamic data);
