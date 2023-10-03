import 'package:art_vault_2/Screens/Experiment.dart';
import 'package:art_vault_2/Widgets/StaggeredGridViewArtists.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:art_vault_2/theme/ThemeProvider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:art_vault_2/Data/data.dart';
import '../Widgets/ArtitstParallax.dart';
import '../Widgets/ShrinkTopList.dart';
import 'ArtistsScreen.dart';
import 'ArtMovementScreen.dart';
import 'Artworksscreen.dart';
import 'EventScreen.dart';
import 'SearchScreen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> with SingleTickerProviderStateMixin  {
  late TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: themeProvider.isDarkModeEnabled
          ? Color(0xFF231A12) // Very Very Dark Brown
            : Color(0xFFEbd2a9),
            stretch: true,
            toolbarHeight: 60,
            //flexibleSpace: const FlexibleSpaceBar(
             // background: Image(image: AssetImage('assets/cat.jpeg'), fit: BoxFit.cover,),
            //),
            floating: true,
            pinned: true,
            snap: false,
            centerTitle: false,
            title: Text('Explore',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24,color: themeProvider.isDarkModeEnabled ? Color(0xFFEbd2a9): Color(0xFF231A12),),),
            automaticallyImplyLeading: false, // Remove back button
            actions: [
              IconButton(
                icon: Image.asset(
                  'assets/icons/vault.png', // Replace with the actual path to your vault.png image
                  width: 28, // Adjust the width as needed
                  height: 28, // Adjust the height as needed
                ),
                onPressed: () {},
              ),
            ],
            bottom: AppBar(
              elevation: 0,
              backgroundColor:
              themeProvider.isDarkModeEnabled
                  ? Color(0xFF231A12) // Very Very Dark Brown
                  : Color(0xFFEbd2a9),
              automaticallyImplyLeading: false, // Remove back button
              titleSpacing:10,
              title:  ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchPage(),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    color: Colors.white,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Image.asset(
                              'assets/icons/search_ani.gif', // Replace with the actual path to your vault.png image
                              width: 35, // Adjust the width as needed
                              height: 60, // Adjust the height as needed


                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Search for something',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(Icons.camera_alt),
                        ),
                      ],
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
                color: themeProvider.isDarkModeEnabled
                    ? Color(0xFF231A12) // Very Very Dark Brown
                    : Color(0xFFEbd2a9),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, bottom: 12, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Popular",
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
                    Container(
                      height: 480,
                      child: Row(
                        children: [
                          RotatedBox(
                            quarterTurns: 3,
                            child: Container(
                              child: TabBar(
                                isScrollable: false,
                                controller: _tabController,
                                indicator:BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  image: DecorationImage(
                                    image: AssetImage('assets/appImages/artworks1.webp'),
                                    fit: BoxFit.cover,
                                    colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.3), // Adjust opacity for the desired darkness level
                                      BlendMode.darken,
                                    ),
                                  ),
                                ),
                                tabs: [
                                  Tab(child: Text('Artist',style: TextStyle(fontWeight: FontWeight.w500),),),
                                  Tab(text: 'Artworks',),

                                  Tab(text: 'Exhibition'),
                                ],
                                labelColor: Color(0xffffecd2),
                                labelStyle:  GoogleFonts.philosopherTextTheme(Theme.of(context).textTheme,).titleLarge,
                                unselectedLabelColor: themeProvider.isDarkModeEnabled
                                    ? Color(0xFFEbd2a9).withOpacity(0.6)
                                    : Color(0xFF231A12).withOpacity(0.6),
                                indicatorColor: Color(0xFFEbd2a9),
                              ),

                            ),
                          ),
                          Flexible(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 2),
                                  child: Container(
                                    height: 500,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: mediaItems.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                // Handle image tap event if needed
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(right: 8.0),
                                                child: Container(
                                                  width: 240,
                                                  height: 430,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    image: DecorationImage(
                                                      image: AssetImage(mediaItems[index]),
                                                      fit: BoxFit.cover,
                                                      colorFilter: ColorFilter.mode(
                                                        Colors.black.withOpacity(0.1),
                                                        BlendMode.darken,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              artistNames[index], // Use the artist name for this index
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              descriptions[index], // Use the description for this index
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 2),
                                  child: Container(
                                    height: 200,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: mediaItems.length, // Replace with the actual number of images
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 10),
                                          child: GestureDetector(
                                            onTap: () {
                                              // Handle image tap event if needed
                                            },
                                            child: Container(
                                              width: 250, // Adjust the width as needed
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                image: DecorationImage(
                                                  image: AssetImage(mediaItems[index]), // Provide the image path
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 2),
                                  child: Container(
                                    height: 500,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: mediaItems.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                // Handle image tap event if needed
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(right: 8.0),
                                                child: Container(
                                                  width: 240,
                                                  height: 350,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    image: DecorationImage(
                                                      image: AssetImage(mediaItems[index]),
                                                      fit: BoxFit.cover,
                                                      colorFilter: ColorFilter.mode(
                                                        Colors.black.withOpacity(0.1),
                                                        BlendMode.darken,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              artistNames[index], // Use the artist name for this index
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              descriptions[index], // Use the description for this index
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                    Container(
                      height: 1100,
                      child: Column(
                        children: List.generate(4, (index) {
                          // Replace with the content you want for each item in the list
                          return Padding(
                            padding: const EdgeInsets.only(left: 13,right: 13,bottom: 16),
                            child: GestureDetector(
                              onTap: () {
                                if (index == 0) {
                                  // Navigate to EventScreen when the first card is clicked
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => EventScreen(),
                                    ),
                                  );
                                } else if (index == 1) {
                                  // Navigate to ArtistsScreen when the second card is clicked
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArtistsScreen(),));
                                } else if (index == 2) {
                                  // Navigate to ArtistsScreen when the second card is clicked
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArtworksScreen(),));
                                } else if (index == 3) {
                                  // Navigate to ArtistsScreen when the second card is clicked
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArtMovementsScreen(),));
                                }
                                // else if (index == 4) {
                                //   // Navigate to ArtistsScreen when the second card is clicked
                                //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => ExperimentScreen(),));
                                // }
                                // Add more conditions for other cards/screens as needed
                              },
                              child: Container(
                                height: 250, // Adjust the height of the card/image
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: AssetImage(ExploreMedia[index]), // Provide the image path
                                    fit: BoxFit.cover,
                                    colorFilter: ColorFilter.mode(
                                      Colors.transparent.withOpacity(0.26),
                                      BlendMode.darken,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      cardTitles[index],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      cardST[index],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
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
