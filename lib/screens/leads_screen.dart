import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'create_lead_screen.dart';

class LeadsScreen extends StatefulWidget {
  const LeadsScreen({super.key});

  @override
  State<LeadsScreen> createState() => _LeadsScreenState();
}

class _LeadsScreenState extends State<LeadsScreen> {
  final ApiService api = ApiService();
  List leads = [];
  bool loading = true;

  final List<String> statuses = ["Created", "Processing", "Finished"];

  @override
  void initState() {
    super.initState();
    fetchLeads();
  }

  Future<void> fetchLeads() async {
    final response = await api.get("/leads");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        leads =
            data.map((l) {
              l['status'] = (l['status'] ?? "Created").toString();
              return l;
            }).toList();
        loading = false;
      });
    }
  }

  Future<void> updateStatus(int id, String status) async {
    await api.patch("/leads/$id", {"status": status});
    fetchLeads();
  }

  Future<void> openCreateLeadDialog() async {
    await showDialog(
      context: context,
      builder:
          (context) => const Dialog(
            child: SizedBox(height: 420, child: CreateLeadScreen()),
          ),
    );

    fetchLeads();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Leads")),

      body:
          loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  border: TableBorder(
                    top: BorderSide(color: Colors.black),
                    bottom: BorderSide(color: Colors.black),
                    left: BorderSide(color: Colors.black),
                    right: BorderSide(color: Colors.black),
                    horizontalInside: BorderSide(color: Colors.black),
                    verticalInside: BorderSide(color: Colors.black),
                  ),
                  columns: const [
                    DataColumn(label: Text("First Name")),
                    DataColumn(label: Text("Last Name")),
                    DataColumn(label: Text("Email")),
                    DataColumn(label: Text("Phone")),
                    DataColumn(label: Text("Status")),
                  ],
                  rows:
                      leads.map<DataRow>((lead) {
                        String currentStatus =
                            statuses.contains(lead['status'])
                                ? lead['status']
                                : "Created";

                        return DataRow(
                          cells: [
                            DataCell(Text(lead['first_name'] ?? "")),
                            DataCell(Text(lead['last_name'] ?? "")),
                            DataCell(Text(lead['email'] ?? "")),
                            DataCell(Text(lead['phone'] ?? "")),

                            DataCell(
                              DropdownButton<String>(
                                value: currentStatus,
                                items:
                                    statuses
                                        .map(
                                          (s) => DropdownMenuItem(
                                            value: s,
                                            child: Text(s),
                                          ),
                                        )
                                        .toList(),
                                onChanged: (value) {
                                  updateStatus(lead['id'], value!);
                                },
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                ),
              ),

      floatingActionButton: FloatingActionButton(
        onPressed: openCreateLeadDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
