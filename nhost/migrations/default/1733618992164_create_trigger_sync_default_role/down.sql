DROP TRIGGER IF EXISTS trg_update_default_role_on_org_change ON auth.users;
DROP FUNCTION IF EXISTS update_default_role_on_org_change();
DROP TRIGGER IF EXISTS trg_update_default_role_on_role_change ON public.user_org_roles;
DROP FUNCTION IF EXISTS update_default_role_on_role_change();