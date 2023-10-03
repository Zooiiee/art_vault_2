import 'package:flutter/foundation.dart';

class UserProfileProvider with ChangeNotifier {
  String _profilePictureUrl = ''; // Initialize with an empty string

  String get profilePictureUrl => _profilePictureUrl;

  void setProfilePictureUrl(String url) {
    _profilePictureUrl = url;
    notifyListeners(); // Notify listeners when the profile picture URL changes
  }
}
