# nHost multi-tenant experiment

Based on <https://github.com/viktorfa/nhost-saas-boilerplate/tree/main>

## Start

```shell
nhost down --volumes
nhost up --apply-seeds
```

### Export Seeds

```shell
hasura seed create 001_users --database-name default --from-table auth.users --endpoint https://local.hasura.local.nhost.run --admin-secret hasura-admin-secret
hasura seed create 002_user_roles --database-name default --from-table auth.user_roles --endpoint https://local.hasura.local.nhost.run --admin-secret hasura-admin-secret
hasura seed create 003_organizations --database-name default --from-table public.organizations --endpoint https://local.hasura.local.nhost.run --admin-secret hasura-admin-secret
hasura seed create 004_user_org_roles --database-name default --from-table public.user_org_roles --endpoint https://local.hasura.local.nhost.run --admin-secret hasura-admin-secret
```

## Test
Switch `current_org_user_id` filed in `auth.users` table's JSONB `metadata` column betweenL:
`017477ff-4e55-4be4-902e-61256faa4859` (`org:owner`) and `30726982-30f6-4a57-b2d6-bf87a86cc1e9` (`org:member`) 
for `auth.user.id = 572ad1c0-f97b-4e16-b1f6-8b5ca90f931f` and test below **SignIn** request

```sql
UPDATE auth.users
SET metadata = jsonb_set(metadata, '{current_org_user_id}', '"30726982-30f6-4a57-b2d6-bf87a86cc1e9"'),
    default_role = uor.role
    FROM public.user_org_roles AS uor
WHERE auth.users.id = '572ad1c0-f97b-4e16-b1f6-8b5ca90f931f'
  AND uor.id = '30726982-30f6-4a57-b2d6-bf87a86cc1e9';

--- revert
UPDATE auth.users
SET metadata = jsonb_set(metadata, '{current_org_user_id}', '"017477ff-4e55-4be4-902e-61256faa4859"'),
    default_role = uor.role
    FROM public.user_org_roles AS uor
WHERE auth.users.id = '572ad1c0-f97b-4e16-b1f6-8b5ca90f931f'
  AND uor.id = '017477ff-4e55-4be4-902e-61256faa4859';
```

```http
### SignIn
# @name signIn
POST {{authEndpoint}}/signin/email-password
Content-Type: application/json

{
  "email": "{{userEmail}}",
  "password": "{{userPassword}}"
}
```

Response

```
HTTP/1.1 200 OK
Access-Control-Allow-Origin: *
Cache-Control: no-store, no-cache, must-revalidate, proxy-revalidate
Content-Length: 1454
Content-Type: application/json; charset=utf-8
Date: Sat, 30 Nov 2024 23:36:27 GMT
Etag: W/"5ae-XOZL78xLtqSMVpAicUPBsH53oKw"
Expires: 0
Pragma: no-cache
Strict-Transport-Security: max-age=15552000; includeSubDomains
Surrogate-Control: no-store
X-Content-Type-Options: nosniff
X-Dns-Prefetch-Control: off
X-Download-Options: noopen
X-Frame-Options: SAMEORIGIN
X-Xss-Protection: 1; mode=block
Connection: close

{
  "session": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MzMxMTU3NzcsImh0dHBzOi8vaGFzdXJhLmlvL2p3dC9jbGFpbXMiOnsieC1oYXN1cmEtYWxsb3dlZC1yb2xlcyI6IntcInVzZXJcIixcIm1lXCJ9IiwieC1oYXN1cmEtZGVmYXVsdC1yb2xlIjoib3JnOm93bmVyIiwieC1oYXN1cmEtb3JnLWlkIjoiOGRmZDlhMzEtZGUwMS00N2JlLTkyYTctYmExYzcyMGM2MjcwIiwieC1oYXN1cmEtb3JnLWlkcyI6IntcIjhkZmQ5YTMxLWRlMDEtNDdiZS05MmE3LWJhMWM3MjBjNjI3MFwiLFwiZDVkYmI2YjYtNWU0My00ZGNhLWI4NTUtYmU5YjY1YjY2OTViXCJ9IiwieC1oYXN1cmEtb3JnLXVzZXItaWQiOiIwMTc0NzdmZi00ZTU1LTRiZTQtOTAyZS02MTI1NmZhYTQ4NTkiLCJ4LWhhc3VyYS11c2VyLWVtYWlsIjoiam9obi5zbWl0aEBnbWFpbC5jb20iLCJ4LWhhc3VyYS11c2VyLWlkIjoiNTcyYWQxYzAtZjk3Yi00ZTE2LWIxZjYtOGI1Y2E5MGY5MzFmIiwieC1oYXN1cmEtdXNlci1pcy1hbm9ueW1vdXMiOiJmYWxzZSJ9LCJpYXQiOjE3MzMxMTQ4NzcsImlzcyI6Imhhc3VyYS1hdXRoIiwic3ViIjoiNTcyYWQxYzAtZjk3Yi00ZTE2LWIxZjYtOGI1Y2E5MGY5MzFmIn0.ENprVIYuwEFzocse6hG6xSM_4wPwyISZheOb5qX6pDA",
    "accessTokenExpiresIn": 900,
    "refreshToken": "de3ef435-d125-4568-a686-a4b85069726b",
    "refreshTokenId": "7d617cf3-06b2-4ce0-ba57-e5d54c47a58d",
    "user": {
      "avatarUrl": "https://www.gravatar.com/avatar/1c874909e198bf87d38b50ef7e4d3163?d=mp\u0026r=g",
      "createdAt": "2024-12-02T03:17:53.317046Z",
      "defaultRole": "user",
      "displayName": "John Smith",
      "email": "john.smith@gmail.com",
      "emailVerified": false,
      "id": "572ad1c0-f97b-4e16-b1f6-8b5ca90f931f",
      "isAnonymous": false,
      "locale": "en",
      "metadata": {
        "current_org_user_id": "017477ff-4e55-4be4-902e-61256faa4859"
      },
      "phoneNumberVerified": false,
      "roles": [
        "user",
        "me"
      ]
    }
  }
}
```

```json
{
  "exp": 1733115777,
  "https://hasura.io/jwt/claims": {
    "x-hasura-allowed-roles": "{\"user\",\"me\"}",
    "x-hasura-default-role": "org:owner",
    "x-hasura-org-id": "8dfd9a31-de01-47be-92a7-ba1c720c6270",
    "x-hasura-org-ids": "{\"8dfd9a31-de01-47be-92a7-ba1c720c6270\",\"d5dbb6b6-5e43-4dca-b855-be9b65b6695b\"}",
    "x-hasura-org-user-id": "017477ff-4e55-4be4-902e-61256faa4859",
    "x-hasura-user-email": "john.smith@gmail.com",
    "x-hasura-user-id": "572ad1c0-f97b-4e16-b1f6-8b5ca90f931f",
    "x-hasura-user-is-anonymous": "false"
  },
  "iat": 1733114877,
  "iss": "hasura-auth",
  "sub": "572ad1c0-f97b-4e16-b1f6-8b5ca90f931f"
}
```

## Hasura Auth Custom

```shell
docker tag nhost/hasura-auth:0.36.1-sumo ghcr.io/xmlking/nhost-multi-tenancy-experiment/hasura-auth:0.36.1-sumo
docker push ghcr.io/xmlking/nhost-multi-tenancy-experiment/hasura-auth:0.36.1-sumo
```

## Schema

![diagram.png](diagram.png)

## Limitations

- we need to fork [nhost/hasura-auth](https://github.com/nhost/hasura-auth) and [allow custom claims to overwrite the default claims](https://github.com/xmlking/hasura-auth/commit/6b22b22d090a07f7292f8e35ae4b4a93f16832b5) untile the official nhost natively suport `multi-tenency`.
