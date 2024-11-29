CREATE TABLE "payment"."vipps_sessions" ("id" uuid NOT NULL DEFAULT gen_random_uuid(), "created_at" timestamptz NOT NULL DEFAULT now(), "updated_at" timestamptz NOT NULL DEFAULT now(), "org_id" uuid NOT NULL, "status" text NOT NULL DEFAULT 'INITIAL', "amount" integer NOT NULL, "vipps_reference" uuid NOT NULL, "currency" text NOT NULL, "quantity" integer NOT NULL, "product" text NOT NULL, "metadata" jsonb NOT NULL DEFAULT jsonb_build_object(), "org_user_id" uuid NOT NULL, PRIMARY KEY ("id") , FOREIGN KEY ("org_id") REFERENCES "public"."orgs"("id") ON UPDATE restrict ON DELETE cascade, FOREIGN KEY ("org_user_id") REFERENCES "public"."org_users"("id") ON UPDATE restrict ON DELETE cascade, UNIQUE ("vipps_reference"));
CREATE OR REPLACE FUNCTION "payment"."set_current_timestamp_updated_at"()
RETURNS TRIGGER AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updated_at" = NOW();
  RETURN _new;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER "set_payment_vipps_sessions_updated_at"
BEFORE UPDATE ON "payment"."vipps_sessions"
FOR EACH ROW
EXECUTE PROCEDURE "payment"."set_current_timestamp_updated_at"();
COMMENT ON TRIGGER "set_payment_vipps_sessions_updated_at" ON "payment"."vipps_sessions"
IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE EXTENSION IF NOT EXISTS pgcrypto;
