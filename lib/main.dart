import 'package:dark_dictionary/dictionary.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dark dictionary',
      theme: ThemeData(
          primarySwatch: Colors.lightBlue, brightness: Brightness.dark),
      home: SearchPage(title: 'Search for words'),
    );
  }
}

class SearchPage extends StatefulWidget {
  SearchPage({Key key, this.title}) : super(key: key);

  final String title;
  final Dictionary dictionary = Dictionary();
  final textStyle = TextStyle(fontSize: 25, color: Colors.white);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _searchTerm = "";
  List<String> _result = [""];
  final TextEditingController _searchController = new TextEditingController();

  void _performSearch(String term) {
    setState(() {
      _searchTerm = term;
      _result = widget.dictionary.searchDictionaryEntries(term);
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter a search term...',
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: _performSearch,
              style: widget.textStyle,
            ),
            Text(
              _searchTerm.length > 0 ? '$_searchTerm:' : "",
              style: Theme.of(context).textTheme.display1,
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 20),
            Container(
              height: 400,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                //shrinkWrap: true,
                itemCount: _result?.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _result[index].split("\t").first + ":",
                          style: widget.textStyle,
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 10),
                        FlatButton(
                          child: Text(
                            _result[index].split("\t").skip(1).join(" "),
                            style: widget.textStyle,
                            textAlign: TextAlign.left,
                          ),
                          onPressed: () {/*TODO Anki support*/},
                        ),
                        SizedBox(height: 20),
                      ]);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
