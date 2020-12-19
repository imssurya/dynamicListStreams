import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'photo_model.dart';

class PhotoList extends StatefulWidget {
  @override
  _PhotoListState createState() => _PhotoListState();
}

class _PhotoListState extends State<PhotoList> {
  StreamController<Photo> streamController;
  List<Photo> list = [];
  @override
  void initState() {
    super.initState();
    streamController = StreamController.broadcast();
    streamController.stream.listen((p) {
      setState(() {
        list.add(p);
      });
    });
    load(streamController);
  }

  @override
  void dispose() {
    super.dispose();
    streamController?.close();
    streamController = null;
  }

  load(StreamController<Photo> streamController) async {
    String url = "https://jsonplaceholder.typicode.com/photos";
    var client = Client();
    var req = Request('get', Uri.parse(url));
    var streamRes = await client.send(req);
    streamRes.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .expand((e) => e)
        .map((event) => Photo.fromJsonMap(event))
        .pipe(streamController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Photo Streams"),
      ),
      body: Center(
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return _makeElement(index);
          },
        ),
      ),
    );
  }

  Widget _makeElement(int index) {
    if (index >= list.length && list.length > 5) {
      return null;
    }
    return Container(
      padding: EdgeInsets.all(5.0),
      child: Column(
        children: <Widget>[
          Image.network(list[index].url),
          Text(list[index].title),
        ],
      ),
    );
  }
}
