class Match {
  final String name;
  final int age;
  final String job;
  final double distanceKm;
  final double emotionScore;
  final double personalityScore;
  final double gazeScore;
  final List<String> sharedTags;

  const Match({
    required this.name,
    required this.age,
    required this.job,
    required this.distanceKm,
    required this.emotionScore,
    required this.personalityScore,
    required this.gazeScore,
    required this.sharedTags,
  });
}
