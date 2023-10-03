import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:art_vault_2/Data/data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:art_vault_2/theme/ThemeProvider.dart';

class ArtMovementDetails extends StatefulWidget {
  const ArtMovementDetails({Key? key}) : super(key: key);

  @override
  State<ArtMovementDetails> createState() => _ArtMovementDetailsState();
}

class _ArtMovementDetailsState extends State<ArtMovementDetails> {
  late PageController pageController;
  double pageOffset = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(viewportFraction: 0.7);
    pageController.addListener(() {
      setState(() {
        pageOffset = pageController.page!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final backgroundColor = themeProvider.isDarkModeEnabled
        ? Color(0xFF231A12) // Very Very Dark Brown
        : Color(0xFFEbd2a9);

    final contentColor = themeProvider.isDarkModeEnabled
        ? Color(0xFFF5F5DC) // Very Very Dark Brown
        : Color(0xFF2F1602);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(

        top: false,
        child: CustomScrollView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              //elevation: 0,
              titleSpacing: 60,
              backgroundColor: Colors.transparent,
              stretch: true,
              pinned: true,
              iconTheme: IconThemeData(color: contentColor),
              toolbarHeight: 50,
              expandedHeight: 340,
              flexibleSpace: ClipPath(
                child: FlexibleSpaceBar(
                  title: Text(
                    'Art Movement',
                    style: GoogleFonts.philosopher(
                      textStyle: TextStyle(
                        color: Color(0xFFF5F5DC), // Adjust text color as needed
                        fontSize: 32, // Adjust text size as needed
                        fontWeight: FontWeight.normal, // Adjust text style as needed
                        decoration: TextDecoration.none, // Remove the underline
                        fontStyle: FontStyle.italic, // Apply italic font style
                      ),
                    ),
                  ),
                  expandedTitleScale: 1.5,
                  centerTitle: true,
                  titlePadding: EdgeInsets.only(top: 10),
                  collapseMode: CollapseMode.parallax,
                  stretchModes: const [
                    StretchMode.zoomBackground,
                  ],
                  background: ClipRRect(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(70)),
                    child: Image.asset(
                      'assets/cat.jpeg', // Use the path to your local image asset
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: backgroundColor,
                    // decoration: BoxDecoration(
                    //   image: DecorationImage(
                    //     image: AssetImage("assets/cat.jpeg"),
                    //     fit: BoxFit.cover,
                    //     colorFilter: ColorFilter.mode(
                    //       Color(0xFF52412E).withOpacity(0.8), // Adjust opacity as needed
                    //       BlendMode.darken, // You can also use BlendMode.multiply for a different effect
                    //     ),
                    //   ),
                    // ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 30),
                              Text(
                                'Romanticism',
                                style: TextStyle(
                                  color: themeProvider.isDarkModeEnabled
                                      ? Color(0xFFEbd2a9) // Very Very Dark Brown
                                      : Color(0xFF231A12),
                                  fontSize: 30,
                                  letterSpacing: 2,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                '30 March 1853-29 July 1890',
                                style: TextStyle(
                                  color: contentColor.withOpacity(0.7),
                                  fontSize: 19,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              SizedBox(height: 5),
                              Divider(height: 5,thickness: 1,color: contentColor,),
                              SizedBox(height: 10),
                              ExpandableText(

                                text : 'Vincent Willem van Gogh was a Dutch post-impressionist painter Vincent Willem van Gogh was a Dutch post-impressionist painter Vincent Willem van Gogh was a Dutch post-impressionist painter Vincent Willem van Gogh was a Dutch post-impressionist painter Vincent Willem van Gogh was a Dutch post-impressionist painter who posthumously became one of the most famous and influential figures in the history of Western art.',
                                maxLines: 5,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 30,),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, bottom: 20),
                              child: Text(
                                'Highlight Artists',
                                style: TextStyle(
                                  color: themeProvider.isDarkModeEnabled
                                      ? Color(0xFFEbd2a9) // Very Very Dark Brown
                                      : Color(0xFF231A12),
                                  fontSize: 22,
                                ),
                              ),
                            ),

                            Container(
                              height: 400,
                              padding: EdgeInsets.only(bottom: 30),
                              child: PageView.builder(
                                  itemCount: paintings.length,
                                  controller: pageController,
                                  itemBuilder: (context, i) {
                                    return Transform.scale(
                                      scale: 1,
                                      child: Container(
                                        padding: EdgeInsets.only(right: 20),
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(15),
                                              child: Image.asset(
                                                paintings[i]['image'],
                                                height: 370,
                                                fit: BoxFit.cover,
                                                alignment: Alignment(-pageOffset.abs() + i, 0),
                                              ),
                                            ),
                                            Positioned(
                                              left: 10,
                                              bottom: 20,
                                              right: 10,
                                              child: Text(
                                                paintings[i]['name'],
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 35,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8,left:20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,

                            children: [
                              Text(
                                'Discover this art movement',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.normal,
                                  color: themeProvider.isDarkModeEnabled
                                      ? Color(0xFFEbd2a9) // Very Very Dark Brown
                                      : Color(0xFF231A12),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        // Staggered Grid View
                        ScrollableStaggeredGrid(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;

  ExpandableText({
    required this.text,
    required this.maxLines,
  });

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final contentColor = themeProvider.isDarkModeEnabled
        ? Color(0xFFF5F5DC)
        : Color(0xFF2F1602);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          maxLines: isExpanded ? null : widget.maxLines,
          style: TextStyle(
            color:  contentColor,
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Text(
            isExpanded ? 'Show Less' : 'Read More',
            style: TextStyle(

              color:  themeProvider.isDarkModeEnabled
                  ? Color(0xFFEbd2a9) // Very Very Dark Brown
                  : Color(0xFF231A12), // You can use a different color if you prefer
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ],
    );
  }
}


class ScrollableStaggeredGrid extends StatefulWidget {
  @override
  _ScrollableStaggeredGridState createState() => _ScrollableStaggeredGridState();
}

class _ScrollableStaggeredGridState extends State<ScrollableStaggeredGrid> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollForward() {
    // Calculate the desired offset for forward scrolling (adjust the value as needed)
    final double scrollOffset = _scrollController.offset + 300.0;

    // Scroll the grid forward
    _scrollController.animateTo(
      scrollOffset,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 560,
          width: 400,
          child: GridView.custom(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            gridDelegate: SliverQuiltedGridDelegate(
              crossAxisCount: 4,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              repeatPattern: QuiltedGridRepeatPattern.inverted,
              pattern: [
                QuiltedGridTile(2, 2),
                QuiltedGridTile(1, 1),
                QuiltedGridTile(1, 1),
                QuiltedGridTile(1, 2),
              ],
            ),
            childrenDelegate: SliverChildBuilderDelegate(
                  (context, index) => Tile(index: index),
            ),
          ),
        ),
        Positioned(
          right: 16,
          bottom: 250,
          child: FloatingActionButton(
            onPressed: _scrollForward,
            child: Icon(Icons.arrow_forward),
          ),
        ),
      ],
    );
  }
}

class Tile extends StatelessWidget {
  final int index;

  Tile({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0.0),
        color: Colors.primaries[index % Colors.primaries.length],
        boxShadow: [
          BoxShadow(
            color: Colors.primaries[index % Colors.primaries.length].withOpacity(0.5),
            spreadRadius: 4,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text('Item $index'),
      ),
    );
  }
}
