class QuizQuestion {
  final String question;
  final List<String> options;
  const QuizQuestion({required this.question, required this.options});
}

const List<QuizQuestion> quizQuestions = [
  QuizQuestion(
    question: 'A perfect Sunday looks like…',
    options: [
      'A long walk somewhere I\'ve never been',
      'Slow coffee and a good book',
      'Friends, music, and nothing planned',
      'Alone, quietly working on something I love',
    ],
  ),
  QuizQuestion(
    question: 'When things get hard, I\'m the person who…',
    options: [
      'Talks it through with someone I trust',
      'Goes quiet and processes internally',
      'Throws myself into work or movement',
      'Writes, draws, or creates my way through it',
    ],
  ),
  QuizQuestion(
    question: 'What draws me to someone first?',
    options: [
      'The way they think',
      'How they make me laugh',
      'Their calm, grounded presence',
      'A spark of curiosity and ambition',
    ],
  ),
  QuizQuestion(
    question: 'I feel most myself when…',
    options: [
      'Deep in conversation with one person',
      'Moving — a hike, a dance floor, a run',
      'Making something with my hands',
      'Stretching my mind with ideas or problems',
    ],
  ),
  QuizQuestion(
    question: 'The value I won\'t compromise on is…',
    options: [
      'Honesty, even when it stings',
      'Kindness, always, to anyone',
      'Growth — becoming a better version',
      'Freedom to live my own way',
    ],
  ),
];
