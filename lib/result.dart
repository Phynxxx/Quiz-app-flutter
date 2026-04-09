import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  final int totalScore;
  final VoidCallback resetQuiz;

  const Result(this.totalScore, this.resetQuiz);

  String get resultPhrase {
    var resultText;
    if (totalScore <= 20) {
      resultText = 'You Failed :( \n Your Score: $totalScore';
    } else {
      resultText = 'You Passed :) \n Your Score: $totalScore';
    }
    return resultText;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        Text(
          resultPhrase,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        ElevatedButton(
          onPressed: resetQuiz,
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
            backgroundColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.pressed)) return Colors.green;
                return Colors.blue;
              },
            ),
          ),
          child: const Text("Restart Quiz!"),
        )
      ],
    ));
  }
}
