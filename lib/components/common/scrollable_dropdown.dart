import 'package:flutter/material.dart';

class ScrollableDropdown<T> extends StatelessWidget {
  final List<T> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final Widget Function(T) itemBuilder;

  const ScrollableDropdown({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<T>(
        value: value,
        onChanged: onChanged,
        items: items.map((T item) {
          return DropdownMenuItem<T>(
            value: item,
            child: itemBuilder(item),
          );
        }).toList(),
        selectedItemBuilder: (BuildContext context) {
          return items.map<Widget>((T item) {
            return itemBuilder(item);
          }).toList();
        },
        dropdownColor: Colors.white,
        icon: const Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        style: const TextStyle(color: Colors.black),
        underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
        isExpanded: true,
        itemHeight: 48.0,
        menuMaxHeight: 240.0, // 5 items * 48 height
      ),
    );
  }
}
