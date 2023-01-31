library fire;

import 'package:fire/src/helpers/helpers.dart';
import 'package:fire/src/helpers/scroll_listeners.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mapper/mapper.dart';
import 'src/models/query_order_by.dart';
import 'dart:async';

// -----------------------------------------------------------------------------
/// FIRE
part 'src/foundation/methods.dart';
// --------------------------------------------
/// FIRE FINDER MODEL
part 'src/models/fire_finder.dart';
/// FIRE QUERY MODEL
part 'src/models/fire_query_model.dart';
/// FIRE COMPARISON
part 'src/models/fire_comparison_enum.dart';
// --------------------------------------------
/// FIRE COLL PAGINATOR
part 'src/paginator/fire_coll_paginator.dart';
part 'src/paginator/pagination_controller.dart';
// --------------------------------------------
/// FIRE COLL STREAMER
part 'src/streamer/fire_coll_streamer.dart';
part 'src/streamer/fire_doc_streamer.dart';
// -----------------------------------------------------------------------------
