import 'package:flare_flutter/flare_cache.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/services.dart';

/// A list of Rive (Flare) assets to precache before use.
const _filesToCache = ['assets/rive/animated_icons/search_clear.flr'];

/// Precaches the files listed in [_filesToCache].
Future<void> precacheRive() async {
  for (final filename in _filesToCache) {
    await cachedActor(AssetFlare(bundle: rootBundle, name: filename));
  }
}
