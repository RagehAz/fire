library super_fire;
// -----------------------------------------------------------------------------

import 'dart:io';

import 'package:basics/av/av.dart';
/// IMPORTS

// --------------------
/// COMMON
import 'package:basics/bldrs_theme/classes/colorz.dart';
import 'package:basics/bldrs_theme/classes/iconz.dart';
import 'package:basics/components/super_box/super_box.dart';
import 'package:basics/filing/filing.dart';
import 'package:basics/fire_helpers/models/a_authing/auth_model.dart';
import 'package:basics/fire_helpers/models/a_authing/sign_in_method.dart';
import 'package:basics/fire_helpers/models/a_authing/social_keys.dart';
import 'package:basics/fire_helpers/models/b_fire/fire_comparison_enum.dart';
import 'package:basics/fire_helpers/models/b_fire/fire_finder.dart';
import 'package:basics/fire_helpers/models/b_fire/fire_query_model.dart';
import 'package:basics/fire_helpers/models/b_fire/query_order_by.dart';
import 'package:basics/fire_helpers/models/c_real/real_query_model.dart';
import 'package:basics/fire_helpers/models/d_storage/storage_error.dart';
import 'package:basics/fire_helpers/pagination_controller/pagination_controller.dart';
import 'package:basics/fire_helpers/pagination_controller/scroll_listeners.dart';
import 'package:basics/helpers/checks/device_checker.dart';
import 'package:basics/helpers/checks/error_helpers.dart';
import 'package:basics/helpers/checks/errorize.dart';
import 'package:basics/helpers/checks/object_check.dart';
import 'package:basics/helpers/checks/tracers.dart';
import 'package:basics/helpers/maps/lister.dart';
import 'package:basics/helpers/maps/mapper.dart';
import 'package:basics/helpers/nums/booler.dart';
import 'package:basics/helpers/strings/pathing.dart';
import 'package:basics/helpers/strings/stringer.dart';
import 'package:basics/helpers/strings/text_check.dart';
import 'package:basics/helpers/strings/text_mod.dart';
import 'package:basics/helpers/time/timers.dart';
import 'package:basics/helpers/wire/wire.dart';
import 'package:fire/super_fire.dart';
import 'package:flutter/material.dart';
import 'dart:async';
/// OFFICIAL AUTH
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as f_a;
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as fui;
import 'package:firebase_ui_oauth_apple/firebase_ui_oauth_apple.dart';
import 'package:firebase_ui_oauth_facebook/firebase_ui_oauth_facebook.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/googleapis_auth.dart'; // as gapis;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
/// OFFICIAL FIRE
// import 'package:firebase_core/firebase_core.dart';
import 'package:basics/exports/cloud_firestore.dart' as cloud;
/// OFFICIAL REAL
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart' as f_db;
import 'package:basics/exports/http.dart'as http;
/// OFFICIAL STORAGE
// ignore: unnecessary_import
import 'package:firebase_storage/firebase_storage.dart' as f_s;
// -----------------------------------------------------------------------------

/// EXPORTS

// --------------------
/// AUTH
export 'package:firebase_auth/firebase_auth.dart';
/// FIRE
export 'package:firebase_core/firebase_core.dart';
export 'package:basics/exports/cloud_firestore.dart';
/// STORAGE
export 'package:firebase_storage/firebase_storage.dart';
// -----------------------------------------------------------------------------

/// FOUNDATION

// --------------------
/// OFFICIAL
part 'a_foundation/a_official_firebase_initializer.dart';
part 'a_foundation/b_official_authing.dart';
part 'a_foundation/c_official_fire.dart';
part 'a_foundation/d_official_real.dart';
part 'a_foundation/d_real_http.dart';
part 'a_foundation/e_official_storage.dart';
// -----------------------------------------------------------------------------

/// MODELS

// --------------------
/// AUTHING
// part 'b_models/a_authing/sign_in_method.dart';
// part 'b_models/a_authing/auth_model.dart';
// part 'b_models/a_authing/social_keys.dart';
/// FIRE
// part 'b_models/b_fire/fire_finder.dart';
// part 'b_models/b_fire/fire_query_model.dart';
// part 'b_models/b_fire/fire_comparison_enum.dart';
// part 'b_models/b_fire/query_order_by.dart';
/// REAL
// part 'b_models/c_real/real_query_model.dart';
/// STORAGE
// part 'b_models/d_storage/storage_meta_model.dart';
///
// -----------------------------------------------------------------------------

/// HELPERS

// --------------------
/// AUTHING
part 'c_helpers/authing/auth_blog.dart';
/// MAPPERS
part 'c_helpers/mappers/official_fire_mapper.dart';
/// STORAGE
// part 'c_helpers/storage/storage_error.dart';
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
part 'e_streamers/official_fire_coll_streamer.dart';
part 'e_streamers/official_fire_doc_streamer.dart';
/// REAL STREAMERS
part 'e_streamers/official_real_coll_streamer.dart';
part 'e_streamers/official_real_doc_streamer.dart';
part 'e_streamers/official_real_stream.dart';
// -----------------------------------------------------------------------------

/// PAGINATORS

// --------------------
/// FIRE PAGINATOR
part 'f_paginators/official_fire_coll_paginator.dart';
// part 'c_helpers/pagination_controller/pagination_controller.dart';
/// REAL PAGINATOR
part 'f_paginators/official_real_coll_paginator.dart';
/// HELPERS
// part 'c_helpers/pagination_controller/scroll_listeners.dart';

part 'b_models/official_fire_modelling.dart';
// -----------------------------------------------------------------------------
