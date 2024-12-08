DROP TRIGGER IF EXISTS trg_check_and_add_to_user_org_roles ON auth.users;
DROP FUNCTION IF EXISTS check_and_add_to_org_roles();