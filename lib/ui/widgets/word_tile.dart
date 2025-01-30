import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pao_myanmar_dictionary/data/word.dart';
import 'package:pao_myanmar_dictionary/ext.dart';
import 'package:share_plus/share_plus.dart';

class WordTile extends StatelessWidget {
  const WordTile({super.key, required this.item});
  final WordItem item;

  @override
  Widget build(BuildContext context) {
    final title = context.isMyanmar ? item.mm : item.pao;
    final subtitle = context.isMyanmar ? item.pao : item.mm;
    final text = "$title\n\n$subtitle";

    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      leading: CircleAvatar(
        child: Text(title[0]),
      ),
      onTap: () async {
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
        Share.share(text);
      },
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }
}
