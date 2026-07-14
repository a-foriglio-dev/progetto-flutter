import 'package:flutter/material.dart';



class EchoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool hasBookmarkedEntries;
  final bool hasPrivateEntries;
  final ValueChanged<String> onFilterSelected;

  const EchoAppBar({
    super.key,
    required this.hasBookmarkedEntries,
    required this.hasPrivateEntries, // <-- E ANCHE QUI
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        // BoxFit.cover adatta l'immagine riempiendo lo spazio disponibile
        child: Image.asset('assets/immagini/logo.png', fit: BoxFit.cover),
      ),
      leadingWidth: 60,
      title: const Text('I miei Diari', style: TextStyle(fontWeight: FontWeight.w300)),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.filter_list),
          onSelected: onFilterSelected,
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'all', child: Text('Tutti i diari')),
            if (hasBookmarkedEntries)
              const PopupMenuItem(value: 'bookmarked', child: Text('Con segnalibro')),
            if (hasPrivateEntries)
              const PopupMenuItem(value: 'private', child: Text('Solo privati 🔒')),
          ],
        ),
        const SizedBox(width: 8.0),
      ],
    );
  }

  /// KToolbarHeight vale 56 pixel
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
