import 'package:chat_app_firebase/env.dart';

const BASE_URL = "$API_DOMAIN/api";

const NOTIFICATION_BASE = "$BASE_URL/notification";
const GROUP_NOTIFICATION_BASE = "$NOTIFICATION_BASE/groups";
const CREATE_GROUP_NOTIFICATION = "$GROUP_NOTIFICATION_BASE/create";
const ACCEPT_GROUP_NOTIFICATION = "$GROUP_NOTIFICATION_BASE/request-accept";