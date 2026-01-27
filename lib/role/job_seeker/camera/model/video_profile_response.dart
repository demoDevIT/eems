class VideoProfileResponse {
  int state;
  bool status;
  String message;
  String? errorMessage;
  List<VideoData> data;

  VideoProfileResponse({
    required this.state,
    required this.status,
    required this.message,
    this.errorMessage,
    required this.data,
  });

  factory VideoProfileResponse.fromJson(Map<String, dynamic> json) {
    return VideoProfileResponse(
      state: json['State'],
      status: json['Status'],
      message: json['Message'],
      errorMessage: json['ErrorMessage'],
      data: (json['Data'] as List)
          .map((item) => VideoData.fromJson(item))
          .toList(),
    );
  }


}

class VideoData {
  String videoPath;

  VideoData({required this.videoPath});

  factory VideoData.fromJson(Map<String, dynamic> json) {
    return VideoData(
      videoPath: json['VideoPath'] ?? "",
    );
  }


}
