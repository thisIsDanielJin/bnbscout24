import 'package:bnbscout24/utils/open_trivia_communication.dart';


class Question {
  final String question;
  final String difficulty;
  final String correctAnswer;
  final List<String> allAnswers;
  final String category;

  Question(
      {required this.question,
      required this.category,
      required this.correctAnswer,
      required this.difficulty,
      required this.allAnswers});

  static fromJson(Map<String, dynamic> json) {
    String correctAnswer = json["correct_answer"];
    List<String> allAnswers = List<String>.from(json["incorrect_answers"]);
    allAnswers.add(correctAnswer);
    String question = json["question"];
    String difficulty = json["difficulty"];
    String category = json["category"];

    return Question(
        question: question,
        category: category,
        correctAnswer: correctAnswer,
        difficulty: difficulty,
        allAnswers: allAnswers);
  }

  static Future<List<Question>> getQuestions() async{
    List<Question> questions = [];
    Map<String, dynamic> json = await OpenTriviaCommunication.getQuizQuestions();
    List<dynamic> questionData = json["results"];

    questions.addAll(questionData.map((x) => Question.fromJson(x)));

    return questions;
  }
}
