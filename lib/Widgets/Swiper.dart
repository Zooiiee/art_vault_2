import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'dart:convert';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:art_vault_2/theme/ThemeProvider.dart';
import 'package:art_vault_2/Screens/api_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../Screens/EventDetailScreen.dart';

class SwiperBuilder extends StatefulWidget {


  @override
  State<SwiperBuilder> createState() => _SwiperBuilderState();
}

class _SwiperBuilderState extends State<SwiperBuilder> {

  DateTime selectedDate = DateTime.now();

  List<dynamic> events = [];
  // Create a variable to track if events are loading
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Initialize selectedDate to the first date in dateList
    selectedDate = DateTime.now();
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
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: Align(
        alignment: Alignment.topRight,
        child: events.isEmpty
            ? Center(
          child: Column(
            children: [
              // Add Lottie animation here
              Lottie.asset('assets/lotties/golden-loading.json', height: 270,width: 400),

            ],
          ),
        )
            :Swiper(
              scrollDirection: Axis.horizontal,
              axisDirection: AxisDirection.right,
              viewportFraction: 1.4,
              itemBuilder: (BuildContext context, int index) {
              final event = events?[index];
              final int eventid= event?['eventid'];
              final eventUrl = event?['eventUrl'];
              final eventName = event?['eventName'];
              final place= event?['place'];
              return Stack(
              fit: StackFit.expand,
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => EventDetailScreen(eventid: eventid)));

                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child:CachedNetworkImage(
                      imageUrl: eventUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>Lottie.asset(
                        'assets/pc.json',
                        fit: BoxFit.cover,
                      ), // Optional loading indicator
                      errorWidget: (context, url, error) => Icon(Icons.error), // Optional error widget
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      color: Colors.black.withOpacity(0.6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            eventName,
                            style: TextStyle(
                              color: Color(0xFFF5F5DC),
                              fontWeight: FontWeight.bold,
                              fontSize: 20

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
                ),
              ],
            );
          },
          itemCount: 6,
          itemWidth:365,
          fade: 0.8,
          layout: SwiperLayout.STACK,
        ),
      ),
    );
  }
}