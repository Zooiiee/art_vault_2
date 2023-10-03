import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/ThemeProvider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:art_vault_2/theme/ThemeProvider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';


class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final List<String> artistsAndArtworks = [
    "Leonardo da Vinci",
    "Starry Night",
    "Pablo Picasso",
    "Mona Lisa",
    // Add more data here
  ];

  String query = '';
  final FocusNode _focusNode = FocusNode();
  List<String> recentSearches = [];

  List<String> getFilteredResults() {
    return artistsAndArtworks
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    // Request focus when the page is first created
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final List<String> matchQuery = getFilteredResults();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.isDarkModeEnabled
            ? Color(0xFF52412E) // Very Very Dark Brown
            : Color(0xFFC3A781),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: themeProvider.isDarkModeEnabled
              ? Color(0xFFEbd2a9) // Very Very Dark Brown
              : Color(0xFF231A12),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 0.0),
          child: TextFormField(
            focusNode: _focusNode, // Assign the focus node to the TextField
            cursorColor: Color(0xFF52412E),
            decoration: InputDecoration(
              hoverColor: Color(0xFF52412E).withOpacity(0.7),
              hintText: 'Search Artists and Artworks',
              hintStyle: TextStyle(
                fontSize: 19,
                color: themeProvider.isDarkModeEnabled
                    ? Color(0xFFEbd2a9) // Very Very Dark Brown
                    : Color(0xFF231A12),
                fontWeight: FontWeight.w100,
              ),
              labelStyle: TextStyle(
                fontSize: 19,
                color: Color(0xFF52412E),
                fontWeight: FontWeight.w200,
              ),
              prefixIconColor: Color(0xFF52412E),
              suffixIconColor: Color(0xFF52412E),
              iconColor: Color(0xFF52412E),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              setState(() {
                query = value;
              });
            },
          ),
        ),
      ),
      body: Container(
        color: themeProvider.isDarkModeEnabled
            ? Color(0xFF231A12) // Very Very Dark Brown
            : Color(0xFFEbd2a9),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: matchQuery.length,
                itemBuilder: (context, index) {
                  final result = matchQuery[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: themeProvider.isDarkModeEnabled
                          ? Color(0xFFEbd2a9) // Very Very Dark Brown
                          : Color(0xFF231A12),
                    ),
                    title: Text(
                      result,
                      style: TextStyle(fontSize: 19,
                        color: themeProvider.isDarkModeEnabled
                            ? Color(0xFFEbd2a9) // Very Very Dark Brown
                            : Color(0xFF231A12),
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.clear),
                      color: themeProvider.isDarkModeEnabled
                          ? Color(0xFFEbd2a9) // Very Very Dark Brown
                          : Color(0xFF231A12),
                      onPressed: () {
                        setState(() {
                          // Remove the search item from recentSearches
                          recentSearches.remove(result);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
