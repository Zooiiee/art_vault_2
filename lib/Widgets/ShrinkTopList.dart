import 'package:flutter/material.dart';
import 'package:art_vault_2/Data/ScrollListData.dart';
import 'package:provider/provider.dart';
import 'package:art_vault_2/theme/ThemeProvider.dart';

const itemSize = 320.0;

class ShrinkTopListPage extends StatefulWidget {
  @override
  _ShrinkTopListPageState createState() => _ShrinkTopListPageState();
}

class _ShrinkTopListPageState extends State<ShrinkTopListPage> {
  final scrollController = ScrollController();

  void onListen() {
    setState(() {});
  }

  @override
  void initState() {
    characters.addAll(List.from(characters));
    scrollController.addListener(onListen);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(onListen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final backgroundColor = themeProvider.isDarkModeEnabled
        ? Color(0xFF231A12) // Very Very Dark Brown
        : Color(0xFFEbd2a9);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.isDarkModeEnabled
            ? Color(0xFF231A12) // Very Very Dark Brown
            : Color(0xFFEbd2a9),
        title: Text('Shrink top List'),
      ),
      body: Container(
        color: backgroundColor, // Set the background color here
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
          child: CustomScrollView(
            controller: scrollController,
            slivers: <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                title: Text(
                  'My Characters',
                  style: TextStyle(color: Colors.black),
                ),
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              SliverToBoxAdapter(
                child: const SizedBox(
                  height: 50,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final heightFactor = 0.6;
                    final character = characters[index];
                    final itemPositionOffset =
                        index * itemSize * heightFactor;
                    final difference =
                        scrollController.offset - itemPositionOffset;
                    final percent =
                        1.0 - (difference / (itemSize * heightFactor));
                    double opacity = percent;
                    double scale = percent;
                    if (opacity > 1.0) opacity = 1.0;
                    if (opacity < 0.0) opacity = 0.0;
                    if (percent > 1.0) scale = 1.0;

                    return Align(
                      heightFactor: heightFactor,
                      child: Opacity(
                        opacity: opacity,
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()..scale(scale, 1.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                            ),
                            color: Color(character.color!),
                            child: SizedBox(
                              height: itemSize,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                    ),
                                  ),
                                  Image.asset(character.avatar!),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: characters.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
