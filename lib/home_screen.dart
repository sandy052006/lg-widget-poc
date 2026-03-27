import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

class ConfigurationScreen extends StatefulWidget {
  const ConfigurationScreen({super.key});

  @override
  State<ConfigurationScreen> createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _userController = TextEditingController(text: 'lg'); 
  final TextEditingController _passController = TextEditingController(text: 'lg'); 

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  // Load existing data when the app opens
  Future<void> _loadSavedData() async {
    final ip = await HomeWidget.getWidgetData<String>('lg_ip');
    final user = await HomeWidget.getWidgetData<String>('lg_user');
    final pass = await HomeWidget.getWidgetData<String>('lg_pass');

    if (ip != null) setState(() => _ipController.text = ip);
    if (user != null) setState(() => _userController.text = user);
    if (pass != null) setState(() => _passController.text = pass);
  }

  // Save data to shared storage so the background widgets can use it
  Future<void> _saveConfig() async {
    await HomeWidget.saveWidgetData<String>('lg_ip', _ipController.text);
    await HomeWidget.saveWidgetData<String>('lg_user', _userController.text);
    await HomeWidget.saveWidgetData<String>('lg_pass', _passController.text);
    
    // Show a success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Configuration Saved! Widgets are ready.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LG Widget Setup'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter your Liquid Galaxy Master rig details below to enable background widget control.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _ipController,
              decoration: const InputDecoration(labelText: 'Master IP Address (e.g., 192.168.1.100)', border: OutlineInputBorder()),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _userController,
              decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passController,
              decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveConfig,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              child: const Text('Save Configuration', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}