class CreateFeedbackRequest {
  final String topic;
  final String? exerciseId;
  final String? taskId;
  final String? taskSessionId;
  final double rating;
  final String? feedback;
  final CreateFeedbackRequestEnvironment environment;

  CreateFeedbackRequest({
    required this.topic,
    this.exerciseId,
    this.taskId,
    this.taskSessionId,
    required this.rating,
    this.feedback,
    required this.environment,
  });

  toJson() => {
        'topic': topic,
        'exerciseId': exerciseId,
        'taskId': taskId,
        'taskSessionId': taskSessionId,
        'rating': rating,
        'environment': environment.toJson(),
      };
}

class CreateFeedbackRequestEnvironment {
  final String device;
  final String platform;
  final String platformVersion;
  final String appVersion;
  final String appStage;

  CreateFeedbackRequestEnvironment({
    required this.device,
    required this.platform,
    required this.platformVersion,
    required this.appVersion,
    required this.appStage,
  });

  toJson() => {
        'device': device,
        'platform': platform,
        'platformVersion': platformVersion,
        'appVersion': appVersion,
        'appStage': appStage,
      };
}
