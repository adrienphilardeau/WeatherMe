import 'package:flutter/material.dart';
import 'package:json_http_test/WeatherBloc.dart';
import 'package:json_http_test/WeatherAppWithBloc.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_http_test/WeatherRepo.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(MyApp());



class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.black,

          body: BlocProvider(
            builder: (context) => WeatherBloc(WeatherRepo()),
            child: SearchPage(),
          ),
        )
    );
  }
}

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    var cityController = TextEditingController();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state){
            if(state is WeatherIsNotSearched)
              return Container(
                padding: EdgeInsets.only(left: 32, right: 32,),
                child: Column(
                  children: <Widget>[
                    Center(
                        child: Container(
                          child: FlareActor("assets/WorldSpin.flr", fit: BoxFit.contain, animation: "roll",),
                          height: 300,
                          width: 300,
                        )
                    ),

                    Text("Good Morning!", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700, color: Colors.white),),
                    SizedBox(height: 5,),
                    Text("What city are you in?", style: TextStyle(fontSize: 35, fontWeight: FontWeight.w300, color: Colors.white),),
                    SizedBox(height: 24,),
                    TextFormField(
                      controller: cityController,

                      decoration: InputDecoration(

                        prefixIcon: Icon(Icons.search, color: Colors.white70,),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                color: Colors.white70,
                                style: BorderStyle.solid
                            )
                        ),

                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                color: Colors.blue,
                                style: BorderStyle.solid
                            )
                        ),

                        hintText: "City Name",
                        hintStyle: TextStyle(color: Colors.white70),

                      ),
                      style: TextStyle(color: Colors.white),

                    ),

                    SizedBox(height: 15,),
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: FlatButton(
                        shape: new RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                        onPressed: (){
                          weatherBloc.add(FetchWeather(cityController.text));
                        },
                        color: Colors.lightBlue,
                        child: Text("Search", style: TextStyle(color: Colors.white, fontSize: 20),),

                      ),
                    )

                  ],
                ),
              );

            else if(state is WeatherIsLoading)
              return Center(child : CircularProgressIndicator());
            else if(state is WeatherIsLoaded)
              return ShowWeather(state.getWeather, cityController.text);
            else
              return Text("Error",style: TextStyle(color: Colors.white),);
          },
        )

      ],

    );

  }

}

class ShowWeather extends StatelessWidget {
  WeatherModel weather;

  final city;


  ShowWeather(this.weather, this.city);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(right: 32, left: 32, top: 10),
        child: Column(
          children: <Widget>[
            Text(city,style: TextStyle(color: Colors.white, fontSize: 65, fontWeight: FontWeight.bold),),
            SizedBox(height: 5,),
            Text(weather.getTemp.round().toString()+"°C", style: TextStyle(color: Colors.white, fontSize: 75),),
            SizedBox(height: 30,),
            Text("Min: " + weather.getTempMin.round().toString()+"°           " + "Max: " + weather.getTempMax.round().toString()+"°", style: TextStyle(color: Colors.white, fontSize: 25),),
            SizedBox(height: 30,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(weather.getFeels.round().toString()+"°",style: TextStyle(color: Colors.white, fontSize: 30),),
                    Text("Feels like",style: TextStyle(color: Colors.white70, fontSize: 17),),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(weather.humidity.round().toString() + "%",style: TextStyle(color: Colors.white, fontSize: 30),),
                    Text("Chance of Rain",style: TextStyle(color: Colors.white70, fontSize: 17),),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 35,
            ),


            Container(
              width: double.infinity,
              height: 220,
                child: Column(
                    children: <Widget>[
                  ButtonTheme(
                  minWidth: 300.0,
                  height: 100.0,
                  child: RaisedButton(
                    shape: new RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
                    onPressed: () {
                      //if(weather.getTemp < 0) {
                      double temperature = weather.getTemp;
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Video(temperature)),);
                     //}
                      /*else if(weather.getTemp < 15){
                       Navigator.push(context, MaterialPageRoute(builder: (context) => Video2()),);
                     }
                      else if(weather.getTemp < 24){
                       Navigator.push(context, MaterialPageRoute(builder: (context) => Video3()),);
                     }
                     else{
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Video4()),);
                        }*/
                      },
                    child: Text("What Should I Wear?" ,style: TextStyle(color: Colors.white, fontSize: 25),),
                  ),
                ),
                      SizedBox(
                        height: 20,
                      ),
                      ButtonTheme(
                        minWidth: 250.0,
                        height: 70.0,
                        child: RaisedButton(
                          shape: new RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
                          onPressed: () {BlocProvider.of<WeatherBloc>(context).add(ResetWeather());
                          },
                          child: Text("Back to Search" ,style: TextStyle(color: Colors.white, fontSize: 20),),
                        ),
                      ),
                    ],
                ),
            )
    ]
        )
    );
    ;
  }
  }

class Video extends StatelessWidget{
  Video(this.temp);
  double temp;

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VideoExample(temp),);
  }
}

class VideoExample extends StatefulWidget {
  double temp;
  VideoExample(this.temp);
  @override
  VideoState createState() => VideoState(temp);
}

class VideoState extends State<VideoExample>{
  double temp;
  VideoState(this.temp);
  VideoPlayerController playerController;
  VoidCallback listener;

  @override
  void initState(){
    super.initState();
    listener = (){
      setState((){});
    };
  }

  void createVideo(){
    if(playerController == null){
      if(temp < 0) {
        playerController = VideoPlayerController.asset("assets/ColdVideo.mp4")
          ..addListener(listener)
          ..setVolume(0.0)
          ..initialize()
          ..setLooping(true);
      }
      else if(temp < 15){
        playerController = VideoPlayerController.asset("assets/CoolVideo.mp4")
          ..addListener(listener)
          ..setVolume(0.0)
          ..initialize()
          ..setLooping(true);
      }
      else if(temp < 24){
        playerController = VideoPlayerController.asset("assets/WarmVideo.mp4")
          ..addListener(listener)
          ..setVolume(0.0)
          ..initialize()
          ..setLooping(true);
      }
      else{
        playerController = VideoPlayerController.asset("assets/HotVideo.mp4")
          ..addListener(listener)
          ..setVolume(0.0)
          ..initialize()
          ..setLooping(true);
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
    title: Text("Your Outfit Selection"),
    ),
    body: Center(
    child: AspectRatio(
        aspectRatio: 1280/720,
      child: Container(
        child: (playerController != null ? VideoPlayer(playerController,) : Container()),)
    )),
floatingActionButton: FloatingActionButton(
  onPressed: (){
    createVideo();
    playerController.play();
  },
  child: Icon(Icons.play_arrow),
),
    );
  }
}

