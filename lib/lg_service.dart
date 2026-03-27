import 'package:dartssh2/dartssh2.dart';
import 'package:home_widget/home_widget.dart';

class LGService {
  
  /// Connects to the rig, executes a command, and closes the connection.
  static Future<void> sendCommand(String command) async {
    try {
      // 1. Fetch the user's saved configuration from the native background
      final host = await HomeWidget.getWidgetData<String>('lg_ip');
      final username = await HomeWidget.getWidgetData<String>('lg_user') ?? 'lg';
      final password = await HomeWidget.getWidgetData<String>('lg_pass') ?? 'lg';

      // 2. Safety check: Did they enter an IP?
      if (host == null || host.isEmpty) {
        print('Error: IP Address not configured. Please open the app and save your settings.');
        return;
      }

      print('Attempting to connect to $host...');
      
      // 3. Connect using the dynamic variables
      final client = SSHClient(
        await SSHSocket.connect(host, 22, timeout: const Duration(seconds: 5)),
        username: username,
        onPasswordRequest: () => password,
      );

      print('Connected! Executing: $command');
      await client.execute(command);
      
      client.close();
      print('Command successful and connection closed.');
    } catch (e) {
      print('SSH Error: $e');
    }
  }
}