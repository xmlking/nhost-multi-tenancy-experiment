INSERT INTO "auth"."roles"("role") VALUES (E'user_with_inherit') ON CONFLICT ("role") DO NOTHING;
