alter table "public"."org_subscriptions" alter column "vipps_session_id" drop not null;
alter table "public"."org_subscriptions" add column "vipps_session_id" text;
