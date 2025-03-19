class NextPage {
  final NextPageType type;
  final String value;
  final NextPage? previous;

  const NextPage(this.type, this.value, [this.previous]);

  const NextPage.page()
      : type = NextPageType.page,
        value = '1',
        previous = null;

  const NextPage.cursor()
      : type = NextPageType.cursor,
        value = '',
        previous = null;

  operator +(int i) {
    if (type == NextPageType.page) {
      return NextPage(NextPageType.page, (int.parse(value) + 1).toString());
    } else {
      throw 'increment called on cursor';
    }
  }

  bool get firstPage => switch (type) {
        NextPageType.page => value == '1',
        NextPageType.cursor => value == '',
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other) ||
        other is NextPage &&
            runtimeType == other.runtimeType &&
            type == other.type &&
            value == other.value) return true;

    return switch (type) {
      NextPageType.page => other is int && int.tryParse(value) == other,
      NextPageType.cursor => other is String && value == other,
    };
  }

  @override
  int get hashCode => value.hashCode;

  NextPage next(String? next) {
    if (next == null) return this;
    switch (type) {
      case NextPageType.page:
        return NextPage(type, next, this);
      case NextPageType.cursor:
        return NextPage(type, next, this);
    }
  }

  NextPage reset() {
    return switch (type) {
      NextPageType.page => NextPage(type, '1'),
      NextPageType.cursor => NextPage(type, ''),
    };
  }

  int toInt() {
    return switch (type) {
      NextPageType.page => int.parse(value),
      NextPageType.cursor => throw Error(),
    };
  }
}

enum NextPageType {
  page,
  cursor,
}
