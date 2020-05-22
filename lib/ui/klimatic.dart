import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:climatic_app/utl/utils.dart' as util;
import 'package:http/http.dart' as http;

class Klimatic extends StatefulWidget {
  @override
  _KlimaticState createState() => _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {

  String _cityEntered;

  Future _gotoNextScreen(BuildContext context) async {
    Map results = await Navigator.of(context).push(MaterialPageRoute<Map>(
      builder: (BuildContext context){
        return ChangeCity();
      }
    ));

    if(results != null && results.containsKey('enter')){
      _cityEntered = results['enter'];
    }
  }

  showStuff() async{
    Map data = await getWeather(util.appId, util.defaultCity);
    print(data.toString());

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Climatic',
        style: TextStyle(
          color: Colors.black
        ),),
        centerTitle: true,
        backgroundColor: Colors.grey,
        actions: <Widget>[
          FlatButton(
            child: Icon(Icons.menu),
            onPressed: () => _gotoNextScreen(context),
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset('images/climate.jpg',
            width: 500,
            height: 1200,
            fit: BoxFit.fill,),

      ),
          Container(
            child: Text('${_cityEntered == null ? util.defaultCity : _cityEntered}',
              style: style(),
            ),
            alignment: Alignment.topRight,
            margin: EdgeInsets.fromLTRB(0, 15, 20, 0),
          ),
          Container(
            child: updateTempWidget(_cityEntered),
            alignment: Alignment.center,

          ),
        ],
      ),
    );
  }
  Future<Map> getWeather(String appId, String city) async {
    String apiUrl = 'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=${util.appId}&units=metric';

    http.Response response = await http.get(apiUrl);

    return json.decode(response.body);
  }

  Widget updateTempWidget(String city) {
    return FutureBuilder(
      future: getWeather(util.appId, city == null ? util.defaultCity : city),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot){
        if (snapshot.hasData){
          Map content = snapshot.data;
          return Container(
            margin: const EdgeInsets.fromLTRB(100, 170, 10, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ListTile(
                  title: Text(" ${content['main']['temp'].toString()} C",
                  style: tempStyle(),),
                  subtitle: ListTile(
                    title: new Text(
                      "Humidity: ${content['main']['humidity'].toString()}\n"
                          "Min: ${content['main']['temp_min'].toString()} C\n"
                          "Max: ${content['main']['temp_max'].toString()} C",
                      style: TextStyle(color: Colors.white,
                      fontSize: 17),
                    ),
                  ),
                )
              ],
            ),
          );
        }else{
          return Container();
        }
      },
    );
  }
}


class ChangeCity  extends StatelessWidget {

  var _cityFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        title: Text('Change City',
        style: TextStyle(
          color: Colors.black
        ),),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent.withOpacity(0.7),
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset('images/white_snow.png',
            width: 490.0,
            height: 1200,
            fit: BoxFit.fill,),
          ),
          ListView(
            children: <Widget>[
              ListTile(
                title: TextField(
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,
                ),
              ),
              ListTile(
                title: FlatButton(
                  onPressed: () {Navigator.pop(context, {
                    'enter': _cityFieldController.text
                  });
                  },
                  color: Colors.lightBlueAccent.withOpacity(0.6),
                  child: Text('Get Weather',
                  style: TextStyle(
                    color: Colors.black 
                  ),),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}


TextStyle style(){
  return TextStyle(
    color: Colors.white,
    fontSize: 30,
    letterSpacing: 3,
    fontWeight: FontWeight.bold
  );
}

TextStyle tempStyle(){
  return TextStyle(
    color: Colors.white,
    fontSize: 50,
    fontWeight: FontWeight.bold
  );
}