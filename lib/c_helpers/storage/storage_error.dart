// part of super_fire;
//
// class StorageError {
//
//   const StorageError();
//
//   // -----------------------------------------------------------------------------
//
//   /// EXCEPTIONS
//
//   // --------------------
//   /// JUST A REFERENCE
//   static const Map<String, dynamic> storageErrorsMap = {
//     '[storage/unknown]'                 :	'An unknown error occurred.',
//     '[storage/object-not-found]'        :	'No object exists at the desired reference.',
//     '[storage/bucket-not-found]'        :	'No bucket is configured for Cloud Storage',
//     '[storage/project-not-found]'       :	'No project is configured for Cloud Storage',
//     '[storage/quota-exceeded]'          :	"Quota on your Cloud Storage bucket has been exceeded. If you're on the no-cost tier, upgrade to a paid plan. If you're on a paid plan, reach out to Firebase support.",
//     '[storage/unauthenticated]'         :	'User is unauthenticated, please authenticate and try again.',
//     '[storage/unauthorized]'            :	'User is not authorized to perform the desired action, check your security rules to ensure they are correct.',
//     '[storage/retry-limit-exceeded]'    :	'The maximum time limit on an operation (upload, download, delete, etc.) has been exceeded. Try uploading again.',
//     '[storage/invalid-checksum]'        :	'File on the client does not match the checksum of the file received by the server. Try uploading again.',
//     '[storage/canceled]'                :	'User canceled the operation.',
//     '[storage/invalid-event-name]'      :	'Invalid event name provided. Must be one of [`running`, `progress`, `pause`]',
//     '[storage/invalid-url]'             :	'Invalid URL provided to refFromURL(). Must be of the form: gs://bucket/object or https://firebasestorage.googleapis.com/v0/b/bucket/o/object?token=<TOKEN>',
//     '[storage/invalid-argument]'        :	'The argument passed to put() must be `File`, `Blob`, or `UInt8` Array. The argument passed to putString() must be a raw, `Base64`, or `Base64URL` string.',
//     '[storage/no-default-bucket]'       :	"No bucket has been set in your config's storageBucket property.",
//     '[storage/cannot-slice-blob]'       :	"Commonly occurs when the local file has changed (deleted, saved again, etc.). Try uploading again after verifying that the file hasn't changed.",
//     '[storage/server-file-wrong-size]'  :	'File on the client does not match the size of the file received by the server. Try uploading again.',
//
//     '[firebase_storage/unknown]'                 :	'An unknown error occurred.',
//     '[firebase_storage/object-not-found]'        :	'No object exists at the desired reference.',
//     '[firebase_storage/bucket-not-found]'        :	'No bucket is configured for Cloud Storage',
//     '[firebase_storage/project-not-found]'       :	'No project is configured for Cloud Storage',
//     '[firebase_storage/quota-exceeded]'          :	"Quota on your Cloud Storage bucket has been exceeded. If you're on the no-cost tier, upgrade to a paid plan. If you're on a paid plan, reach out to Firebase support.",
//     '[firebase_storage/unauthenticated]'         :	'User is unauthenticated, please authenticate and try again.',
//     '[firebase_storage/unauthorized]'            :	'User is not authorized to perform the desired action, check your security rules to ensure they are correct.',
//     '[firebase_storage/retry-limit-exceeded]'    :	'The maximum time limit on an operation (upload, download, delete, etc.) has been exceeded. Try uploading again.',
//     '[firebase_storage/invalid-checksum]'        :	'File on the client does not match the checksum of the file received by the server. Try uploading again.',
//     '[firebase_storage/canceled]'                :	'User canceled the operation.',
//     '[firebase_storage/invalid-event-name]'      :	'Invalid event name provided. Must be one of [`running`, `progress`, `pause`]',
//     '[firebase_storage/invalid-url]'             :	'Invalid URL provided to refFromURL(). Must be of the form: gs://bucket/object or https://firebasestorage.googleapis.com/v0/b/bucket/o/object?token=<TOKEN>',
//     '[firebase_storage/invalid-argument]'        :	'The argument passed to put() must be `File`, `Blob`, or `UInt8` Array. The argument passed to putString() must be a raw, `Base64`, or `Base64URL` string.',
//     '[firebase_storage/no-default-bucket]'       :	"No bucket has been set in your config's storageBucket property.",
//     '[firebase_storage/cannot-slice-blob]'       :	"Commonly occurs when the local file has changed (deleted, saved again, etc.). Try uploading again after verifying that the file hasn't changed.",
//     '[firebase_storage/server-file-wrong-size]'  :	'File on the client does not match the size of the file received by the server. Try uploading again.',
//
//   };
//   // --------------------
//   /// NOT TESTED NOR USED
//   static void onException(String? error){
//
//     if (TextCheck.isEmpty(error) == false){
//
//       // final String? _code = TextMod.removeTextAfterFirstSpecialCharacter(
//       //     text: error,
//       //     specialCharacter: ' ',
//       // );
//
//       // blog('onStorageExceptions : code : ($_code) : message : ${storageErrorsMap[_code]}');
//
//     }
//
//   }
//   // -----------------------------------------------------------------------------
//
// }
