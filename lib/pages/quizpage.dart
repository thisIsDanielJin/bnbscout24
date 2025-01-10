import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bnbscout24/constants/constants.dart';
import 'package:bnbscout24/constants/sizes.dart';
import 'package:bnbscout24/data/question.dart';

class QuizPage extends StatefulWidget {
  List<Question> questions;
  int score;

  QuizPage({super.key, required this.questions, required this.score});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  static bool answered = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: black,
      body: Container(
          padding: EdgeInsets.all(Sizes.paddingSmall),
          child: Column(children: [
            Row(

              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.favorite, size: Sizes.iconSize, color: purple),
                    Icon(Icons.favorite, size: Sizes.iconSize, color: purple),
                    Icon(Icons.favorite, size: Sizes.iconSize, color: purple)
                  ],

                ),
                Text(
                  "Score: ${widget.score}",
                  style: TextStyle(color: white, fontSize: Sizes.textSizeSmall),
                )
              ],
            ),
            Expanded(

              child: Container(
                decoration: BoxDecoration(
                    color: darkGrey,
                    borderRadius: BorderRadius.circular(Sizes.borderRadius)),
                child: Center(
                    child: Text(
                  widget.questions[0].question,
                  style:
                      TextStyle(color: white, fontSize: Sizes.textSizeRegular),
                  textAlign: TextAlign.center,
                )),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: widget.questions[0].allAnswers.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        print("answered");
                        setState(() {
                          answered = !answered;
                        });
                      },
                        child: Container(
                      margin: EdgeInsets.only(top: Sizes.paddingSmall),
                      padding: EdgeInsets.symmetric(
                          vertical: Sizes.paddingSmall * 1.25,
                          horizontal: Sizes.paddingSmall),
                      decoration: BoxDecoration(
                          color: darkGrey,
                          borderRadius:
                              BorderRadius.circular(Sizes.borderRadius)),
                      child: Center(
                        child: Text(
                          "${widget.questions[0].allAnswers[index]}",
                          style: TextStyle(
                              color: white, fontSize: Sizes.textSizeSmall),
                        ),
                      ),
                    ));
                  }),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: Sizes.paddingSmall),
              decoration: BoxDecoration(
                color: answered ? yellow : lightGrey,
                borderRadius: BorderRadius.circular(Sizes.borderRadiusBig)
              ),
              child: Center(
                child: Text("Next question"),
              )
            )
          ])),
    ));
  }
}
