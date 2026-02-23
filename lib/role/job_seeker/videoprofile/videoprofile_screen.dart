import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/job_seeker/videoprofile/provider/videoprofile_provider.dart';
import 'package:rajemployment/utils/live_video_player.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../camera/camera_page.dart';

class VideoprofileScreen extends StatefulWidget {
  const VideoprofileScreen({super.key});

  @override
  State<VideoprofileScreen> createState() => _VideoprofileScreenState();
}

class _VideoprofileScreenState extends State<VideoprofileScreen> {
var videoProvider;
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<VideoprofileProvider>(context, listen: false)
          .getVideo(context);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Video Profile",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<VideoprofileProvider> (builder: (context, provider, child) => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top Text Section
              const Text(
                "Record Your Live Introduction Video (Optional)",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Record your video profile in 4 short steps. Let employers know the real you!",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 20),

              /// First Card (Image1)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F9F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Image.asset(
                          "assets/images/videProImgOne.png",
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// Text right
                    const Expanded(
                      flex: 2,
                      child: Text(
                        "Create Your 45-Second Video Introduction",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              /// Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Skip",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () async {
                   String Video = await Navigator.push(context, MaterialPageRoute(builder: (context) => CameraPage()),);
                   if(Video == "True"){
                     videoProvider.getVideo(context);
                   }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kViewAllColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Start Recording",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        SvgPicture.asset(
                          "assets/icons/video.svg",
                          height: 18,
                          width: 18,
                          color: Colors.white,
                        ),
                      ],
                    ),

                  ),
                ],
              ),
              const SizedBox(height: 20),

              /// Second Image with Overlay Text Button

              if (provider.VideoPath.isNotEmpty)
               // SizedBox(
               //    child:
                  LiveVideoPlayer(
                    key: ValueKey(provider.VideoPath[0].videoPath),
                    url: provider.VideoPath[0].videoPath ?? "",
                  ),
                //),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      "assets/images/videProImgTwo.png",
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      color: Colors.black45,
                      width: double.infinity,
                      height: 180,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "How to Record",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text("Click here.."),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void buildContext(BuildContext context, videoProvider) {
  //   videoProvider.getVideo(context);
  // }

}
