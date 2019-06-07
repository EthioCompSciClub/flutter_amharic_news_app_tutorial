import 'package:flutter/material.dart';
import 'model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

void main() {
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'theme',
      theme: ThemeData.dark(),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<Model>> _getModel() async {
    var data =
        await http.get("https://ethiocompsciclub.000webhostapp.com/api.php");
    var jsonData = json.decode(data.body);
    List<Model> models = [];

    for (var m in jsonData['data']) {
      Model single_model = Model(m['id'], m['title'], m['href'], m['image'],
          m['logo'], m['logo_link'], m['title_date']);
      models.add(single_model);
    }
    print(models.length);
    return models;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ዜና ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getModel(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: Text(
                    "ዜና እየሰበሰበን ነው ....",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            } else {
              return Scrollbar(
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context){
                              return DetialPage(models: snapshot.data[index]);
                            },
                          ),
                        );
                      },
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 5,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(6.0),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Image.network(
                                    snapshot.data[index].image,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      snapshot.data[index].title,
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Spacer(),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.fromLTRB(
                                              0, 0, 4.0, 10.0),
                                          padding: EdgeInsets.fromLTRB(
                                              4.0, 1.0, 4.0, 1.0),
                                          color: Colors.orange,
                                          child: Text(
                                            (snapshot.data[index].logo)
                                                .split("//")[1],
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          margin: EdgeInsets.fromLTRB(
                                              0, 0, 10.0, 10.0),
                                          padding: EdgeInsets.fromLTRB(
                                              4.0, 1.0, 4.0, 1.0),
                                          color: Colors.orange,
                                          child: Text(
                                            (snapshot.data[index].date),
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class DetialPage extends StatelessWidget {
  final Model models;
  DetialPage({this.models});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          models.title,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: WebviewScaffold(url: models.href),
    );
  }
}


