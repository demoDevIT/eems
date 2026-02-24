class AllJobSectorListModal {
  int? state;
  String? message;
  List<JobSectorData>? data;

  AllJobSectorListModal({this.state, this.message, this.data});

  AllJobSectorListModal.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    message = json['Message'];

    if (json['Data'] != null) {
      data = <JobSectorData>[];
      json['Data'].forEach((v) {
        data!.add(JobSectorData.fromJson(v));
      });
    }
  }
}

class JobSectorData {
  int? id;
  String? sectorName;

  JobSectorData({this.id, this.sectorName});

  JobSectorData.fromJson(Map<String, dynamic> json) {
    id = json['ID'];                  // ✅ FIXED
    sectorName = json['Name_ENG'];    // ✅ FIXED
  }
}