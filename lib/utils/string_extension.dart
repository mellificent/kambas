extension StringExtension on String {
  String inCap() {
    if (isEmpty) return this;
    return length > 0
        ? '${this[0].toUpperCase()}${substring(1)}'
        : '';
  }

  String allInCaps() {
    if (isEmpty) return this;
    return toUpperCase();
  }

  String inCapEachWord() {
    if (isEmpty) return this;
    return replaceAll(RegExp(' +'), ' ')
        .split(" ")
        .map((str) => str.inCap())
        .join(" ");
  }
}
