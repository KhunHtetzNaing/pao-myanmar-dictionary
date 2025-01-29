import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pao_myanmar_dictionary/data/word.dart';
import 'package:share_plus/share_plus.dart';

class WordTile extends StatelessWidget {
  const WordTile({super.key, required this.item});
  final WordItem item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.pao),
      subtitle: Text(item.mm),
      leading: CircleAvatar(
        child: Text(item.pao[0]),
      ),
      onTap: () async {
        final text = "${item.pao}\n\n${item.mm}";
        try {
          await Clipboard.setData(ClipboardData(text: text));
          if (context.mounted) {
            _showSnackbar(context, "ထူႏကူꩻထွူလဲဉ်းဩ။");
          }
        } catch (e) {
          if (context.mounted) {
            _showSnackbar(context, "$e");
          }
        }
      },
      onLongPress: () {
        Share.share("${item.pao}\n\n${item.mm}");
      },
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }
}
