/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/apple_logo.svg
  SvgGenImage get appleLogo => const SvgGenImage('assets/icons/apple_logo.svg');

  /// File path: assets/icons/cart_logo.svg
  SvgGenImage get cartLogo => const SvgGenImage('assets/icons/cart_logo.svg');

  /// File path: assets/icons/google_icon.svg
  SvgGenImage get googleIcon =>
      const SvgGenImage('assets/icons/google_icon.svg');

  /// File path: assets/icons/profile.svg
  SvgGenImage get profile => const SvgGenImage('assets/icons/profile.svg');

  /// File path: assets/icons/shop.svg
  SvgGenImage get shop => const SvgGenImage('assets/icons/shop.svg');

  /// File path: assets/icons/user_placeholder.png
  AssetGenImage get userPlaceholder =>
      const AssetGenImage('assets/icons/user_placeholder.png');

  /// File path: assets/icons/vendr_text_logo.svg
  SvgGenImage get vendrTextLogo =>
      const SvgGenImage('assets/icons/vendr_text_logo.svg');

  /// File path: assets/icons/waving_hand.svg
  SvgGenImage get wavingHand =>
      const SvgGenImage('assets/icons/waving_hand.svg');

  /// List of all assets
  List<dynamic> get values => [
    appleLogo,
    cartLogo,
    googleIcon,
    profile,
    shop,
    userPlaceholder,
    vendrTextLogo,
    wavingHand,
  ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/bike.png
  AssetGenImage get bike => const AssetGenImage('assets/images/bike.png');

  /// File path: assets/images/blocks_pattern.png
  AssetGenImage get blocksPattern =>
      const AssetGenImage('assets/images/blocks_pattern.png');

  /// File path: assets/images/disconnected.png
  AssetGenImage get disconnected =>
      const AssetGenImage('assets/images/disconnected.png');

  /// File path: assets/images/location_permission_required.png
  AssetGenImage get locationPermissionRequired =>
      const AssetGenImage('assets/images/location_permission_required.png');

  /// File path: assets/images/shop_marker.png
  AssetGenImage get shopMarker =>
      const AssetGenImage('assets/images/shop_marker.png');

  /// File path: assets/images/truck.png
  AssetGenImage get truck => const AssetGenImage('assets/images/truck.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    bike,
    blocksPattern,
    disconnected,
    locationPermissionRequired,
    shopMarker,
    truck,
  ];
}

class $AssetsJsonGen {
  const $AssetsJsonGen();

  /// Directory path: assets/json/map_styles
  $AssetsJsonMapStylesGen get mapStyles => const $AssetsJsonMapStylesGen();
}

class $AssetsJsonMapStylesGen {
  const $AssetsJsonMapStylesGen();

  /// File path: assets/json/map_styles/night_theme.json
  String get nightTheme => 'assets/json/map_styles/night_theme.json';

  /// List of all assets
  List<String> get values => [nightTheme];
}

class Assets {
  const Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsJsonGen json = $AssetsJsonGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName, {this.size, this.flavors = const {}});

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class SvgGenImage {
  const SvgGenImage(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = false;

  const SvgGenImage.vec(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter:
          colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
