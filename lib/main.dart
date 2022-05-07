import 'package:flutter/material.dart';
import 'dart:async';
import 'package:marquee/marquee.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyAppHome(),
    ); //materialApp
  }
}

class MyAppHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppHomeState();
  }
}

class _MyAppHomeState extends State<MyAppHome> {
  String userName="";
  int typedCharLength=0;
  String lorem =
  '                                  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus mattis eu leo vitae porta. Mauris nec erat vel purus dictum elementum eget tempus ligula. In varius orci ut quam lobortis rutrum. Vivamus viverra posuere feugiat. Nam lacinia lacinia purus, et imperdiet sem tristique sit amet. Nullam dictum sit amet ante id finibus. Sed a massa sit amet tortor gravida scelerisque non vel neque. Nam ac nisl turpis. Suspendisse pharetra, ipsum ac egestas tincidunt, nulla nisl volutpat mi, ut eleifend quam purus in mi. Integer non lacinia dolor. Duis a lacinia nunc, et sodales velit. Phasellus id lectus non neque gravida elementum. Duis eu turpis augue. Nullam aliquet nisi eget elit ullamcorper, eu interdum tortor dignissim.'
      .toLowerCase()
      .replaceAll(',', '')
      .replaceAll('.', '');

  int step=0;

  late int lastStepAt;
  void updateLastTypeAt(){
    this.lastStepAt= DateTime.now().millisecondsSinceEpoch;
  }

  void onUserNameType(String value){
   setState(() {
     this.userName=value;
   });
  }
  void onType(String value){
    updateLastTypeAt();
  String trimmedValue=lorem.trimLeft();
  if(trimmedValue.indexOf(value) !=0 ){
   setState(() {
     step=2;
   });
  }else {
    typedCharLength=value.length;
  }
  }
  void resetGame(){
    setState(() {
      step=0;
      typedCharLength=0;
    });

  }
  void onStartClick() {
    setState(() {
      updateLastTypeAt();

      step++;

    });
   var timer= Timer.periodic(new Duration(seconds: 1), (timer) {
      int now=DateTime.now().millisecondsSinceEpoch;
      //Gameover
      setState(() {
        if(step==1 && now - lastStepAt > 4000) {

          step++;
        }
        if(step!=1){
          timer.cancel();
        }
      });


    });
  }
  @override
  Widget build(BuildContext context) {

   var shownWidget;
   if(step==0)
     shownWidget= <Widget>[
       Text('Oyuna Hoşgeldin. Başlamaya Hazır mısın?'),
       Container(
         padding: EdgeInsets.only(top:10),
         child:
           TextField(
             onChanged: onUserNameType,
             obscureText: false,
             decoration: InputDecoration(
               border: OutlineInputBorder(),
               labelText: 'İsmin Nedir',
             ), // InputDecoration
           ),
       ),
       Container(
        padding: const EdgeInsets.only(top:20),
        child: ElevatedButton(
          child: Text('Oyuna Başla'),
          onPressed: userName.length==0 ? null: onStartClick,

        ),
      )
     ];

     else if(step==1)

    shownWidget= <Widget>[
  Text('$typedCharLength'),
     Container(

       height: 40,
       child: Marquee(
         text: lorem,
         style: TextStyle(fontSize: 24, letterSpacing: 2),
         scrollAxis: Axis.horizontal,
         crossAxisAlignment: CrossAxisAlignment.start,
         blankSpace: 20.0,
         velocity: 125.0,

         startPadding: 0,
         accelerationDuration: Duration(seconds:20),
         accelerationCurve: Curves. ease,
         decelerationDuration: Duration(milliseconds: 500),
         decelerationCurve: Curves.easeOut,
       ),

     ),
     Padding(
       padding: const EdgeInsets.only(left: 16, right: 16, top: 32),
       child: TextField(
         onChanged: onType,
       autofocus: true,
         obscureText: false,
         decoration: InputDecoration(
           border: OutlineInputBorder(),
           labelText: 'Yaz bakalım',
         ), // InputDecoration
       ), // TextField
     ), // Padding
   ];
     else
     shownWidget= <Widget>[
       Text('Oyun bitti skorunuz $typedCharLength '),
       Container(
         padding: const EdgeInsets.only(top:20),
         child: ElevatedButton(
           child: Text('Yeniden Başla'),
           onPressed: resetGame,

         ),
       )
     ];
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Klavye Delikanlısı')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: shownWidget,
        ),
      ),
    );
  }
}
