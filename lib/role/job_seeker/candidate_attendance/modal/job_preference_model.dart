class JobPreferenceModel {
  final String company;
  final String sector;
  final String title;

  JobPreferenceModel({
    required this.company,
    required this.sector,
    required this.title,
  });

  factory JobPreferenceModel.fromJson(Map<String, dynamic> json) {
    return JobPreferenceModel(
      company: json['CompanyName'] ?? '',
      sector: json['jobsector'] ?? '',
      title: json['jobtitle'] ?? '',
    );
  }
}
