library super_fire;
// -----------------------------------------------------------------------------

/// IMPORTS

// --------------------
/// COMMON
import 'dart:io';
import 'package:basics/helpers/classes/checks/device_checker.dart';
import 'package:basics/helpers/classes/checks/error_helpers.dart';
import 'package:basics/helpers/classes/checks/object_check.dart';
import 'package:basics/helpers/classes/checks/tracers.dart';
import 'package:basics/helpers/classes/files/file_size_unit.dart';
import 'package:basics/helpers/classes/files/filers.dart';
import 'package:basics/helpers/classes/files/floaters.dart';
import 'package:basics/helpers/classes/maps/mapper.dart';
import 'package:basics/helpers/classes/nums/numeric.dart';
import 'package:basics/helpers/classes/rest/rest.dart';
import 'package:basics/helpers/classes/strings/stringer.dart';
import 'package:basics/helpers/classes/strings/text_check.dart';
import 'package:basics/helpers/classes/strings/text_mod.dart';
import 'package:basics/helpers/classes/time/timers.dart';
import 'package:flutter/material.dart';
import 'dart:async';
/// NATIVE IMPLEMENTATION
import 'package:firedart/firedart.dart' as fd;
import 'package:firebase_dart/firebase_dart.dart' as f_d;
import 'package:firedart/auth/user_gateway.dart' as fd_u;
/// OFFICIAL AUTH
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as f_a;
// import 'package:firebase_ui_auth/firebase_ui_auth.dart' as fui;
// import 'package:firebase_ui_oauth_apple/firebase_ui_oauth_apple.dart';
// import 'package:firebase_ui_oauth_facebook/firebase_ui_oauth_facebook.dart';
// import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/googleapis_auth.dart'; // as gapis;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
/// OFFICIAL FIRE
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cloud;
/// OFFICIAL REAL
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart' as f_db;
import 'package:http/http.dart' as http;
/// OFFICIAL STORAGE
// ignore: unnecessary_import
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:firebase_storage/firebase_storage.dart' as f_s;
// -----------------------------------------------------------------------------

/// EXPORTS

// --------------------
/// AUTH
export 'package:firebase_auth/firebase_auth.dart';
/// FIRE
export 'package:firebase_core/firebase_core.dart';
export 'package:cloud_firestore/cloud_firestore.dart';
/// STORAGE
export 'package:firebase_storage/firebase_storage.dart';
// -----------------------------------------------------------------------------

/// FOUNDATION

// --------------------
/// HYBRID
part 'a_foundation/a_hybrid/a_firebase_initializer.dart';
part 'a_foundation/a_hybrid/b_authing.dart';
part 'a_foundation/a_hybrid/c_fire.dart';
part 'a_foundation/a_hybrid/d_real.dart';
part 'a_foundation/a_hybrid/d_real_http.dart';
part 'a_foundation/a_hybrid/e_storage.dart';
// --------------------
/// OFFICIAL
part 'a_foundation/b_official/a_official_firebase_initializer.dart';
part 'a_foundation/b_official/b_official_authing.dart';
part 'a_foundation/b_official/c_official_fire.dart';
part 'a_foundation/b_official/d_official_real.dart';
part 'a_foundation/b_official/e_official_storage.dart';
// --------------------
/// NATIVE
part 'a_foundation/c_native/a_native_firebase_initializer.dart';
part 'a_foundation/c_native/b_native_authing.dart';
part 'a_foundation/c_native/c_native_fire.dart';
part 'a_foundation/c_native/d_native_real.dart';
part 'a_foundation/c_native/e_native_storage.dart';
// -----------------------------------------------------------------------------

/// MODELS

// --------------------
/// AUTHING
part 'b_models/a_authing/sign_in_method.dart';
part 'b_models/a_authing/auth_model.dart';
part 'b_models/a_authing/social_keys.dart';
/// FIRE
part 'b_models/b_fire/fire_finder.dart';
part 'b_models/b_fire/fire_query_model.dart';
part 'b_models/b_fire/fire_comparison_enum.dart';
part 'b_models/b_fire/query_order_by.dart';
/// REAL
part 'b_models/c_real/real_query_model.dart';
/// STORAGE
part 'b_models/d_storage/storage_meta_model.dart';
// -----------------------------------------------------------------------------

/// HELPERS

// --------------------
/// AUTHING
part 'c_helpers/authing/auth_error.dart';
part 'c_helpers/authing/auth_blog.dart';
/// MAPPERS
part 'c_helpers/mappers/official_fire_mapper.dart';
part 'c_helpers/mappers/native_fire_mapper.dart';
/// STORAGE
part 'c_helpers/storage/storage_error.dart';
part 'c_helpers/storage/fire_file_typer.dart';
// -----------------------------------------------------------------------------

/// WIDGETS

// --------------------
/// SCREENS
// --------------------
/// BUTTONS
part 'd_widgets/b_buttons/official_social_auth_button/auth_button_box.dart';
part 'd_widgets/b_buttons/official_social_auth_button/social_auth_button.dart';
// -----------------------------------------------------------------------------

/// STREAMERS

// --------------------
/// FIRE STREAMERS
part 'e_streamers/fire_coll_streamer.dart';
part 'e_streamers/fire_doc_streamer.dart';
/// REAL STREAMERS
part 'e_streamers/real_coll_streamer.dart';
part 'e_streamers/real_doc_streamer.dart';
part 'e_streamers/real_stream.dart';
// -----------------------------------------------------------------------------

/// PAGINATORS

// --------------------
/// FIRE PAGINATOR
part 'f_paginators/fire_coll_paginator.dart';
part 'f_paginators/pagination_controller.dart';
/// REAL PAGINATOR
part 'f_paginators/real_coll_paginator.dart';
/// HELPERS
part 'f_paginators/scroll_listeners.dart';
// -----------------------------------------------------------------------------
