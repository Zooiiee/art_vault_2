import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:art_vault_2/theme/ThemeProvider.dart';
import 'package:lottie/lottie.dart';
import 'api_config.dart';

class EventDetailScreen extends StatefulWidget {
  final int eventid;

  EventDetailScreen({required this.eventid});

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  Map<String, dynamic> eventDetails = {}; // Store event details here
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    // Fetch event details when the screen initializes
    fetchEventDetails();
  }

  // Function to fetch event details by eventID
  Future<void> fetchEventDetails() async {
    final apiUrl = Uri.parse('${ApiConfig.baseUrl}/eventDetails/${widget.eventid}'); // Replace with your server URL

    try {
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Update the UI with the event details
        setState(() {
          eventDetails = data;
          isLoading = false;
        });
      } else {
        // Handle error cases
        print('Failed to fetch event details: ${response.statusCode}');
      }
    } catch (error) {
      print('HTTP request error: $error');
    }
  }
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final backgroundColor = themeProvider.isDarkModeEnabled
        ? Color(0xFF231A12) // Very Very Dark Brown
        : Color(0xFFEbd2a9);
    final contentColor = themeProvider.isDarkModeEnabled
        ? Color(0xFFEbd2a9) // Very Very Dark Brown
        : Color(0xFF473B2B);
    final cc2 = themeProvider.isDarkModeEnabled
        ? Color(0xFFF5F5DC) // Very Very Dark Brown
        : Color(0xFF473B2B).withOpacity(0.9);

    return Scaffold(
      backgroundColor: backgroundColor,

      body: isLoading
          ? Container(
        color: backgroundColor,
            child: Center(
        child: Lottie.asset(
            'assets/lotties/golden-loading.json', // Replace with the path to your Lottie animation file
            width: 400, // Adjust the width and height as needed
            height: 800,
        ),
      ),
          )
          : Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // Background image
                Container(
                  padding: EdgeInsets.only(
                    left: 5.0,
                    right: 10.0,
                    top: 40.0,
                  ),
                  height: 450,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(eventDetails['eventUrl']),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 42, // Adjust the width to make it square
                            height: 42, // Adjust the height to make it square
                            margin: EdgeInsets.only(left: 5,top: 2), // Add margin to the left side
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8), // Add rounded corners
                              color: Colors.black.withOpacity(0.6),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                size: 28,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: 40.0),
                    ],
                  ),
                ),
                // Positioned icon on the imag

                // White screen with details
                SingleChildScrollView(
                  child: Container(

                    //  height: MediaQuery.sizeOf(context).height,
                    transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 20.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10 ),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width - 30,
                                      child: Text(
                                        eventDetails['eventName'],
                                        style: TextStyle(
                                          fontSize: 24.0,
                                          color: contentColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),


                                  SizedBox(height: 15.0),

                                ],
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 17.0,
                            vertical: 0.0,
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width - 0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[

                                SizedBox(height: 10.0),
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:  contentColor.withOpacity(0.5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          'assets/lotties/cal.gif', // Replace with the actual path to your vault.png image
                                          width: 30, // Adjust the width as needed
                                          height: 30,
                                          color: backgroundColor,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 16.0),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          eventDetails['startDate'] + ' - '+eventDetails['endDate'],
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            color: contentColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        Container(
                                          width: MediaQuery.sizeOf(context).width-96,
                                          child: Text(
                                            eventDetails['timing'],
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.normal,
                                              color: contentColor,
                                            ),
                                            overflow: TextOverflow.ellipsis, // Set overflow to visible
                                            maxLines: 2, // Allow unlimited lines
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20.0),

                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 17.0,
                            vertical: 0.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[

                              SizedBox(height: 10.0),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:  contentColor.withOpacity(0.5),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        'assets/lotties/loc.gif', // Replace with the actual path to your vault.png image
                                        width: 30, // Adjust the width as needed
                                        height: 30,
                                        color: backgroundColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16.0),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        eventDetails['place'],
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: contentColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      Container(
                                        width: MediaQuery.sizeOf(context).width-96,
                                        child: Text(
                                          eventDetails['address'],
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.normal,
                                            color: contentColor,
                                          ),
                                          overflow: TextOverflow.ellipsis, // Set overflow to visible
                                          maxLines: 2, // Allow unlimited lines
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 30.0),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: contentColor.withOpacity(0.5),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        'assets/lotties/tic.gif', // Replace with the actual path to your vault.png image
                                        width: 30, // Adjust the width as needed
                                        height: 30,
                                        color: backgroundColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16.0),
                                  Container(
                                    width: MediaQuery.sizeOf(context).width-96,
                                    child: Text(
                                      eventDetails['price'],
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: contentColor,
                                      ),
                                      overflow: TextOverflow.visible, // Set overflow to visible
                                      maxLines: null, // Allow unlimited lines
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(24.0),
                          child: ExpandableText(
                            text :
                              eventDetails['details'],
                              maxLines: 6,

                        ),
                        ),


                      ],
                    ),

                  ),

                ),
              ],
            ),
          ),
          Positioned(
            top: 385,
            right: 0.0,
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Image.asset(
                'assets/icons/bookmark.png',
                color: contentColor,
                width: 50.0,
                height: 50.0,
                // You can adjust the width, height, and padding as needed
              ),
            ),
          ),
        ],


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
            fontSize: 17,
           // fontStyle: FontStyle.italic,
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
