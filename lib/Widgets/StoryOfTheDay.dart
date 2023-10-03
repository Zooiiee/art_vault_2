import 'package:flutter/material.dart';

class StoryOfTheDayWidget extends StatefulWidget {
  @override
  _StoryOfTheDayWidgetState createState() => _StoryOfTheDayWidgetState();
}

class _StoryOfTheDayWidgetState extends State<StoryOfTheDayWidget> {

  final List<Map<String, String>> mediaItems = [
    {
      'image':
      'https://1.bp.blogspot.com/-HszACvrcNqc/WoXgjGvXPpI/AAAAAAAGEc8/GuVTkuC3n5YZU1YyM1RTzUQATmpa3qrzACLcBGAs/s1600/Vincent%2BVan%2BGogh%2BFirst%2BSteps%2B%2528after%2BMillet%2529%2B1890%2B%2BThe%2BMetropolitan%2BMuseum%2Bof%2BArt%252C%2BNew%2BYork%2B%25284%2529.jpg', // Replace with actual image URL
      'title': 'The Artistic Journey Begins',
      'story':
      'Experience the artistic journey of Vincent van Gogh. This image represents the start of his incredible career as a painter. Van Gogh\'s passion for art ignited with every stroke of his brush.',
    },
    {
      'image':
      'https://tse3.mm.bing.net/th?id=OIP.Zc-otMFhlTO-hQiCh7zbYwHaE8&pid=Api&P=0&h=180', // Replace with actual image URL
      'title': 'The Colors of Provence',
      'story':
      'Vincent van Gogh moved to Provence, France, and discovered the vibrant colors of the region. His use of bold, expressive colors set his work apart and made him a pioneer of modern art.',
    },
    {
      'image':
      'https://tse3.mm.bing.net/th?id=OIP.4xWJauU66lQB9Om9z8hcqQHaF3&pid=Api&P=0&h=180', // Replace with actual image URL
      'title': 'Starry Night',
      'story':
      'Behold "The Starry Night," one of van Gogh\'s most iconic paintings. With swirling skies and brilliant stars, it captures the artist\'s imagination and emotional depth.',
    },
    {
      'image':
      'https://tse3.mm.bing.net/th?id=OIP.RNpvNG8oBUQedH7ZIFQowQHaJZ&pid=Api&P=0&h=180', // Replace with actual image URL
      'title': 'Sunflower Symphony',
      'story':
      'Van Gogh\'s sunflower series is a testament to his fascination with beauty. Each sunflower painting radiates life and energy, reflecting his love for the simple yet profound.',
    },
    {
      'image':
      'https://tse2.mm.bing.net/th?id=OIP.cPFt-OEZnDKAn9MpuSxS5wHaF7&pid=Api&P=0&h=180', // Replace with actual image URL
      'title': 'The Café Terrace at Night',
      'story':
      'Explore the charming "Café Terrace at Night." With warm, inviting colors, this masterpiece captures the magic of a nighttime café in Arles, France, where van Gogh once lived.',
    },
    {
      'image':
      'https://www.royal-painting.com/largeimg/Gogh,%20Vincent%20van/23442-Gogh,%20Vincent%20van.jpg', // Replace with actual image URL
      'title': 'The Bedroom',
      'story':
      'Step into van Gogh\'s world through "The Bedroom." This painting offers a glimpse into the artist\'s private space and showcases his distinctive style and perspective.',
    },
    {
      'image':
      'https://i0.wp.com/upload.wikimedia.org/wikipedia/commons/thumb/9/94/Starry_Night_Over_the_Rhone.jpg/1280px-Starry_Night_Over_the_Rhone.jpg?ssl=1', // Replace with actual image URL
      'title': 'The Starry Night Over the Rhône',
      'story':
      'Another celestial masterpiece! "The Starry Night Over the Rhône" is a captivating night scene. Van Gogh\'s use of light and reflection creates an enchanting ambiance.',
    },
    {
      'image':
      'https://tse2.mm.bing.net/th?id=OIP.075vOfFMeuBrshd-Z41oAwHaFv&pid=Api&P=0&h=180', // Replace with actual image URL
      'title': 'Irises',
      'story':
      'Van Gogh\'s "Irises" showcases his fascination with nature. The vibrant flowers burst with life, and the swirling composition mirrors the artist\'s own turbulent emotions.',
    },
    {
      'image':
      'https://tse3.mm.bing.net/th?id=OIP.dOcUDZXZwInN6T4TLrty2wHaDl&pid=Api&P=0&h=180', // Replace with actual image URL
      'title': 'Wheatfield with Crows',
      'story':
      'As we approach the end of this journey, "Wheatfield with Crows" offers a powerful and somber view of a vast wheatfield. Some speculate that it reflects van Gogh\'s state of mind at the time.',
    },
    {
      'image':
      'https://tse4.mm.bing.net/th?id=OIP.dSGy1lXCfJ3BSPPTiP6lvwHaEj&pid=Api&P=0&h=180', // Replace with actual image URL
      'title': 'The Starry Night (Revisited)',
      'story':
      'Our journey concludes with another view of "The Starry Night." Van Gogh\'s artistic legacy lives on through this timeless masterpiece, inspiring generations of artists and dreamers.',
    },
  ];

  int _currentIndex = 0;
  PageController _pageController = PageController();
  Duration _animationDuration = Duration(milliseconds: 300);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 1.35,
      color: Colors.black, // Background color
      child: Stack(
        children: [
          PageView.builder(
            itemCount: mediaItems.length,
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // Navigate to next media item
                  _pageController.animateToPage(
                    (_currentIndex + 1) % mediaItems.length,
                    duration: _animationDuration,
                    curve: Curves.easeInOut,
                  );
                },
                child: Stack(
                  children: [
                    Image.network(
                      mediaItems[index]['image']!,
                      fit: BoxFit.fill,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7), // Adjust opacity as needed
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mediaItems[index]['title']!,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            mediaItems[index]['story']!,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  mediaItems.length,
                      (index) => AnimatedContainer(
                    duration: _animationDuration,
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    width: _currentIndex == index ? 48.0 : 27.0,
                    height: 3.0,
                    decoration: BoxDecoration(
                      color:
                      _currentIndex == index ? Colors.white : Colors.white54,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


final List<Map<String, String>> mediaItems = [
  {
    'image':
    'https://1.bp.blogspot.com/-HszACvrcNqc/WoXgjGvXPpI/AAAAAAAGEc8/GuVTkuC3n5YZU1YyM1RTzUQATmpa3qrzACLcBGAs/s1600/Vincent%2BVan%2BGogh%2BFirst%2BSteps%2B%2528after%2BMillet%2529%2B1890%2B%2BThe%2BMetropolitan%2BMuseum%2Bof%2BArt%252C%2BNew%2BYork%2B%25284%2529.jpg', // Replace with actual image URL
    'title': 'The Artistic Journey Begins',
    'story':
    'Experience the artistic journey of Vincent van Gogh. This image represents the start of his incredible career as a painter. Van Gogh\'s passion for art ignited with every stroke of his brush.',
  },
  {
    'image':
    'https://tse3.mm.bing.net/th?id=OIP.Zc-otMFhlTO-hQiCh7zbYwHaE8&pid=Api&P=0&h=180', // Replace with actual image URL
    'title': 'The Colors of Provence',
    'story':
    'Vincent van Gogh moved to Provence, France, and discovered the vibrant colors of the region. His use of bold, expressive colors set his work apart and made him a pioneer of modern art.',
  },
  {
    'image':
    'https://tse3.mm.bing.net/th?id=OIP.4xWJauU66lQB9Om9z8hcqQHaF3&pid=Api&P=0&h=180', // Replace with actual image URL
    'title': 'Starry Night',
    'story':
    'Behold "The Starry Night," one of van Gogh\'s most iconic paintings. With swirling skies and brilliant stars, it captures the artist\'s imagination and emotional depth.',
  },
  {
    'image':
    'https://tse3.mm.bing.net/th?id=OIP.RNpvNG8oBUQedH7ZIFQowQHaJZ&pid=Api&P=0&h=180', // Replace with actual image URL
    'title': 'Sunflower Symphony',
    'story':
    'Van Gogh\'s sunflower series is a testament to his fascination with beauty. Each sunflower painting radiates life and energy, reflecting his love for the simple yet profound.',
  },
  {
    'image':
    'https://tse2.mm.bing.net/th?id=OIP.cPFt-OEZnDKAn9MpuSxS5wHaF7&pid=Api&P=0&h=180', // Replace with actual image URL
    'title': 'The Café Terrace at Night',
    'story':
    'Explore the charming "Café Terrace at Night." With warm, inviting colors, this masterpiece captures the magic of a nighttime café in Arles, France, where van Gogh once lived.',
  },
  {
    'image':
    'https://www.royal-painting.com/largeimg/Gogh,%20Vincent%20van/23442-Gogh,%20Vincent%20van.jpg', // Replace with actual image URL
    'title': 'The Bedroom',
    'story':
    'Step into van Gogh\'s world through "The Bedroom." This painting offers a glimpse into the artist\'s private space and showcases his distinctive style and perspective.',
  },
  {
    'image':
    'https://i0.wp.com/upload.wikimedia.org/wikipedia/commons/thumb/9/94/Starry_Night_Over_the_Rhone.jpg/1280px-Starry_Night_Over_the_Rhone.jpg?ssl=1', // Replace with actual image URL
    'title': 'The Starry Night Over the Rhône',
    'story':
    'Another celestial masterpiece! "The Starry Night Over the Rhône" is a captivating night scene. Van Gogh\'s use of light and reflection creates an enchanting ambiance.',
  },
  {
    'image':
    'https://tse2.mm.bing.net/th?id=OIP.075vOfFMeuBrshd-Z41oAwHaFv&pid=Api&P=0&h=180', // Replace with actual image URL
    'title': 'Irises',
    'story':
    'Van Gogh\'s "Irises" showcases his fascination with nature. The vibrant flowers burst with life, and the swirling composition mirrors the artist\'s own turbulent emotions.',
  },
  {
    'image':
    'https://tse3.mm.bing.net/th?id=OIP.dOcUDZXZwInN6T4TLrty2wHaDl&pid=Api&P=0&h=180', // Replace with actual image URL
    'title': 'Wheatfield with Crows',
    'story':
    'As we approach the end of this journey, "Wheatfield with Crows" offers a powerful and somber view of a vast wheatfield. Some speculate that it reflects van Gogh\'s state of mind at the time.',
  },
  {
    'image':
    'https://tse4.mm.bing.net/th?id=OIP.dSGy1lXCfJ3BSPPTiP6lvwHaEj&pid=Api&P=0&h=180', // Replace with actual image URL
    'title': 'The Starry Night (Revisited)',
    'story':
    'Our journey concludes with another view of "The Starry Night." Van Gogh\'s artistic legacy lives on through this timeless masterpiece, inspiring generations of artists and dreamers.',
  },
];
