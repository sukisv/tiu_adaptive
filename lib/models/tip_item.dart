class TipItem {
  final String num;
  final String text;

  const TipItem(this.num, this.text);

  factory TipItem.fromJson(Map<String, dynamic> json) {
    return TipItem(
      json['num'] as String,
      json['text'] as String,
    );
  }
}
