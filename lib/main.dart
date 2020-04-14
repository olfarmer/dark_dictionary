import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dark dictionary',
      theme: ThemeData(
          primarySwatch: Colors.lightBlue,
          brightness: Brightness.dark
      ),
      home: SearchPage(title: 'Search for words'),
    );
  }
}

class SearchPage extends StatefulWidget {
  SearchPage({Key key, this.title}) : super(key: key);

  final String title;
  final Dictionary dictionary = Dictionary();
  final textStyle = TextStyle(fontSize: 25,color: Colors.white);

  @override
  _SearchPageState createState() => _SearchPageState();


}

class Dictionary{

  var entries = [""];

  Dictionary() {
    loadDirectory();
  }

  loadDirectory() async {
    try{
      if(await Permission.storage.request().isGranted) {
        var file = await _localDicFile;

        if (await file.exists()) {
          entries = await file.readAsLines();
        } else {
          file = await FilePicker.getFile();

          //Move file to correct path
          final path = await _localPath;
          file.copy('$path/dic');
        }
      } else {
        print("No IO permission");
      }
    } catch(e){
      print("Error reading the file");
    }

  }

  List<String> searchDictionaryEntries(String searchTerm) {
    return entries.where((e){
      return e.split("\t").contains(searchTerm);
    }).take(10).toList();
  }



  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localDicFile async {
    final path = await _localPath;
    return File('$path/dic');
  }
}

class _SearchPageState extends State<SearchPage> {
  String _searchTerm = "";
  List<String> _result = [""];
  final TextEditingController _searchController = new TextEditingController();

  void _performSearch(String term){
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
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: _result?.length,
              itemBuilder: (BuildContext context, int index){
                return Text(_result[index].split("\t").skip(1).join("\t"), style: widget.textStyle,);
              },
            )
          ],
        ),
      ),
    );
  }
}
