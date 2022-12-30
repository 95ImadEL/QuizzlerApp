import 'package:flutter/material.dart';
import 'package:quizler_app/quiz_brain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() {
  runApp(Quizzler());
}

class Quizzler extends StatelessWidget {
  const Quizzler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> scoreKeeper = [];
  QuizBrain quizBrain = QuizBrain();

  void checkAnswer(bool userPickedAnswer) {
    //The user picked true
    bool correctAnswer = quizBrain.getCorrectAnswer();
    setState(() {
      if (quizBrain.isFinished() == false) {
        if (userPickedAnswer == correctAnswer) {
          scoreKeeper.add(Icon(
            Icons.check,
            color: Colors.green,
          ));
          quizBrain.updateScore();
        } else {
          scoreKeeper.add(Icon(
            Icons.close,
            color: Colors.red,
          ));
        }
      }
      if (quizBrain.isFinished() == true) {
        int finalScore = quizBrain.getFinalScore();
        int totalQuestion = quizBrain.getQuizLength();
        Alert(
          context: context,
          title: "Finished",
          desc:
              "You've reached the end of the quiz. You got $finalScore/$totalQuestion \n "
              "Tap retry to reload the quiz",
          buttons: [],
        ).show();
      } else {
        quizBrain.nextQuestion();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80.0),
          child: TextButton(
            onPressed: () {
              setState(() {
                quizBrain.reset();
                scoreKeeper.clear();
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Retry Quiz",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.repeat,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestionText(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              color: Colors.green,
              child: TextButton(
                child: Text(
                  "True",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                onPressed: () {
                  checkAnswer(true);
                },
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              color: Colors.red,
              child: TextButton(
                child: Text(
                  "False",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                onPressed: () {
                  //The user picked false.
                  checkAnswer(false);
                },
              ),
            ),
          ),
        ),
        Row(
          children: scoreKeeper,
        )
      ],
    );
  }
}
