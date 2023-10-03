import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:provider/provider.dart';

import '../Data/data.dart';
import '../theme/ThemeProvider.dart'; // Import this if you use provider


import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';


import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart'; // Import this if you use provider


class SearchScreenSM extends StatefulWidget {
  const SearchScreenSM({Key? key}) : super(key: key);

  @override
  State<SearchScreenSM> createState() => _SearchScreenSMState();
}

class _SearchScreenSMState extends State<SearchScreenSM> with SingleTickerProviderStateMixin  {
  late TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0,
            backgroundColor: themeProvider.isDarkModeEnabled
                ? Color(0xFF231A12) // Very Very Dark Brown
                : Color(0xFFEbd2a9),
            stretch: true,
            toolbarHeight: 370,

            flexibleSpace: Stack(

              children: [
                FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      // CarouselSlider for images
                      CarouselSlider(
                        items: mediaItems.map((item) {
                          return Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(item),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }).toList(),
                        options: CarouselOptions(
                          height: 470.0,
                          viewportFraction: 1.0,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayCurve: Curves.linear,
                          scrollPhysics: BouncingScrollPhysics(),

                        ),


                      ),

                      // Pastel overlay
                      Container(
                        color: Colors.brown.withOpacity(0.2), // Replace with your pastel color
                      ),
                      // Centered Text
                      Center(
                        child: Text(
                          'Your Text Here',
                          style: TextStyle(
                            color: Colors.white, // Change text color as needed
                            fontSize: 24.0, // Adjust font size as needed
                            fontWeight: FontWeight.bold, // Adjust font weight as needed
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 45,
                  left: 15,
                  right: 15,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 41,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F5DC).withOpacity(0.6), // Background color
                          borderRadius: BorderRadius.circular(10), // Rounded edges
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: IconButton(
                            icon: Icon(Icons.arrow_back,size: 26,),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),
            floating: true,
            pinned: true,
            snap: false,
            centerTitle: false,
           // title: Text('Explore',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24,color: themeProvider.isDarkModeEnabled ? Color(0xFFEbd2a9): Color(0xFF231A12),),),
            automaticallyImplyLeading: false, // Remove back button
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(64),

              child: Container(
                padding: EdgeInsets.only(bottom: 8),
                child: AppBar(
                  elevation: 0, // Add elevation for a subtle shadow
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false, // Remove back button
                  titleSpacing: 10,
                  title: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => SearchPage(),
                        //   ),
                        // );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Color(0xFFF5F5DC), Colors.white.withOpacity(0.7)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2), // Shadow color
                              offset: Offset(0, 3), // Offset of the shadow
                              blurRadius: 5, // Spread of the shadow
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Image.asset(
                                'assets/icons/search_ani.gif',
                                width: 35,
                                height: 60,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Search for something',
                                style: TextStyle(color: Color(0xFF52412E).withOpacity(0.7)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          ),
          // Other Sliver Widgets
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                height: 800,
                color: themeProvider.isDarkModeEnabled
                    ? Color(0xFF231A12) // Very Very Dark Brown
                    : Color(0xFFEbd2a9),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, bottom: 12, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Popular on ArtVault",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w500,
                              color: themeProvider.isDarkModeEnabled
                                  ? Color(0xFFEbd2a9)
                                  : Color(0xFF52412E),
                            ),
                          ),
                          SizedBox(height: 20,),
                          //PopularMediaGrid(),

                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, bottom: 10, top: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Browse all",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w500,
                              color: themeProvider.isDarkModeEnabled
                                  ? Color(0xFFEbd2a9)
                                  : Color(0xFF52412E),
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              )



            ]),
          ),
        ],
      ),
    );
  }
}

class PopularMediaGrid extends StatelessWidget {


  final List<String> titles = [
    'Title 1',
    'Title 2',
    'Title 3',
    'Title 4',
    'Title 5',
    'Title 6',
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: mediaItems.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 images in each row
      ),
      itemBuilder: (context, index) {
        final mediaItem = mediaItems[index];
        final title = titles[index];

        return Column(
          children: [
            Stack(
              children: [
                // Image with darkened opacity
                Opacity(
                  opacity: 0.7, // Adjust the opacity as needed
                  child: Image.asset(
                    mediaItem,
                    width: double.infinity,
                    height: 150.0, // Adjust the image height as needed
                    fit: BoxFit.cover,
                  ),
                ),
                // Text on top of the image
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.0, // Adjust the text size as needed
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Text color
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
