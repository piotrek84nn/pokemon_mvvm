
extension Extension on Object? {
  bool isNullOrEmpty() => this == null || this == '';

  bool isNullEmptyOrFalse() => this == null || this == '' || this == false;

  bool isNullEmptyZeroOrFalse() =>
      this == null || this == '' || this == false || this == 0;

  String objectToEmptyString() {
    if (this == null) {
      return '';
    } else if (this == 'null' || this == "null") {
      return '';
    } else if (this is num) {
      return toString();
    } else if (this is String) {
      return toString();
    } else {
      return '';
    }
  }

  String toDashIfEmpty() {
    if (this == null) {
      return '-';
    } else if (this == 'null' || this == "null") {
      return '-';
    } else if (this is num) {
      return toString();
    } else if (this is String) {
      return toString();
    } else {
      return '-';
    }
  }
}

extension StringExtension on String? {
  String toEmptyString() {
    if (isNullOrEmpty()) return '';
    if (this == 'null' || this == "null") {
      return '';
    } else {
      return this!;
    }
  }

  String toDashIfEmpty() {
    if (isNullOrEmpty()) {
      return '-';
    } else {
      return this!;
    }
  }
}
