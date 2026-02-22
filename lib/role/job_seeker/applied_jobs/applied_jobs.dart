import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/colors.dart';
import '../../../repo/common_repo.dart';
import 'provider/applied_jobs_provider.dart';

class AppliedJobsScreen extends StatefulWidget {
  const AppliedJobsScreen({super.key});

  @override
  State<AppliedJobsScreen> createState() => _AppliedJobsScreenState();
}

class _AppliedJobsScreenState extends State<AppliedJobsScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<AppliedJobsProvider>(context, listen: false)
          .getAppliedJobsApi(context);
    });
  }

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
          body: provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : provider.appliedJobs.isEmpty
              ? const Center(child: Text("No Applied Jobs Found"))
              : Padding(
            padding: const EdgeInsets.all(16),
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
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.work),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              job.jobTitle ?? "",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(job.companyName ?? ""),
                            const SizedBox(height: 4),
                            Text("₹${job.salary ?? 0}"),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    size: 14,
                                    color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(job.locations ?? ""),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius:
                                BorderRadius.circular(6),
                              ),
                              child: Text(
                                job.employementType ?? "",
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.green),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
