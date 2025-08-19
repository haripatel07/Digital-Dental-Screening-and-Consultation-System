class ResultModel {
  final String disease;
  final double confidence;
  final String recommendation;
  final String imagePath;

  ResultModel({
    required this.disease,
    required this.confidence,
    required this.recommendation,
    required this.imagePath,
  });
}
