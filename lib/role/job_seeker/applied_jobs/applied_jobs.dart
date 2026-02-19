import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/colors.dart';
import '../../../repo/common_repo.dart';
import 'provider/applied_jobs_provider.dart';

class AppliedJobsScreen extends StatelessWidget {
  const AppliedJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppliedJobsProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            backgroundColor: const Color(0xfff5f6fa),
            appBar: AppBar(
              title: const Text("Applied Jobs"),
              backgroundColor: Colors.white,
              elevation: 0,
              foregroundColor: Colors.black,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// ===========================
                  /// HEADING
                  /// ===========================
                  Text(
                    "Jobs Applied by you (${provider.appliedJobs.length})",
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  /// ===========================
                  /// GRID LIST (LIKE SCREENSHOT)
                  /// ===========================
                  Expanded(
                    child: ListView.builder(
                      itemCount: provider.appliedJobs.length,
                      itemBuilder: (context, index) {
                        final job = provider.appliedJobs[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              /// Image Placeholder
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                ),
                              ),

                              const SizedBox(width: 12),

                              /// Job Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    /// Title
                                    Text(
                                      job["title"],
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    /// Type Badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade100,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        job["type"],
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    /// Salary
                                    Text(
                                      "Salary: ${job["salary"]}",
                                      style: const TextStyle(fontSize: 13),
                                    ),

                                    const SizedBox(height: 6),

                                    /// Company
                                    Text(
                                      job["name"],
                                      style: const TextStyle(fontSize: 13),
                                    ),

                                    const SizedBox(height: 4),

                                    /// Location
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          size: 14,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          job["district"],
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                ],
              ),
            ),
          );
        },
    );
  }
}
