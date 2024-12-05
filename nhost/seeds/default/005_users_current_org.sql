SET check_function_bodies = false;
UPDATE auth.users SET metadata = jsonb_set(metadata, '{current_org_user_id}', '"017477ff-4e55-4be4-902e-61256faa4859"') WHERE id = '572ad1c0-f97b-4e16-b1f6-8b5ca90f931f';
UPDATE auth.users SET metadata = jsonb_set(metadata, '{current_org_user_id}', '"b5a75385-47de-429a-9488-433567deb762"') WHERE id = 'bacd19f4-0cc4-43d1-9e7a-4e5098ed8d83';
