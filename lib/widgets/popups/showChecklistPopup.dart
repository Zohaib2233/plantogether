import 'package:flutter/material.dart';

void showPopupChecklist(BuildContext context, {Function()? onEditTap,Function()? onDeleteTap}) {
  final RenderBox appBarRenderBox = context.findRenderObject() as RenderBox;
  final RenderBox overlay =
  Overlay.of(context).context.findRenderObject() as RenderBox;
  final RelativeRect position = RelativeRect.fromRect(
    Rect.fromPoints(
      appBarRenderBox.localToGlobal(Offset.zero, ancestor: overlay),
      appBarRenderBox.localToGlobal(
          appBarRenderBox.size.bottomRight(Offset.zero),
          ancestor: overlay),
    ),
    const Offset(-20, 00) & overlay.size,
  );

  showMenu<String>(
    context: context,
    position: position,
    items: [
      PopupMenuItem(
        value: 'edit',
        child: InkWell(
          onTap: onEditTap,
          child: const Row(
            children: [
              Icon(Icons.edit),
              SizedBox(width: 8),
              Text('Edit'),
            ],
          ),
        ),
      ),
   PopupMenuItem(
        value: 'delete',
        child: InkWell(
          onTap: onDeleteTap,
          child: const Row(
            children: [
              Icon(Icons.delete),
              SizedBox(width: 8),
              Text('Delete'),
            ],
          ),
        ),
      ),
    ],
  );
}