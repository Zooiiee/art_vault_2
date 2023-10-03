import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:art_vault_2/theme/ThemeProvider.dart';
import 'package:popover/popover.dart';

class DrawingCanvas extends StatefulWidget {
  const DrawingCanvas({super.key});

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  List<Offset> offsets = <Offset>[];

  @override
  Widget build(BuildContext context) {
    List<String> popoverOptions = [
 'Discover the ArtVault Canvas – an artistic playground where you can craft your masterpiece using an unbroken stroke, allowing your imagination to flow without interruption.'
    ];
    final themeProvider = Provider.of<ThemeProvider>(context);

    final backgroundColor = themeProvider.isDarkModeEnabled
        ? Color(0xFF231A12) // Very Very Dark Brown
        : Color(0xFFEbd2a9);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        toolbarHeight: 52,
        iconTheme: IconThemeData(color: themeProvider.isDarkModeEnabled ? Color(0xFFEbd2a9): Color(0xFF231A12)),
        title:Text('Canvas',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24,color: themeProvider.isDarkModeEnabled ? Color(0xFFEbd2a9): Color(0xFF231A12),),),
        actions: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: themeProvider.isDarkModeEnabled ? Color(0xFFEbd2a9).withOpacity(0.6): Color(0xFF52412E).withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: Builder(
              builder: (context) {
                return GestureDetector(
                  onTap: () => _showPopover(context, popoverOptions),
                  child: Icon(Icons.more_vert,color:themeProvider.isDarkModeEnabled ? Color(0xFF231A12): Color(0xFFEbd2a9),),
                );
              },
            ),
          ),
          const SizedBox(width: 16.0),
        ],
        backgroundColor: themeProvider.isDarkModeEnabled
            ? Color(0xFF231A12)
            : Color(0xFFEbd2a9),


      ),
      body: Container(
        color: backgroundColor,
        child: GestureDetector(
          onPanUpdate: (DragUpdateDetails details) {
            setState(() {
              offsets.add(details.globalPosition);
            });
          },
          onPanEnd: (DragEndDetails details) => setState(() {}),
          child: CustomPaint(
            painter: Draw(offsets: offsets,themeProvider: Provider.of<ThemeProvider>(context)),
            size: Size.infinite,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor:  themeProvider.isDarkModeEnabled
            ? Color(0xFFEbd2a9) // Dark mode color
            : Color(0xFF52412E),
        icon: Icon(Icons.clear,color: themeProvider.isDarkModeEnabled ? Color(0xFF52412E) : Color(0xFFEbd2a9),),
        label: Text('Clear',style: TextStyle(fontSize:16,color: themeProvider.isDarkModeEnabled ? Color(0xFF52412E) : Color(0xFFEbd2a9),),),

        onPressed: () {
          setState(() => offsets.clear());
        },
      ),
    );
  }
  Future<Object?> _showPopover(
  BuildContext context,
      List<String> popoverOptions,
  ) {
  Size size = MediaQuery.sizeOf(context);
  return showPopover(
  context: context,
  backgroundColor: Color(0xFFF5F5DC),
  radius: 16.0,
  bodyBuilder: (context) => ListView(
  shrinkWrap: true,
  padding: EdgeInsets.zero,
  children: popoverOptions.map((option) {
  return ListTile(
  title: Text(option),
  onTap: () {
  Navigator.pushNamed(context, option);
  },
  );
  }).toList(),
  ),

  direction: PopoverDirection.top,
  width: size.width * 0.5,
  arrowHeight: 16.0,
  arrowWidth: 16.0,
  // onPop: () {},
  );
  }
}

class Draw extends CustomPainter {
  const Draw({required this.offsets, required this.themeProvider});
  final List<Offset> offsets;
  final ThemeProvider themeProvider;
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = themeProvider.isDarkModeEnabled
        ? Color(0xFFEbd2a9)
        : Color(0xFF52412E);

    paint.strokeWidth = 5.0;

    for (int i = 0; i < offsets.length - 1; i++) {
      canvas.drawLine(offsets[i], offsets[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(Draw oldDelegate) => true;
}

