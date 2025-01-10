import 'package:flutter/material.dart';
import 'package:bnbscout24/constants/constants.dart';
import 'package:bnbscout24/constants/sizes.dart';
import 'package:bnbscout24/data/question.dart';
import 'package:bnbscout24/pages/quizpage.dart';
import 'package:bnbscout24/utils/open_trivia_communication.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Sizes().initialize(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: black,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image(
                  image: AssetImage("images/tiny_quiz_logo.png"),
                  height: Sizes.heightPercent * 10,
              ),
              GestureDetector(
                onTap: () async{
                  var q = await Question.getQuestions();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => QuizPage(questions: q, score: 0,)),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: Sizes.paddingBig, vertical: Sizes.paddingSmall),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(Sizes.borderRadiusBig),
                  ),
                  child: Text(
                      "Play",
                      style: TextStyle(
                        color: white,
                        fontSize: Sizes.textSizeRegular
                      )
                  ),

                )
              )
            ],
          ),
        )
      )
    );
  }
}
