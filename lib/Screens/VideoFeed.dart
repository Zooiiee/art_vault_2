import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:lottie/lottie.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:provider/provider.dart';
import '../theme/ThemeProvider.dart'; // Import this if you use provider

class VideoFeed extends StatelessWidget {
  final List<String> videos = [
    'https://player.vimeo.com/external/476751430.sd.mp4?s=80dc24ad67c70c4f3cf9cf1c8edff751766bd086&profile_id=165&oauth2_token_id=57447761',
    'https://player.vimeo.com/external/476751430.sd.mp4?s=80dc24ad67c70c4f3cf9cf1c8edff751766bd086&profile_id=165&oauth2_token_id=57447761',
    'https://assets.mixkit.co/videos/preview/mixkit-detailed-painting-of-an-artist-on-the-plants-of-an-41610-large.mp4',
    'https://player.vimeo.com/external/476751430.sd.mp4?s=80dc24ad67c70c4f3cf9cf1c8edff751766bd086&profile_id=165&oauth2_token_id=57447761',
    'https://player.vimeo.com/external/466073950.sd.mp4?s=09b22d2d4e7b973a67d7f55d2f5ab908bca16869&profile_id=165&oauth2_token_id=57447761',
    'https://assets.mixkit.co/videos/preview/mixkit-winter-fashion-cold-looking-woman-concept-video-39874-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-womans-feet-splashing-in-the-pool-1261-large.mp4',
    'https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4'
  ];
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              //We need swiper for every content
              Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return ContentScreen(
                    src: videos[index],
                  );
                },
                itemCount: videos.length,
                scrollDirection: Axis.vertical,
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContentScreen extends StatefulWidget {
  final String? src;

  const ContentScreen({Key? key, this.src}) : super(key: key);

  @override
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _liked = false;
  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(widget.src!);
    await Future.wait([_videoPlayerController.initialize()]);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      showControls: false,
      looping: true,
    );
    setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final backgroundColor = themeProvider.isDarkModeEnabled
        ? Color(0xFF231A12) // Very Very Dark Brown
        : Color(0xFFEbd2a9);
    return Stack(
      fit: StackFit.expand,
      children: [
        _chewieController != null &&
            _chewieController!.videoPlayerController.value.isInitialized
            ? GestureDetector(
          onDoubleTap: () {
            setState(() {
              _liked = !_liked;
            });
          },
          child: FittedBox(
            fit: BoxFit.cover,
            child: Chewie(
              controller: _chewieController!,
            ),
          ),
        )
            : Container(
          color: backgroundColor,

              child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              Lottie.asset(
                'assets/lotties/golden-loading.json', // Replace with the path to your Lottie animation
                width: 300,
                height: 300,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 10),
           // Text('Loading...')
          ],
        ),
            ),
        if (_liked)
          Center(
            child: LikeIcon(),
          ),
        OptionsScreen()
      ],
    );
  }
}

class LikeIcon extends StatelessWidget {
  Future<int> tempFuture() async {
    return Future.delayed(Duration(seconds: 0));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: tempFuture(),
        builder: (context, snapshot) =>
        snapshot.connectionState != ConnectionState.done
            ? Icon(Icons.favorite, size: 110)
            : SizedBox(),
      ),
    );
  }
}


class OptionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(height: 110),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Color(0xFFEbd2a9),
                        child: Icon(Icons.person, color:Color(0xFF231A12),size: 18),
                        radius: 16,
                      ),
                      SizedBox(width: 6),
                      Text('ArtVault',style: TextStyle(color: Colors.white, fontSize: 16),),
                      SizedBox(width: 10),
                      Icon(Icons.verified, size: 16 ,color: Color(0xFFEbd2a9),),
                      SizedBox(width: 6),
                      // TextButton(
                      //   onPressed: () {},
                      //   // child: Text(
                      //   //   'Follow',
                      //   //   style: TextStyle(
                      //   //     color: Colors.white,
                      //   //   ),
                      //   // ),
                      // ),
                    ],
                  ),
                  SizedBox(width: 6,height: 8,),
                  Text('\t\t\t\t\t\t\t\tComing Soon 💙❤💛 ....',style: TextStyle(color: Colors.white),),
                  SizedBox(height: 10),
                  // Row(
                  //   children: [
                  //     Icon(
                  //       Icons.music_note,
                  //       size: 15,
                  //     ),
                  //     Text('Original Audio - some music track--'),
                  //   ],
                  // ),
                ],
              ),
              // Column(
              //   children: [
              //     Icon(Icons.favorite_outline),
              //     Text('601k'),
              //     SizedBox(height: 20),
              //     Icon(Icons.comment_rounded),
              //     Text('1123'),
              //     SizedBox(height: 20),
              //     Transform(
              //       transform: Matrix4.rotationZ(5.8),
              //       child: Icon(Icons.send),
              //     ),
              //     SizedBox(height: 50),
              //     Icon(Icons.more_vert),
              //   ],
              // )
            ],
          ),
        ],
      ),
    );
  }
}