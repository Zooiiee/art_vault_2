import 'package:art_vault_2/Navigation/NavigationScreen.dart';
import 'package:art_vault_2/Screens/Home.dart';
import '../Screens/MainDrawerScreen.dart'; // Adjust the actual import path as needed

typedef T Constructor<T>();

final Map<String, Constructor<Object>> _constructors = <String, Constructor<Object>>{};

void register<T>(Constructor<T> constructor) {
  _constructors[T.toString()] = constructor as Constructor<Object>;
}

class ClassBuilder {
  static void registerClasses() {
    register<Home>(() => Home(currentIndex: 0, onTap: (index) {}, onDarkModeToggle: (bool ) {  },));
   register<NavigationScreen>(() => NavigationScreen());
   register<Navigation>(() => Navigation());
    //register<Stats>(() => Stats());
    //register<Schedules>(() => Schedules());
    //register<Settings>(() => Settings());
  }

  static dynamic fromString(String type) {
    return _constructors[type]!();
  }
}