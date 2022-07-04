import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {

  SpeechToText _speechToText = SpeechToText();

  bool listening = false;
  bool speechEnabled = false;
  String? s = "Press and Speak";
  String? word;

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void startListening() async {
    try{

      await _speechToText.listen(onResult: onSpeechResult,listenFor: Duration(seconds: 2)).catchError((e){
        print("Error: $e");
      });
      setState(() {
        if(_speechToText.isListening){
          listening = true;
          s = "Listening";
          setState(() {});
        }else{
          print("Listening Not working");
        }
      });
    }catch (e){
      print("ERROR: $e");
    }

    setState(() {});

  }

  void stopListening() async {
    try{
      await _speechToText.stop();
      setState(() {
        if(_speechToText.isNotListening){
          listening = false;
          s = "Stop Listening";
          setState(() {});
        }else{
          print("Listening Not stooping");
        }
      });
    }catch (e){
      print("ERROR: $e");
    }

    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      word = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    double mediaQH = MediaQuery.of(context).size.height;
    double mediaQW = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: mediaQH,
        width: mediaQW,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: mediaQH*0.75,
              width: mediaQW*0.9,
              alignment: Alignment.center,
              color: Colors.white,
              child: Text(word ?? s!,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.75),
                  fontSize: mediaQW*0.0325,
                  fontWeight: FontWeight.w600,
              ),),
            ),
            GestureDetector(
              onTap: (){
                if(listening == false){
                  startListening();
                }else{
                  stopListening();
                }
              },
              child: Container(
                height: mediaQW*0.2,
                width: mediaQW*0.2,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: speechEnabled == true ?
                listening == false ?
                Icon(Icons.hearing_disabled,color: Colors.white,) :
                Icon(Icons.hearing,color: Colors.white,) :
                Icon(Icons.cancel,color: Colors.white,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
