-- Trigger Function for auth.users
CREATE OR REPLACE FUNCTION update_default_role_on_org_change()
RETURNS TRIGGER AS $$
BEGIN
    -- Update auth.users.default_role based on the new current_org_user_id
    IF NEW.current_org_user_id IS DISTINCT FROM OLD.current_org_user_id THEN
        UPDATE auth.users
        SET default_role = (
            SELECT role
            FROM public.user_org_roles
            WHERE id = NEW.current_org_user_id
        )
        WHERE id = NEW.id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger on auth.users
CREATE TRIGGER trg_update_default_role_on_org_change
AFTER UPDATE OF current_org_user_id
ON auth.users
FOR EACH ROW
EXECUTE FUNCTION update_default_role_on_org_change();

-- Trigger Function for public.user_org_roles
CREATE OR REPLACE FUNCTION update_default_role_on_role_change()
RETURNS TRIGGER AS $$
BEGIN
    -- Update auth.users.default_role based on the new role in public.user_org_roles
    IF NEW.role IS DISTINCT FROM OLD.role THEN
        UPDATE auth.users
        SET default_role = NEW.role
        WHERE id = OLD.user_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger on public.user_org_roles
CREATE TRIGGER trg_update_default_role_on_role_change
AFTER UPDATE OF role
ON public.user_org_roles
FOR EACH ROW
EXECUTE FUNCTION update_default_role_on_role_change();
