part of super_fire;

enum FileType {
  png,
  jpeg,
  gif,
  bmp,
  webp,
  mp3,
  wav,
  ogg,
  mp4,
  mpeg,
  quicktime,
  pdf,
  doc,
  docx,
  xls,
  xlsx,
  ppt,
  pptx,
  plainText,
  unknown,
}

class FireFileTyper {
  // -----------------------------------------------------------------------------

  const FireFileTyper();

  // -----------------------------------------------------------------------------
  /// AI GENERATED
  static FileType _detectFileType(Uint8List bytes) {
    FileType _output = FileType.unknown;


    if (_hasSignature(bytes, [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A])) {
      _output = FileType.png;
    }

    else if (_hasSignature(bytes, [0xFF, 0xD8, 0xFF])) {
      _output = FileType.jpeg;
    }

    else if (_hasSignature(bytes, [0x47, 0x49, 0x46, 0x38])) {
      _output = FileType.gif;
    }

    else if (_hasSignature(bytes, [0x42, 0x4D])) {
      _output = FileType.bmp;
    }

    else if (_hasSignature(bytes, [0x52, 0x49, 0x46, 0x46]) && _hasSignature(bytes, [0x57, 0x45, 0x42, 0x50], offset: 8)) {
      _output = FileType.webp;
    }

    else if (_hasSignature(bytes, [0x49, 0x44, 0x33])) {
      _output = FileType.mp3;
    }

    else if (_hasSignature(bytes, [0x52, 0x49, 0x46, 0x46]) && _hasSignature(bytes, [0x57, 0x41, 0x56, 0x45], offset: 8)) {
      _output = FileType.wav;
    }

    else if (_hasSignature(bytes, [0x4F, 0x67, 0x67, 0x53])) {
      _output = FileType.ogg;
    }

    // else if (_hasSignature(bytes, [0x00, 0x00, 0x00, 0x20]) &&
    //     _hasSignature(bytes, [0x66, 0x74, 0x79, 0x70], offset: 4) &&
    //     _hasSignature(bytes, [0x6D, 0x70, 0x34, 0x32], offset: 8)) {
    //   return FileType.mp4;
    // }
    else if (_hasSignature(bytes, [0x66, 0x74, 0x79, 0x70, 0x6D, 0x70, 0x34, 0x32])) {
      _output = FileType.mp4;
    }

    else if (_hasSignature(bytes, [0x00, 0x00, 0x01, 0xBA])) {
      _output = FileType.mpeg;
    }

    else if (_hasSignature(bytes, [0x00, 0x00, 0x00, 0x18, 0x66, 0x74, 0x79, 0x70])) {
      _output = FileType.quicktime;
    }

    else if (_hasSignature(bytes, [0x25, 0x50, 0x44, 0x46])) {
      _output = FileType.pdf;
    }

    else if (_hasSignature(bytes, [0xD0, 0xCF, 0x11, 0xE0, 0xA1, 0xB1, 0x1A, 0xE1])) {
      _output = FileType.doc;
    }

    else if (_hasSignature(bytes, [0x50, 0x4B, 0x03, 0x04])) {
      _output = FileType.docx;
    }

    else if (_hasSignature(bytes, [0xD0, 0xCF, 0x11, 0xE0, 0xA1, 0xB1, 0x1A, 0xE1])) {
      _output = FileType.xls;
    }

    else if (_hasSignature(bytes, [0x50, 0x4B, 0x03, 0x04, 0x14, 0x00, 0x06, 0x00])) {
      _output = FileType.xlsx;
    }

    else if (_hasSignature(bytes, [0xD0, 0xCF, 0x11, 0xE0, 0xA1, 0xB1, 0x1A, 0xE1])) {
      _output = FileType.ppt;
    }

    else if (_hasSignature(bytes, [0x50, 0x4B, 0x03, 0x04, 0x14, 0x00, 0x06, 0x00])) {
      _output = FileType.pptx;
    }

    else if (_hasSignature(bytes, [0x00, 0x00, 0x00, 0x00]) && _hasSignature(bytes, [0x6C, 0x6F, 0x63, 0x61, 0x6C, 0x65, 0x20, 0x74], offset: 8)) {
      _output = FileType.plainText;
    }

    else {
      _output = FileType.unknown;
    }

    // blog('_detectFileType : output : $_output');

    return _output;
  }
  // --------------------
  /// AI GENERATED
  static bool _hasSignature(Uint8List? bytes, List<int>? signature, {int offset = 0}) {

    if (bytes == null || signature == null || offset < 0) {
      return false;
    }

    else {

      if (offset + signature.length > bytes.length) {
        return false;
      }

      for (var i = 0; i < signature.length; i++) {
        if (bytes[offset + i] != signature[i]) {
          return false;
        }
      }

      return true;

    }
  }
  // --------------------
  static const String _png = 'image/png';
  static const String _jpeg = 'image/jpeg';
  static const String _gif = 'image/gif';
  static const String _bmp = 'image/bmp';
  static const String _webp = 'image/webp';
  static const String _ampeg = 'audio/mpeg';
  static const String _wav = 'audio/wav';
  static const String _ogg = 'audio/ogg';
  static const String _mp4 = 'video/mp4';
  static const String _vmpeg = 'video/mpeg';
  static const String _quicktime = 'video/quicktime';
  static const String _pdf = 'application/pdf';
  static const String _msword = 'application/msword';
  // static const String _x = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
  // static const String _x = 'application/vnd.ms-excel';
  // static const String _x = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
  // static const String _x = 'application/vnd.ms-powerpoint';
  // static const String _x = 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
  static const String _plain = 'text/plain';
  // --------------------
  /// AI GENERATED
  static String? _cipherType(FileType? fileType) {

    switch (fileType) {
      case FileType.png:        return _png;
      case FileType.jpeg:       return _jpeg;
      case FileType.gif:        return _gif;
      case FileType.bmp:        return _bmp;
      case FileType.webp:       return _webp;
      case FileType.mp3:        return _ampeg;
      case FileType.wav:        return _wav;
      case FileType.ogg:        return _ogg;
      case FileType.mp4:        return _mp4;
      case FileType.mpeg:       return _vmpeg;
      case FileType.quicktime:  return _quicktime;
      case FileType.pdf:        return _pdf;
      case FileType.doc:        return _msword;
      case FileType.plainText:  return _plain;
      // case FileType.docx:       return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      // case FileType.xls:        return 'application/vnd.ms-excel';
      // case FileType.xlsx:       return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      // case FileType.ppt:        return 'application/vnd.ms-powerpoint';
      // case FileType.pptx:       return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
      default: return null;
    }
  }
  // --------------------
  /// AI GENERATED
  static FileType? _decipherType(String? fileType) {

    switch (fileType) {
      case _png         : return FileType.png;
      case _jpeg        : return FileType.jpeg;
      case _gif         : return FileType.gif;
      case _bmp         : return FileType.bmp;
      case _webp        : return FileType.webp;
      case _ampeg       : return FileType.mp3;
      case _wav         : return FileType.wav;
      case _ogg         : return FileType.ogg;
      case _mp4         : return FileType.mp4;
      case _vmpeg       : return FileType.mpeg;
      case _quicktime   : return FileType.quicktime;
      case _pdf         : return FileType.pdf;
      case _msword      : return FileType.doc;
      case _plain       : return FileType.plainText;
      default: return null;
    }
  }
  // --------------------
  /// AI GENERATED
  static String? getContentType({
    required Uint8List? bytes,
    required FileType? forceType,
}) {
    if (bytes == null){
      return null;
    }
    else if (forceType != null){
      return _cipherType(forceType);
    }
    else {
      final fileType = _detectFileType(bytes);
      return _cipherType(fileType);
    }
  }
  // -----------------------------------------------------------------------------
}
