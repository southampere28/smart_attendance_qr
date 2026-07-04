class PositionItem {
  PositionItem(this.type, this.displayValue);

  final PositionItemType type;
  final String displayValue;
}

enum PositionItemType {
  log,
  position,
}
