CREATE TABLE public.user_org_roles
(
    id         uuid        NOT NULL DEFAULT gen_random_uuid(),
    created_by uuid        NOT NULL,
    updated_by uuid        NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    user_id    uuid        NOT NULL,
    org_id     uuid        NOT NULL,
    role       text        NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES auth.users (id) ON UPDATE restrict ON DELETE cascade,
    FOREIGN KEY (org_id) REFERENCES public.organizations (id) ON UPDATE restrict ON DELETE cascade,
FOREIGN KEY (role) REFERENCES auth.roles (role) ON UPDATE restrict ON DELETE cascade,
UNIQUE (user_id, org_id)
);
COMMENT ON TABLE public.user_org_roles IS 'Table containing user''s org and default_role';
---
CREATE TRIGGER set_public_user_org_roles_updated_at
    BEFORE UPDATE
    ON public.user_org_roles
    FOR EACH ROW
EXECUTE PROCEDURE public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_user_org_roles_updated_at ON public.user_org_roles IS 'trigger to set value of column updated_at to current timestamp on row update';
---
CREATE TRIGGER insert_deleted_record_when_public_user_org_roles_deleted
    AFTER DELETE
    ON public.user_org_roles
    FOR EACH ROW
EXECUTE FUNCTION public.deleted_record_insert();
COMMENT ON TRIGGER insert_deleted_record_when_public_user_org_roles_deleted ON public.user_org_roles IS 'trigger to save deleted records for audit';
---
SET ROLE postgres;
--- Add the generated column current_org_user_id to auth.users metadata
ALTER TABLE auth.users
ADD COLUMN current_org_user_id uuid GENERATED ALWAYS AS (
    (
        metadata ->> 'current_org_user_id'
    )::uuid
) STORED;
--- Add the foreign key constraint to enforce the relationship
ALTER TABLE auth.users
ADD CONSTRAINT auth_users_current_org_user_id_fkey FOREIGN KEY (current_org_user_id) REFERENCES public.user_org_roles (id);

