CREATE OR REPLACE FUNCTION public.current_org_users_default_role(user_row auth.users)
    RETURNS text
    LANGUAGE sql
    STABLE
AS $function$
SELECT ou.role
FROM public.user_profiles up
         JOIN public.org_users ou ON up.current_org_user = ou.id
WHERE up.user_id = user_row.id
$function$;
