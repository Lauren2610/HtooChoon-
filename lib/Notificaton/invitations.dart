import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Providers/notificaton_provider.dart';
import 'package:provider/provider.dart';

class InvitationsTab extends StatelessWidget {
  const InvitationsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificatonProvider>();

    if (provider.invitations.isEmpty) {
      return const Center(child: Text('No invitations'));
    }

    return ListView.builder(
      itemCount: provider.invitations.length,
      itemBuilder: (context, index) {
        final data = provider.invitations[index].data() as Map<String, dynamic>;

        return ListTile(
          title: Text(data['title'] ?? ''),
          subtitle: Text(data['body'] ?? ''),
          trailing: Text(
            data['role'] ?? '',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}
