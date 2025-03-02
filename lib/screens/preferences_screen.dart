import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final TextEditingController interestController = TextEditingController();
  final TextEditingController fanOfController = TextEditingController();
  final TextEditingController rivalController = TextEditingController();

  List<String> interestSuggestions = [];
  List<String> fanOfSuggestions = [];
  List<String> rivalSuggestions = [];

  @override
  void initState() {
    super.initState();
    _loadInitialSuggestions();
  }

  Future<void> _loadInitialSuggestions() async {
    // Load suggestions from Firestore for autocomplete
    final interestsSnapshot = await FirebaseFirestore.instance.collection('interests').get();
    final fanOfSnapshot = await FirebaseFirestore.instance.collection('fansOf').get();
    final rivalsSnapshot = await FirebaseFirestore.instance.collection('rivals').get();

    setState(() {
      interestSuggestions = interestsSnapshot.docs.map((doc) => doc['name'] as String).toList();
      fanOfSuggestions = fanOfSnapshot.docs.map((doc) => doc['name'] as String).toList();
      rivalSuggestions = rivalsSnapshot.docs.map((doc) => doc['name'] as String).toList();
    });
  }

  Future<void> _savePreferences() async {
    // Save the user preferences to Firestore
    final userId = 'your-unique-user-id'; // Replace with the actual user ID from FirebaseAuth

    await FirebaseFirestore.instance.collection('userPreferences').doc(userId).set({
      'interest': interestController.text,
      'fanOf': fanOfController.text,
      'rival': rivalController.text,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preferences saved successfully!')),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required List<String> suggestions,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            }
            return suggestions.where((suggestion) =>
                suggestion.toLowerCase().contains(textEditingValue.text.toLowerCase()));
          },
          onSelected: (String selection) {
            controller.text = selection;
          },
          fieldViewBuilder: (context, fieldTextEditingController, focusNode, onFieldSubmitted) {
            return TextFormField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: 'Enter $label',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Your Preferences'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInputField(
              label: 'Favorite Interest',
              controller: interestController,
              suggestions: interestSuggestions,
            ),
            _buildInputField(
              label: 'Fan of (Teams/Brands/People)',
              controller: fanOfController,
              suggestions: fanOfSuggestions,
            ),
            _buildInputField(
              label: 'Rival Teams/Brands/People',
              controller: rivalController,
              suggestions: rivalSuggestions,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _savePreferences,
              child: const Text('Save Preferences'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    interestController.dispose();
    fanOfController.dispose();
    rivalController.dispose();
    super.dispose();
  }
}
