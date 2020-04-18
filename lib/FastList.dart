

import 'dart:io';

class FastList{

  List<String> entries;
  List<String> keys;

  FastList(List<String> entries){
    this.entries = entries;

    keys = entries.map((e) {
      return e.split("\t")[0];
    }).toList();
  }

  List<List<String>> takeFirstElementsSplitContaining(String searchTerm, int amount){
    List<List<String>> searchResults = [["Noun"],["Adjective"],["Verb"],["Other"]];
    //TODO: the first list is currently displayed with buttons but should be plain Text instead


    //No split in every iteration anymore, searching the key words directly instead
    for(int i = 0; i < keys.length; i++){
      if(keys[i] == searchTerm){
        var currentElement = entries.elementAt(i);


        //Adds the element to to correct collection
        searchResults[getListIndexByType(currentElement)].add(currentElement);
      }
    }

    /*searchResults.sort((e,z) {

      return e.length.compareTo(z.length);
    });*/


    return searchResults.take(amount).toList();
  }

  int getListIndexByType(String line){
    var lineSplit = line.split("\t");

    if(lineSplit.contains("noun")){
      return 0;
    } else if(lineSplit.contains("adj")){
      return 1;
    } else if(lineSplit.contains("verb")){
      return 2;
    } else {
      return 3;
    }

  }
}