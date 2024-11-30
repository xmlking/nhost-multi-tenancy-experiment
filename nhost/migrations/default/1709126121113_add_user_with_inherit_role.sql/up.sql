INSERT INTO "auth"."roles"("role") VALUES (E'user_with_inherit') ON CONFLICT ("role") DO NOTHING;
INSERT INTO auth.roles (role) VALUES ('OWNER') ON CONFLICT ("role") DO NOTHING;
INSERT INTO auth.roles (role) VALUES ('MEMBER') ON CONFLICT ("role") DO NOTHING;
