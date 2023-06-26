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

    if (_hasSignature(bytes, [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A])) {
      return FileType.png;
    }

    else if (_hasSignature(bytes, [0xFF, 0xD8, 0xFF])) {
      return FileType.jpeg;
    }

    else if (_hasSignature(bytes, [0x47, 0x49, 0x46, 0x38])) {
      return FileType.gif;
    }

    else if (_hasSignature(bytes, [0x42, 0x4D])) {
      return FileType.bmp;
    }

    else if (_hasSignature(bytes, [0x52, 0x49, 0x46, 0x46]) &&
        _hasSignature(bytes, [0x57, 0x45, 0x42, 0x50], offset: 8)) {
      return FileType.webp;
    }

    else if (_hasSignature(bytes, [0x49, 0x44, 0x33])) {
      return FileType.mp3;
    }

    else if (_hasSignature(bytes, [0x52, 0x49, 0x46, 0x46]) &&
        _hasSignature(bytes, [0x57, 0x41, 0x56, 0x45], offset: 8)) {
      return FileType.wav;
    }

    else if (_hasSignature(bytes, [0x4F, 0x67, 0x67, 0x53])) {
      return FileType.ogg;
    }

    else if (_hasSignature(bytes, [0x00, 0x00, 0x00, 0x20]) &&
        _hasSignature(bytes, [0x66, 0x74, 0x79, 0x70], offset: 4) &&
        _hasSignature(bytes, [0x6D, 0x70, 0x34, 0x32], offset: 8)) {
      return FileType.mp4;
    }

    else if (_hasSignature(bytes, [0x00, 0x00, 0x01, 0xBA])) {
      return FileType.mpeg;
    }

    else if (_hasSignature(bytes, [0x00, 0x00, 0x00, 0x18, 0x66, 0x74, 0x79, 0x70])) {
      return FileType.quicktime;
    }

    else if (_hasSignature(bytes, [0x25, 0x50, 0x44, 0x46])) {
      return FileType.pdf;
    }

    else if (_hasSignature(bytes, [0xD0, 0xCF, 0x11, 0xE0, 0xA1, 0xB1, 0x1A, 0xE1])) {
      return FileType.doc;
    }

    else if (_hasSignature(bytes, [0x50, 0x4B, 0x03, 0x04])) {
      return FileType.docx;
    }

    else if (_hasSignature(bytes, [0xD0, 0xCF, 0x11, 0xE0, 0xA1, 0xB1, 0x1A, 0xE1])) {
      return FileType.xls;
    }

    else if (_hasSignature(bytes, [0x50, 0x4B, 0x03, 0x04, 0x14, 0x00, 0x06, 0x00])) {
      return FileType.xlsx;
    }

    else if (_hasSignature(bytes, [0xD0, 0xCF, 0x11, 0xE0, 0xA1, 0xB1, 0x1A, 0xE1])) {
      return FileType.ppt;
    }

    else if (_hasSignature(bytes, [0x50, 0x4B, 0x03, 0x04, 0x14, 0x00, 0x06, 0x00])) {
      return FileType.pptx;
    }

    else if (_hasSignature(bytes, [0x00, 0x00, 0x00, 0x00]) &&
        _hasSignature(bytes, [0x6C, 0x6F, 0x63, 0x61, 0x6C, 0x65, 0x20, 0x74], offset: 8)) {
      return FileType.plainText;
    }

    else {
      return FileType.unknown;
    }
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
  /// AI GENERATED
  static String? _getContentType(FileType? fileType) {

    switch (fileType) {
      case FileType.png:        return 'image/png';
      case FileType.jpeg:       return 'image/jpeg';
      case FileType.gif:        return 'image/gif';
      case FileType.bmp:        return 'image/bmp';
      case FileType.webp:       return 'image/webp';
      case FileType.mp3:        return 'audio/mpeg';
      case FileType.wav:        return 'audio/wav';
      case FileType.ogg:        return 'audio/ogg';
      case FileType.mp4:        return 'video/mp4';
      case FileType.mpeg:       return 'video/mpeg';
      case FileType.quicktime:  return 'video/quicktime';
      case FileType.pdf:        return 'application/pdf';
      case FileType.doc:        return 'application/msword';
      case FileType.docx:       return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case FileType.xls:        return 'application/vnd.ms-excel';
      case FileType.xlsx:       return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      case FileType.ppt:        return 'application/vnd.ms-powerpoint';
      case FileType.pptx:       return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
      case FileType.plainText:  return 'text/plain';
      default: return null;
    }
  }
  // --------------------
  /// AI GENERATED
  static String? getContentType(Uint8List? bytes) {
    if (bytes == null){
      return null;
    }
    else {
      final fileType = _detectFileType(bytes);
      return _getContentType(fileType);
    }
  }
  // -----------------------------------------------------------------------------
}
