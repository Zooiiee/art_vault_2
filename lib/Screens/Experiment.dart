import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:art_vault_2/theme/ThemeProvider.dart';
import '../Widgets/Parallex.dart';
import 'SearchScreen.dart';

class ExperimentScreen extends StatefulWidget {
  const ExperimentScreen({Key? key}) : super(key: key);

  @override
  State<ExperimentScreen> createState() => _ExperimentScreenState();
}

class _ExperimentScreenState extends State<ExperimentScreen> with SingleTickerProviderStateMixin  {

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
              backgroundColor: themeProvider.isDarkModeEnabled
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
                child: ArtMovementsParallax(),
              )



            ]),
          ),
        ],
      ),
    );
  }
}
