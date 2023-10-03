import 'package:flutter/material.dart';
import 'package:art_vault_2/Widgets/ArtListView.dart';

import 'ConnectScreen.dart';


class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({Key? key}) : super(key: key);

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF463B2B) ,
      body: Stack(
        children: [
      Container(
      decoration: BoxDecoration(
      image: DecorationImage(
          image:  AssetImage('assets/brown.jpg'),
      fit: BoxFit.cover,
    )
    ) ,
      ),
          Positioned.fill(
            child: ShaderMask(
              blendMode: BlendMode.dstOut,
              shaderCallback: (rect) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(0.9),
                    Colors.black,
                  ],
                  stops: const [0, 0.62, 0.67, 0.85, 1],
                ).createShader(rect);
              },
              child: const SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 30),
                    ImageListView(
                      startIndex: 1,
                      duration: 25,
                    ),
                    SizedBox(height: 10),
                    ImageListView(
                      startIndex: 11,
                      duration: 45,
                    ),
                    SizedBox(height: 10),
                    ImageListView(
                      startIndex: 21,
                      duration: 65,
                    ),
                    SizedBox(height: 10),
                    ImageListView(
                      startIndex: 31,
                      duration: 35,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            left: 24,
            right: 24,
            child: Container(
              height: 170,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text("Discover ArtVault",style:TextStyle(fontSize: 32,color:  Color(0xFFEbd2a9),fontWeight: FontWeight.w600),textAlign: TextAlign.center,),
                  SizedBox(
                    height: 15,
                  ),
                  const SizedBox(height: 2),
                  const Text("Your Gateway to the Extraordinary World of Art",style:TextStyle(fontSize: 18,color: Colors.grey),),
                  const Spacer(),
                  Container(
                    width: 140,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xFFEbd2a9),
                    ),
                    child: Material(
                      elevation: 40,
                      color: Color(0xFFEbd2a9),
                      borderRadius: BorderRadius.circular(10),
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> ConnectScreen()));
                        },
                        minWidth: 340,
                        height: 42,
                        child: Text(
                          'Get Started',
                          style: TextStyle(
                            color:Color(0xFF463B2B),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}