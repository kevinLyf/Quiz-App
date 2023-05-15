class Question {
  final String title;
  final String correctAnswer;
  final List answers;
  final List tags;
  final String difficulty;
  final String category;

  Question({
    required this.title,
    required this.correctAnswer,
    required this.answers,
    required this.tags,
    required this.difficulty,
    required this.category,
  });
}
