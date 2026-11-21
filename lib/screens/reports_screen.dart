import 'package:flutter/material.dart';

import '../services/report_service.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = ReportService.all();
  }

  String _v(dynamic x) => x == null ? '-' : x.toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reports'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              await ReportService.clear();
              setState(() => _future = ReportService.all());
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final reports = snap.data!;
          if (reports.isEmpty) {
            return const Center(child: Text('No saved reports yet'));
          }
          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, i) {
              final r = reports[i];
              final date = (r['date'] as String).substring(0, 10);
              return Card(
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: Text('Scan on $date'),
                  subtitle: Text(
                    'N ${_v(r['n'])}  P ${_v(r['p'])}  K ${_v(r['k'])}\n'
                    'pH ${_v(r['ph'])}  OC ${_v(r['oc'])}',
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
