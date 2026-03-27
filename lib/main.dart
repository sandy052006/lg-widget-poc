import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'home_screen.dart';
import 'lg_service.dart';

// 1. The Background Listener (Must be top-level!)
@pragma('vm:entry-point')
Future<void> backgroundCallback(Uri? uri) async {
  
  if (uri?.host == 'reset') {
    print("Widget tapped: Sending Reset command...");
    await LGService.sendCommand("echo '' > /tmp/query.txt"); 
    
  } else if (uri?.host == 'shutdown') {
    print("Widget tapped: Sending Shutdown command...");
    await LGService.sendCommand("sudo poweroff"); 
    
  } else if (uri?.host == 'tile_toggle') {
    print("Tile tapped: Sending Emergency Stop...");
    await LGService.sendCommand("echo 'stop' > /tmp/query.txt"); 

  } else if (uri?.host == 'check_status') {
    print("Widget tapped: Checking LG Rig status...");
    bool isOnline = false;
    try {
      await LGService.sendCommand("echo 'ping' > /dev/null");
      isOnline = true;
    } catch (e) {
      isOnline = false;
    }

    // Save the status and tell Android to redraw the status widget
    await HomeWidget.saveWidgetData<String>('lg_status', isOnline ? 'ONLINE' : 'OFFLINE');
    await HomeWidget.updateWidget(
      name: 'StatusWidgetProvider',
      androidName: 'StatusWidgetProvider',
    );
    print("Status updated: ${isOnline ? 'ONLINE' : 'OFFLINE'}");
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // 2. Register the callback with the native OS
  HomeWidget.registerBackgroundCallback(backgroundCallback);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LG Widgets PoC',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: const ConfigurationScreen(), // Load the UI we just built
    );
  }
}