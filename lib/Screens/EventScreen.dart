import 'dart:convert';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:art_vault_2/Screens/EventDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:art_vault_2/theme/ThemeProvider.dart';
import 'package:art_vault_2/Data/data.dart';
import 'api_config.dart';

class EventScreen extends StatefulWidget {
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {

  bool isDateTapped = false;
  DateTime selectedDate = DateTime.now();
  DateTime currentDate = DateTime.now();
  List<DateTime> dateList = List.generate(
    365,
        (index) => DateTime.now().add(Duration(days: index)),
  );

  // Create a variable to store the list of events
  List<dynamic> events = [];
  // Create a variable to track if events are loading
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Initialize selectedDate to the first date in dateList
    selectedDate = dateList[0];
    // Fetch events when the screen initializes
    fetchEvents(selectedDate);
  }

  // Function to fetch events based on the selected date

  Future<void> fetchEvents(DateTime selectedDate) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    final apiUrl = Uri.parse('${ApiConfig.baseUrl}/events/$formattedDate'); // Replace with your server URL

    try {
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          events = data;
          isLoading = false;
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
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final backgroundColor = themeProvider.isDarkModeEnabled
        ? Color(0xFF231A12) // Very Very Dark Brown
        : Color(0xFFEbd2a9);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Events & Exhibitions',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: themeProvider.isDarkModeEnabled ? Color(0xFFEbd2a9): Color(0xFF231A12),
          ),
        ),
        backgroundColor:themeProvider.isDarkModeEnabled ? Color(0xFF231A12) : Color(0xFFEbd2a9),
        elevation: 0, // No shadow
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: themeProvider.isDarkModeEnabled ? Color(0xFFEbd2a9): Color(0xFF231A12)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: backgroundColor,
        height: MediaQuery.sizeOf(context).height-10,
        child: Row(
          children: [
            Container(
              height: 2000,
              width: 63, // Adjust as needed
              color: themeProvider.isDarkModeEnabled ? Color(0xFF231A12) : Color(0xFFEbd2a9),
              child: Padding(
                padding: EdgeInsets.only(left: 3),
                child: ListView.builder(
                  itemCount: dateList.length,
                  itemBuilder: (context, index) {
                    final date = dateList[index];
                    final isSelected = date.isAtSameMomentAs(selectedDate) || date.isAtSameMomentAs(DateTime.now());
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedDate = date;
                          isDateTapped = true;
                          // Fetch events for the selected date
                          fetchEvents(selectedDate);
                        });
                      },
                      child: Container(
                        height: 80, // Adjust the height as needed
                        decoration: BoxDecoration(
                          color: isSelected || (!isDateTapped && index == 0)
                              ? Color(0xFF52412E)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(8),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text(
                              DateFormat('MMM').format(date).toUpperCase(),
                              style: TextStyle(
                                fontSize: 12,
                                color: isSelected ?Color(0xFFEbd2a9) : Color(0xFF7D6E4F),
                              ),
                            ),

                            Text(
                              DateFormat('d').format(date),
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Color(0xFFEbd2a9) : Color(0xFF7D6E4F),
                              ),
                            ),

                            Text(
                              DateFormat('EEE').format(date).toUpperCase(),
                              style: TextStyle(
                                fontSize: 12,
                                color: isSelected ? Color(0xFFEbd2a9) : Color(0xFF7D6E4F),
                              ),
                            ),

                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(

                  color: themeProvider.isDarkModeEnabled ? Color(0xFF231A12) : Color(0xFFEbd2a9),
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        SizedBox(height: 8),

                        // Row(
                        //   children: [
                        //     Icon(Icons.location_on, color: Colors.black), // Location icon
                        //     SizedBox(width: 8),
                        //     Text(
                        //       'Nearby Location',
                        //       style: TextStyle(
                        //
                        //         fontSize: 16,
                        //         color: Colors.black,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(height: 16),
                        Text(
                          '\t\tSelected Date: ${DateFormat('EEE, MMM d').format(selectedDate)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.isDarkModeEnabled ? Color(0xFFEbd2a9) : Color(0xFF231A12),
                          ),
                        ),
                        SizedBox(height: 16),


                        // Add your event cards or list here
                        events.isEmpty
                            ? Center(
                              child: Column(
                          children: [
                              // Add Lottie animation here
                              Lottie.asset('assets/lotties/placeholder.json', height: 300,width: 200),
                              SizedBox(height: 16),
                              Text(
                                'No events on this date',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: themeProvider.isDarkModeEnabled ? Colors.white : Colors.black,
                                ),
                              ),
                          ],
                        ),
                            )
                            : Container(
                              child: Column(
                                children:  List.generate(events?.length ?? 0, (index) {
                                  final event = events?[index];
                                  final int eventid= event?['eventid'];
                                  final eventUrl = event?['eventUrl'];
                                  final eventName = event?['eventName'];
                                  final place= event?['place'];
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 8, right: 5, bottom: 10),
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => EventDetailScreen(eventid: eventid)));

                                      },
                                      child: Container(
                                        height: 250,
                                        width: double.maxFinite,
                                        child: Stack(
                                          children: [
                                            // Image
                                            Container(

                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                      ),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(10),
                                                  child: FadeInImage(
                                                    placeholder: AssetImage('assets/lotties/paint.gif'),
                                                    placeholderFit: BoxFit.cover,
                                                    placeholderFilterQuality: FilterQuality.high,
                                                    image: NetworkImage(eventUrl), // Provide the event image path
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              height: 250,
                                            ),

                                            // Black Opacity Overlay and Text
                                            Positioned(
                                              bottom: 0,
                                              left: 0,
                                              right: 0,
                                              child: Container(
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.only(
                                                    bottomLeft: Radius.circular(10),
                                                    bottomRight: Radius.circular(10),
                                                  ),
                                                  color: Color(0xFF231A12).withOpacity(0.6),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      eventName,
                                                      style: TextStyle(
                                                        color: Color(0xFFF5F5DC),
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                    SizedBox(height: 4),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.location_on_outlined,
                                                          color: Color(0xFFF5F5DC),
                                                          size: 16,
                                                        ),
                                                        SizedBox(width: 4),
                                                        Text(
                                                          place,
                                                          style: TextStyle(
                                                            color: Color(0xFFF5F5DC),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
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
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}