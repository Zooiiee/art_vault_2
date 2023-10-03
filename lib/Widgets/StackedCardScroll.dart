import 'package:art_vault_2/Data/data.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lottie/lottie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:art_vault_2/Screens/api_config.dart';


class CardScrollWidget extends StatefulWidget{
  var currentPage;
  CardScrollWidget(this.currentPage);
  @override
  State<CardScrollWidget> createState() => _CardScrollWidgetState();
}
var cardAspectRatio =12.0/16.0;
var widgetAspectRatio = cardAspectRatio *1.2;


class _CardScrollWidgetState extends State<CardScrollWidget> {

  var padding=10.0;
  bool isFavorite = false;
  var verticalInset = 20.0;
  List<dynamic> artworks = [];


  @override
  void initState() {
    super.initState();
    fetchArtworks();
  }

  Future<void> fetchArtworks() async {
    final apiUrl = Uri.parse('${ApiConfig.baseUrl}/artworks'); // Replace with your server URL

    try {
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          artworks = data;
        });
      } else {
        // Handle error cases
        print('Failed to fetch artworks: ${response.statusCode}');
      }
    } catch (error) {
      print('HTTP request error: $error');
    }
  }


  @override
  List<bool> isFavoriteList = List.filled(mediaItems.length, false);
  Widget build(BuildContext context){

    return AspectRatio(
      aspectRatio: widgetAspectRatio,
      child: LayoutBuilder(
        builder: (context,constraints){
          var width = constraints.maxWidth;
          var height = constraints.maxHeight;
          var safeWidth = width - 2 * padding;
          var safeHeight = height - 2 * padding;
          var heightOfPrimaryCard = safeHeight;
          var widthOfPrimaryCard = heightOfPrimaryCard * cardAspectRatio;
          var primaryCardLeft = safeWidth -widthOfPrimaryCard;
          var horizontalInsets = primaryCardLeft / 2;

          List<Widget> cardList =[];

          for (var i = 0; i < artworks.length; i++) {
            final artwork = artworks[i];

            // Extract artwork details from artwork object
            final imageUrl = artwork['artworkUrl'];
            final artworkid = artwork['artworkId'];
            final title = artwork['title'];
            var delta = i - widget.currentPage;
            bool isOnRight = delta >0;

            var start = padding + max(primaryCardLeft - horizontalInsets * -delta * (isOnRight ? 15 : 1),0.0);

            var cardItem = Positioned.directional(
              top: padding + verticalInset * max(-delta,0.0),
              bottom:  padding + verticalInset * max(-delta,0.0),
              start : start,
              textDirection: TextDirection.rtl,
              child: artworks.isEmpty
                  ? Center(
                child: Column(
                  children: [
                    Lottie.asset('assets/lotties/placeholder.json', height: 200,width: 200),
                    SizedBox(height: 16),

                  ],
                ),
              )
                  :ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Container(
                  color: Color(0xFF52412E),
                  // decoration: const BoxDecoration(
                  //     // image: DecorationImage(
                  //     //   image: AssetImage('assets/lotties/paint.gif'), // Replace with your GIF URL
                  //     //   fit: BoxFit.cover, // Adjust the fit to your needs
                  //     // ),// Adjust the fit to your needs
                  //     boxShadow:[
                  //       BoxShadow(
                  //           color: Colors.black38,
                  //           offset: Offset(3.0,6.0),
                  //           blurRadius: 10.0
                  //       )
                  //     ]
                  // ),
                  child: AspectRatio(
                    aspectRatio: cardAspectRatio,
                    child: Stack(
                      fit:StackFit.expand,
                      children:<Widget> [
                        CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>Lottie.asset(
                            'assets/pc.json', // Replace with your Lottie animation file path
                            fit: BoxFit.cover,
                          ), // Optional loading indicator
                          errorWidget: (context, url, error) => Icon(Icons.error), // Optional error widget
                        ),

                        Align(
                            alignment: Alignment.bottomLeft,
                            child:SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(padding: EdgeInsets.symmetric(
                                      horizontal: 16.0,vertical: 8.0
                                  ),
                                    child: Text(title,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.w600,
                                      ),),
                                  ),
                                  SizedBox(height: 6,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0,bottom: 10.0),
                                    child: Container(
                                        child:ElevatedButton(
                                            onPressed: (){ //Navigator.push(context, MaterialPageRoute(builder: (context)=> WelcomeScreen()));
                                            },
                                            child: Text("Know More"),
                                            style:ElevatedButton.styleFrom(
                                              shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(40) ),
                                              side: BorderSide(color:const Color(0xFF52412E)),
                                              backgroundColor:  const Color(0xFFEAD2A8),
                                              foregroundColor: const Color(0xFF52412E),
                                              padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 20),
                                            )
                                        )
                                    ),
                                  )
                                ],
                              ),
                            )
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
            cardList.add(cardItem);
          }
          return Stack(
            children: cardList,
          );
        },
      ),
    );
  }
}

