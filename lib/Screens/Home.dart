import 'dart:async';
import 'package:art_vault_2/Screens/EventScreen.dart';
import 'package:art_vault_2/Screens/ProfileScreen.dart';
import 'package:art_vault_2/theme/ThemeProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:swipe_deck/swipe_deck.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:art_vault_2/Data/data.dart';
import 'package:lottie/lottie.dart';
import '../Widgets/EventCards.dart';
import '../Widgets/StackedCardScroll.dart';
import 'package:flip_card/flip_card.dart';
import '../Widgets/StoryOfTheDay.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Widgets/Swiper.dart';
import 'ArtworkDetailScreen.dart';
import 'api_config.dart';
import 'SocialsPage.dart';

class Home extends KFDrawerContent {

  final Function(int) onTap;
  final Function(bool) onDarkModeToggle; // Add this line

  Home({
    required this.onTap,
    required this.onDarkModeToggle,
    required int currentIndex, // Add this line
  });


  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin  {
  late TabController _tabController;
  List<dynamic> artworks = [];
  Map<String, dynamic>?artworkofday ;
  Map<String, dynamic>?deck ;
  late String artworkImageUrl;
  late String artworkTitle;
  late String artistName;
  late int lastFetchedTimestamp;
  List<String> artworkUrls = [];


  @override
  void initState() {
    super.initState();
    fetchArtworks();
    initializeArtworkOfTheDay();
    _isDarkModeEnabled =
        Provider.of<ThemeProvider>(context, listen: false).isDarkModeEnabled;
    _tabController = TabController(length: 3, vsync: this);

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

  Future<void> initializeArtworkOfTheDay() async {
    final prefs = await SharedPreferences.getInstance();
    final artworkData = prefs.getString('artworkOfDay');
    lastFetchedTimestamp = prefs.getInt('artworkOfDayTimestamp') ?? 24;

    if (artworkData != null) {
      // Use cached artwork data if available
      setState(() {
        artworkofday = jsonDecode(artworkData);
        print(artworkofday);
      });
    } else {
      // Fetch artwork of the day if not cached
      await fetchArtworkOfTheDay();
    }
  }
  Future<void> fetchArtworkOfTheDay() async {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final prefs = await SharedPreferences.getInstance();

    // Check if 24 hours have passed since the last fetch
    if (currentTime - lastFetchedTimestamp >= 30 * 1000) {
      final apiUrl = Uri.parse('${ApiConfig.baseUrl}/artworkoftheday');

      try {
        final response = await http.get(apiUrl);

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = jsonDecode(response.body);

          // Cache the fetched artwork data with a new timestamp
          prefs.setString('artworkOfDay', jsonEncode(data));
          prefs.setInt('artworkOfDayTimestamp', currentTime);

          setState(() {
            artworkofday = data;
            print(artworkofday);
          });
        } else {
          print('Failed to fetch artwork of the day: ${response.statusCode}');
        }
      } catch (error) {
        print('HTTP request error: $error');
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  bool _isDarkModeEnabled = false;
  int _currentSliderIndex = 0;
  var currentPage = mediaItem.length -1.0 ;

  final List<String> mediaItems = [
    'assets/cat.jpeg',
    'assets/appImages/artist1.jpeg',
    'assets/img3.jpeg',
    'assets/5.jpg',
    'assets/6.jpg',
    'assets/cat2.jpeg',

  ];
  final List<String> IMAGES= [
    'assets/cat.jpeg',
    'assets/cat2.jpeg',
    'assets/img3.jpeg',
    'assets/appImages/artist1.jpeg',
    'assets/cat.jpeg',
    'assets/cat2.jpeg',
    'assets/cat.jpeg',
    'assets/cat2.jpeg',
  ];
  final List<String> imageTexts = [
    'Mona Lisa with a Cat ',
    'Vincent Van Gogh',
    'The Storm',
    'Girl With a Book',
    'The Woman with a Parasol',
    'Starry Night with a Cat',
  ];

  @override
  Widget build(BuildContext context) {
 //   print('Artwork URLs: $artworkUrls');
    PageController controller = PageController(initialPage: mediaItems.length-1);
    controller.addListener(() {
      setState(() {
        currentPage=controller.page!;
      });
    });
    final themeProvider = Provider.of<ThemeProvider>(context);
    final backgroundColor = themeProvider.isDarkModeEnabled
        ? Color(0xFF231A12) // Very Very Dark Brown
        : Color(0xFFEbd2a9);
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: themeProvider.isDarkModeEnabled
              ? Color(0xFF231A12)
              : Color(0xFFEbd2a9),
          elevation: 0,
          title: Center(
            child: Text(
              'ArtVault',
              style: TextStyle(
                fontSize: 30,
                color: themeProvider.isDarkModeEnabled
                    ? Color(0xFFEbd2a9)
                    : Color(0xFF473B2B),
                fontWeight: FontWeight.w200,
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                // Handle favorites icon tap
              },
              icon: GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreen(),));
                },
                child: Image.asset(
                  'assets/icons/vault.png', // Replace with the actual path to your vault.png image
                  width: 28, // Adjust the width as needed
                  height: 28, // Adjust the height as needed
                ),
              ),
            ),
          ],
          leading: IconButton(
            icon: Image.asset(
                'assets/icons/arrow-left.png', // Replace with the actual path to your vault.png image
                width: 21, // Adjust the width as needed
                height: 28, // Adjust the height as needed
                color: themeProvider.isDarkModeEnabled
                    ? Color(0xFFEbd2a9)
                    : Color(0xFF473B2B)),
            onPressed: widget.onMenuPressed,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              //CAROUSEL
              Stack(
                children: [
                  CarouselSlider(
                    items: mediaItems.map((item) {
                      String text = imageTexts[_currentSliderIndex];
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(


                            width: MediaQuery.of(context).size.width,
                            child: Stack(
                              children: [
                                AspectRatio(

                                    aspectRatio: 9/11,
                                    child: Image.asset(item,fit: BoxFit.cover,)),
                                Positioned(
                                  bottom: 60,
                                  left: 20,
                                  child: Text(
                                    text,
                                    style: TextStyle(
                                      color:
                                      Color(0xFFF5F5DC), //Color(0xFFE5D3B3),
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }).toList(),
                    options: CarouselOptions(
                        height: 380,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.81,
                        autoPlayCurve:  Curves.fastOutSlowIn,
                        autoPlayInterval: Duration(seconds: 2),
                        autoPlayAnimationDuration: Duration(milliseconds: 1200),
                        enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                        enlargeFactor: 0.32,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentSliderIndex = index;
                          });
                        }),
                  ),
                  Positioned(
                    left: 120,
                    bottom: 30,
                    child: CarouselIndicator(
                      height: 2,
                      count: mediaItems.length,
                      index:
                          _currentSliderIndex, // Use the current index of the carousel
                      color: Color(0xfff1d4ad),
                      activeColor: Color(0xFF473B2B),
                    ),
                  ),
                ],
              ),

              //EVENT & EXIBITIONS SCROLL
              SizedBox(height: 16), // Add some spacing between sections
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Events & Exhibitions',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: themeProvider.isDarkModeEnabled
                              ? Color(0xFFEbd2a9)
                              : Color(0xFF231A12),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => EventScreen()));
                    },
                    child: Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: themeProvider.isDarkModeEnabled
                            ? Color(0xFFEbd2a9) : Color(0xFF52412E),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2),
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: 270,
                  child: SwiperBuilder()),

              //TODAY'S TOP PICKS STACKED CARDS
              SizedBox(height:20),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Today's Top Picks",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: themeProvider.isDarkModeEnabled
                            ? Color(0xFFEbd2a9) :Color(0xFF52412E),
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                children: <Widget>[
                  if (artworks != null && artworks.isNotEmpty)
                    CardScrollWidget(currentPage),
                  if (artworks != null && artworks.isNotEmpty)
                    Positioned.fill(
                      child: PageView.builder(
                        itemCount: artworks.length,
                        controller: controller,
                        reverse: true,
                        allowImplicitScrolling: true,
                        itemBuilder: (context, index) {
                          final artwork = artworks[index];
                          final artworkId = artwork['artworkId'];
                          return GestureDetector(
                            onTap: () {
                              if (artworkId != null && artworkId is int) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ArtworkDetailScreen(artworkId: artworkId),),);
                              } else {
                                // Handle the case where artworkId is null or not an int
                                print('Invalid artwork ID');
                              }
                            },
                          );
                        },
                      ),
                    ),
                  if (artworks == null || artworks.isEmpty)
                    Center(
                      child: Lottie.asset(
                        'assets/lotties/golden-loading.json', // Replace with your Lottie animation file path
                        width: 400,
                        height: 900,
                      ),
                    ),
                ],
              ),

              // STORY OF THE DAY
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Story of the Day", // Heading for the deck of cards widget
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: themeProvider.isDarkModeEnabled
                            ? Color(0xFFEbd2a9)
                            : Color(0xFF52412E),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              StoryOfTheDayWidget(),
              //VERTICAL TAB BAR
              SizedBox(height: 17),
              // Padding(
              //   padding: const EdgeInsets.only(left: 10.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: [
              //       Text(
              //           "Discover & Explore",
              //         style: TextStyle(
              //           fontSize: 24,
              //           fontWeight: FontWeight.w500,
              //           color: themeProvider.isDarkModeEnabled
              //               ? Color(0xFFEbd2a9) :Color(0xFF52412E),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // SizedBox(height: 10),

              // Container(
              //   height: 410,
              //   child: Row(
              //     children:[
              //       RotatedBox(
              //       quarterTurns: 3,
              //       child: Container(
              //         child: TabBar(
              //           isScrollable: false,
              //           controller: _tabController,
              //           indicator:BoxDecoration(
              //             borderRadius: BorderRadius.circular(30),
              //             image: DecorationImage(
              //               image: AssetImage('assets/cat.jpeg'),
              //               fit: BoxFit.cover,
              //               colorFilter: ColorFilter.mode(
              //                 Colors.black.withOpacity(0.4), // Adjust opacity for the desired darkness level
              //                 BlendMode.darken,
              //               ),
              //             ),
              //           ),
              //           tabs: [
              //             Tab(child: Text('Artist',style: TextStyle(fontWeight: FontWeight.w500),),),
              //             Tab(text: 'Artworks',),
              //             Tab(text: 'Museums'),
              //           ],
              //           labelColor: Color(0xffffecd2),
              //           labelStyle:  GoogleFonts.philosopherTextTheme(Theme.of(context).textTheme,).titleLarge,
              //           unselectedLabelColor: themeProvider.isDarkModeEnabled
              //               ? Color(0xFFEbd2a9).withOpacity(0.6)
              //               : Color(0xFF231A12).withOpacity(0.5),
              //           indicatorColor: Color(0xFFEbd2a9),
              //         ),
              //
              //       ),
              //     ),
              //
              //   Flexible(
              //     child: Container(
              //       width: double.maxFinite,
              //       height: 650,
              //       child: TabBarView(
              //         controller: _tabController,
              //         children: [
              //           Padding(
              //             padding: const EdgeInsets.only(left: 2),
              //             child: Container(
              //               height: 500,
              //               child: ListView.builder(
              //                 scrollDirection: Axis.horizontal,
              //                 itemCount: mediaItems.length,
              //                 itemBuilder: (context, index) {
              //                   return Column(
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     children: [
              //                       GestureDetector(
              //                         onTap: () {
              //                           // Handle image tap event if needed
              //                         },
              //                         child: Padding(
              //                           padding: const EdgeInsets.only(right: 8.0),
              //                           child: Container(
              //                             width: 240,
              //                             height: 350,
              //                             decoration: BoxDecoration(
              //                               borderRadius: BorderRadius.circular(10),
              //                               image: DecorationImage(
              //                                 image: AssetImage(mediaItems[index]),
              //                                 fit: BoxFit.cover,
              //                                 colorFilter: ColorFilter.mode(
              //                                   Colors.black.withOpacity(0.1),
              //                                   BlendMode.darken,
              //                                 ),
              //                               ),
              //                             ),
              //                           ),
              //                         ),
              //                       ),
              //                       SizedBox(height: 8),
              //                       Text(
              //                         artistNames[index], // Use the artist name for this index
              //                         style: TextStyle(
              //                           color: Colors.white,
              //                           fontWeight: FontWeight.bold,
              //                         ),
              //                       ),
              //                       SizedBox(height: 4),
              //                       Text(
              //                         descriptions[index], // Use the description for this index
              //                         style: TextStyle(
              //                           color: Colors.white,
              //                         ),
              //                       ),
              //                     ],
              //                   );
              //                 },
              //               ),
              //             ),
              //           ),
              //           Container(
              //             width: MediaQuery.of(context).size.width,
              //             height: 200, // Adjust the height as needed
              //             child: ListView.builder(
              //               itemCount: mediaItems.length,
              //               scrollDirection: Axis.horizontal,
              //               itemBuilder: (context, index) {
              //                 return EventCard(index: index);
              //               },
              //             ),
              //           ),
              //           Padding(
              //             padding: const EdgeInsets.only(left: 2),
              //             child: Container(
              //               height: 200,
              //               child: ListView.builder(
              //                 scrollDirection: Axis.horizontal,
              //                 itemCount: mediaItems.length, // Replace with the actual number of images
              //                 itemBuilder: (context, index) {
              //                   return Padding(
              //                     padding: EdgeInsets.symmetric(horizontal: 10),
              //                     child: GestureDetector(
              //                       onTap: () {
              //                         // Handle image tap event if needed
              //                       },
              //                       child: Container(
              //                         width: 250, // Adjust the width as needed
              //                         decoration: BoxDecoration(
              //                           borderRadius: BorderRadius.circular(10),
              //                           image: DecorationImage(
              //                             image: AssetImage(mediaItems[index]), // Provide the image path
              //                             fit: BoxFit.cover,
              //                           ),
              //                         ),
              //                       ),
              //                     ),
              //                   );
              //                 },
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              //     ]
              //   ),
              // ),
              // Card Flip Animation
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Artwork of the Day", // Heading for the deck of cards widget
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: themeProvider.isDarkModeEnabled
                            ? Color(0xFFEbd2a9)
                            : Color(0xFF52412E),
                      ),
                    ),
                          ],
                ),
              ),
              SizedBox(height: 2),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Click on the card to reveal the artwork of the day.",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: themeProvider.isDarkModeEnabled
                            ? Color(0xFFEbd2a9).withOpacity(0.6)
                            : Color(0xFF52412E).withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  // Handle the tap to flip the card
                  // You can add your logic here to handle the flipping animation
                },
                child: Container(
                  width: 330,
                  height: 460,
                  child: FlipCard(
                    front: Card(
                      elevation: 20,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: AssetImage('assets/Card.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    back: Card(
                      elevation: 20,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(

                            image: NetworkImage(artworkofday?['artworkUrl']?? ''), // Replace with actual image
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Artwork of the Day",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffffecd2), // Change the text color as needed
                              ),
                            ),
                            SizedBox(height: 20),
                            // Add more details about the artwork here
                            Text(
                              "Title: ${artworkofday?['title']?? ''}",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xffffecd2), // Change the text color as needed
                              ),
                            ),
                            Text(
                              "Artist: ${artworkofday?['artist']?? ''}",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xffffecd2), // Change the text color as needed
                              ),
                            ),
                            // Add more details as needed
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // DECK OF INSPIRATION
              SizedBox(height: 17),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Deck of Inspiration", // Heading for the deck of cards widget
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: themeProvider.isDarkModeEnabled
                            ? Color(0xFFEbd2a9)
                            : Color(0xFF52412E),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 45,),
              Container(
                width: double.maxFinite,
                child: Center(
                  child: SwipeDeck(
                    aspectRatio: 4 / 3,
                    startIndex: 4,
                    cardSpreadInDegrees: 10,
                    onChange: (index) {
                      print(IMAGES[index]);
                    },
                    widgets: IMAGES
                        .map((imageUrl) => GestureDetector(
                      onTap: () {
                        print(imageUrl);
                      },
                      child: Container(
                        height: 600,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.asset(imageUrl,filterQuality: FilterQuality.high,fit: BoxFit.cover,),
                        ),
                      ),
                    ))
                        .toList(),
                  ),
                ),
              ),

              SizedBox(height: 70),
            ],
          ),
        ));
  }
}
