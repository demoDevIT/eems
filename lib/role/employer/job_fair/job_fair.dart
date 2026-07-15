import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../job_seeker/job_fair_event/jobs_fair_event.dart';
import '../../job_seeker/job_fair_event/registered_event_list.dart';
import '../job_application/job_application.dart';
import '../job_post/job_post.dart';

class JobFairScreen extends StatelessWidget {
  const JobFairScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Job Fair"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF2F4F8),
      // body: Padding(
      //   padding: const EdgeInsets.all(16),
      //   child: Column(
      //     children: [
      //       _jobFairListTile(
      //         title: "Events",
      //         iconPath: "assets/images/events.svg",
      //         color: const Color(0xFF6C63FF),
      //         onTap: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) => JobsFairEventScreen(),
      //             ),
      //           );
      //         },
      //       ),
      //
      //       _jobFairListTile(
      //         title: "Registered Events",
      //         iconPath: "assets/images/regEvents.svg",
      //         color: const Color(0xFF2DBE8D),
      //         onTap: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) => RegisteredEventListScreen(),
      //             ),
      //           );
      //         },
      //       ),
      //
      //       _jobFairListTile(
      //         title: "Post Jobs in Job Fair",
      //         iconPath: "assets/images/postJob.svg",
      //         color: const Color(0xFF2DBE8D),
      //         onTap: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) => JobPostScreen(),
      //             ),
      //           );
      //         },
      //       ),
      //
      //       _jobFairListTile(
      //         title: "Job Fair Applications",
      //         iconPath: "assets/images/jobapp.svg",
      //         color: const Color(0xFF2DBE8D),
      //         onTap: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) => JobApplicationScreen(),
      //             ),
      //           );
      //         },
      //       ),
      //     ],
      //   ),
      // ),

      body: _buildJobFairGrid(context),
    );
  }

  Widget _buildJobFairGrid(BuildContext context) {
    final items = [
      _JobFairItem(
        title: "Events",
        iconPath: "assets/images/events.svg",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => JobsFairEventScreen(),
            ),
          );
        },
      ),

      _JobFairItem(
        title: "Registered Events",
        iconPath: "assets/images/regEvents.svg",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RegisteredEventListScreen(),
            ),
          );
        },
      ),

      _JobFairItem(
        title: "Post Jobs in Job Fair",
        iconPath: "assets/images/postJob.svg",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => JobPostScreen(),
            ),
          );
        },
      ),

      _JobFairItem(
        title: "Job Fair Applications",
        iconPath: "assets/images/jobapp.svg",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => JobApplicationScreen(),
            ),
          );
        },
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.builder(
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.38,
        ),
        itemBuilder: (context, index) {
          final item = items[index];

          return GestureDetector(
            onTap: item.onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    item.iconPath,
                    width: 50,
                    height: 50,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _jobFairListTile({
    required String title,
    required String iconPath,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            child: Row(
              children: [
                // SVG Icon Box
                Container(
                  height: 45,
                  width: 45,
                  // decoration: BoxDecoration(
                  //   color: color.withOpacity(0.15),
                  //   borderRadius: BorderRadius.circular(12),
                  // ),
                  child: Center(
                    child: SvgPicture.asset(
                      iconPath,
                      height: 42,
                      width: 42,
                      // colorFilter:
                      // ColorFilter.mode(color, BlendMode.srcIn),
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                // Title
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // Arrow
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _jobFairTile({
    required String title,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF4A76C9),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _JobFairItem {
  final String title;
  final String iconPath;
  final VoidCallback onTap;

  _JobFairItem({
    required this.title,
    required this.iconPath,
    required this.onTap,
  });
}