class UploadResponse {
  final bool success;
  final String message;
  final String fileName;
  final String filePath;

  UploadResponse({
    required this.success,
    required this.message,
    required this.fileName,
    required this.filePath,
  });

  factory UploadResponse.fromJson(Map<String, dynamic> json) {
    return UploadResponse(
      success: json['Success'] ?? false,
      message: json['Message'] ?? '',
      fileName: json['FileName'] ?? '',
      filePath: json['FilePath'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Success': success,
      'Message': message,
      'FileName': fileName,
      'FilePath': filePath,
    };
  }
}
