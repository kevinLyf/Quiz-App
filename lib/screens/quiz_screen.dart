import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quiz/models/question.dart';
import 'package:auto_size_text/auto_size_text.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Question> questions = [];
  bool _loading = true;
  int _currentQuestion = 0;
  int _selected = -1;
  int _points = 0;

  @override
  void initState() {
    super.initState();
    getQuestions().then((value) => setState(() => _loading = false));
  }



  Future<void> getQuestions() async {
    questions.clear();
    var response =
        await http.get(Uri.parse('https://the-trivia-api.com/v2/questions'));
    var jsonData = jsonDecode(response.body);

    for (var eachQuestion in jsonData) {
      List answers = [];

      eachQuestion['incorrectAnswers'].forEach((value) {
        answers.add(value);
      });

      answers.insert(
          Random().nextInt(eachQuestion['incorrectAnswers'].length + 1),
          eachQuestion['correctAnswer']);

      Question question = Question(
        title: eachQuestion['question']['text'],
        correctAnswer: eachQuestion['correctAnswer'],
        answers: answers,
        tags: eachQuestion['tags'],
        difficulty: eachQuestion['difficulty'],
        category: eachQuestion['category'],
      );

      questions.add(question);
    }
  }

  Color getAnswerColor(int selected, int currentQuestion, List questions,
      int index, bool border) {
    if (selected == index &&
        questions[currentQuestion].answers[selected] ==
            questions[currentQuestion].correctAnswer) {
      return const Color(0xff42b4a5);
    } else if (selected == index &&
        questions[currentQuestion].answers[selected] !=
            questions[currentQuestion].correctAnswer) {
      return const Color(0xffca4b4b);
    } else if (selected != index &&
        questions[currentQuestion].answers[index] ==
            questions[currentQuestion].correctAnswer) {
      return const Color(0xff42b4a5);
    } else {
      if (border) {
        return const Color(0xff42b4a5);
      }
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 70,
        backgroundColor: const Color(0xff42b4a5),
        leading: IconButton(
          onPressed: () {
            showDialog(
              barrierDismissible: true,
              context: context,
              builder: (_) => AlertDialog(
                title: const Text(
                  'Are you sure ?',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                content: const Text(
                  'You will lose your answers.',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Dialog(
                            insetPadding: EdgeInsets.zero,
                            elevation: 2,
                            backgroundColor: const Color(0xff42b4a5),
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Continue',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Dialog(
                            insetPadding: EdgeInsets.zero,
                            backgroundColor: const Color(0xffca4b4b),
                            elevation: 2,
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Leave',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 27,
          ),
        ),
      ),
      body: SafeArea(
        child: _loading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xff42b4a5),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    Container(
                      width: 500,
                      height: 300,
                      padding: const EdgeInsets.all(15),
                      decoration: const BoxDecoration(color: Color(0xffffe185)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white24,
                                border:
                                    Border.all(width: 3, color: Colors.black26)),
                            child: Text(
                              '${_currentQuestion + 1}/${questions.length}',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: AutoSizeText(
                              questions[_currentQuestion].title,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: List.generate(
                        questions[_currentQuestion].answers.length,
                        (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(
                                () {
                                  if (_selected == -1) {
                                    _selected = index;

                                    if (questions[_currentQuestion]
                                            .answers[_selected] ==
                                        questions[_currentQuestion]
                                            .correctAnswer) {
                                      _points++;
                                    }

                                    if (_currentQuestion + 1 <
                                        questions.length) {
                                      Timer(
                                          const Duration(
                                              seconds: 1, milliseconds: 5), () {
                                        setState(() {
                                          _selected = -1;
                                          _currentQuestion++;
                                        });
                                      });
                                    } else {
                                      Timer(
                                        const Duration(
                                            seconds: 1, milliseconds: 5),
                                        () {
                                          showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            useSafeArea: true,
                                            builder: (_) => AlertDialog(
                                              contentPadding:
                                                  const EdgeInsets.all(20),
                                              insetPadding:
                                                  const EdgeInsets.all(20),
                                              title: Text(
                                                '$_points/${questions.length}',
                                                style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: _points < 5
                                                    ? <Widget>[
                                                        Image.asset(
                                                            'assets/gifs/lose.gif'),
                                                        const Text(
                                                          'Yeah.. today was not your day...',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ]
                                                    : <Widget>[
                                                        Image.asset(
                                                            'assets/gifs/win.gif'),
                                                        const Text(
                                                          'Congratulations... you are THE BRAIN',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                              ),
                                              actions: [
                                                Dialog(
                                                  elevation: 2,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(
                                                        () {
                                                          Navigator.of(context)
                                                              .pop();
                                                          _selected = -1;
                                                          _points = 0;
                                                          _currentQuestion = 0;
                                                          _loading = true;
                                                          getQuestions().then(
                                                            (value) => setState(
                                                              () {
                                                                _loading =
                                                                    false;
                                                              },
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Container(
                                                      width: double.maxFinite,
                                                      height: 60,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: const Color(
                                                            0xff42b4a5),
                                                      ),
                                                      child: const Center(
                                                        child: Text(
                                                          'Retry',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Dialog(
                                                  insetPadding:
                                                      const EdgeInsets.only(
                                                          bottom: 10),
                                                  elevation: 0,
                                                  child: TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text(
                                                      'Menu',
                                                      style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  }
                                },
                              );
                            },
                            child: Container(
                              width: double.maxFinite,
                              height: 75,
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _selected == -1
                                    ? Colors.white
                                    : getAnswerColor(
                                        _selected,
                                        _currentQuestion,
                                        questions,
                                        index,
                                        false),
                                border: Border.all(
                                  width: 3,
                                  color: _selected == -1
                                      ? const Color(0xff42b4a5)
                                      : getAnswerColor(
                                          _selected,
                                          _currentQuestion,
                                          questions,
                                          index,
                                          true),
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: AutoSizeText(
                                  questions[_currentQuestion].answers[index],
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: _selected == index ||
                                            _selected != -1 &&
                                                questions[_currentQuestion]
                                                        .answers[index] ==
                                                    questions[_currentQuestion]
                                                        .correctAnswer
                                        ? Colors.white
                                        : const Color(0xff42b4a5),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
