CREATE TABLE "public"."org_subscriptions" ("id" uuid NOT NULL DEFAULT gen_random_uuid(), "created_at" timestamptz NOT NULL DEFAULT now(), "updated_at" timestamptz NOT NULL DEFAULT now(), "org_id" uuid NOT NULL, "status" text NOT NULL, "valid_until" timestamptz NOT NULL, "plan" text NOT NULL, "credits" integer NOT NULL DEFAULT 0, "stripe_subscription_id" text, "stripe_checkout_session_id" text, "stripe_customer_id" text, "vipps_session_id" text, PRIMARY KEY ("id") , FOREIGN KEY ("org_id") REFERENCES "public"."orgs"("id") ON UPDATE restrict ON DELETE cascade);
CREATE OR REPLACE FUNCTION "public"."set_current_timestamp_updated_at"()
RETURNS TRIGGER AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updated_at" = NOW();
  RETURN _new;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER "set_public_org_subscriptions_updated_at"
BEFORE UPDATE ON "public"."org_subscriptions"
FOR EACH ROW
EXECUTE PROCEDURE "public"."set_current_timestamp_updated_at"();
COMMENT ON TRIGGER "set_public_org_subscriptions_updated_at" ON "public"."org_subscriptions"
IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE EXTENSION IF NOT EXISTS pgcrypto;
