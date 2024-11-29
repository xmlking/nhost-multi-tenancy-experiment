alter table "public"."org_subscriptions"
  add constraint "org_subscriptions_vipps_session_id_fkey"
  foreign key ("vipps_session_id")
  references "payment"."vipps_sessions"
  ("id") on update restrict on delete cascade;
