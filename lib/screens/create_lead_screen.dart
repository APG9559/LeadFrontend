import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/lead_model.dart';

class CreateLeadScreen extends StatefulWidget {
  const CreateLeadScreen({super.key});

  @override
  State<CreateLeadScreen> createState() => _CreateLeadScreenState();
}

class _CreateLeadScreenState extends State<CreateLeadScreen> {
  final ApiService api = ApiService();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  bool loading = false;

  Future<void> createLead() async {
    setState(() => loading = true);

    Lead lead = Lead(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      email: emailController.text,
      phone: phoneController.text,
    );

    final response = await api.post("/leads", lead.toJson());

    setState(() => loading = false);

    if (response.statusCode == 201 || response.statusCode == 200) {
      Navigator.pop(context); // close popup / return
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to create lead")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          const Text(
            "Create Lead",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: firstNameController,
            decoration: const InputDecoration(labelText: "First Name"),
          ),

          TextField(
            controller: lastNameController,
            decoration: const InputDecoration(labelText: "Last Name"),
          ),

          TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: "Email"),
          ),

          TextField(
            controller: phoneController,
            decoration: const InputDecoration(labelText: "Phone"),
          ),

          const SizedBox(height: 20),

          loading
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                onPressed: createLead,
                child: const Text("Create Lead"),
              ),
        ],
      ),
    );
  }
}
