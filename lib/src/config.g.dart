// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ConfigCWProxy {
  Config deepLinkDomain(String deepLinkDomain);

  Config encryption(bool encryption);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Config(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Config(...).copyWith(id: 12, name: "My name")
  /// ````
  Config call({String deepLinkDomain, bool encryption});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfConfig.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfConfig.copyWith.fieldName(...)`
class _$ConfigCWProxyImpl implements _$ConfigCWProxy {
  const _$ConfigCWProxyImpl(this._value);

  final Config _value;

  @override
  Config deepLinkDomain(String deepLinkDomain) =>
      this(deepLinkDomain: deepLinkDomain);

  @override
  Config encryption(bool encryption) => this(encryption: encryption);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Config(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Config(...).copyWith(id: 12, name: "My name")
  /// ````
  Config call({
    Object? deepLinkDomain = const $CopyWithPlaceholder(),
    Object? encryption = const $CopyWithPlaceholder(),
  }) {
    return Config(
      deepLinkDomain:
          deepLinkDomain == const $CopyWithPlaceholder()
              ? _value.deepLinkDomain
              // ignore: cast_nullable_to_non_nullable
              : deepLinkDomain as String,
      encryption:
          encryption == const $CopyWithPlaceholder()
              ? _value.encryption
              // ignore: cast_nullable_to_non_nullable
              : encryption as bool,
    );
  }
}

extension $ConfigCopyWith on Config {
  /// Returns a callable class that can be used as follows: `instanceOfConfig.copyWith(...)` or like so:`instanceOfConfig.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ConfigCWProxy get copyWith => _$ConfigCWProxyImpl(this);
}
