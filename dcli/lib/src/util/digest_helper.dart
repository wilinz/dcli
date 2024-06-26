/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'package:convert/convert.dart';

import 'package:crypto/crypto.dart';

/// Extends the Digest class
/// to provide hex encoder/decoder
extension DigestHelper on Digest {
  /// Encode a digest to a hex string.
  String hexEncode() => hex.encode(bytes);

  /// Decodes a string that contains a hexidecimal value
  /// into a digest.
  static Digest hexDecode(String hexValue) => Digest(hex.decode(hexValue));
}
