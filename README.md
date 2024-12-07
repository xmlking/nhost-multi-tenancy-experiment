# nHost multi-tenancy experiment


## Start

```shell
nhost down --volumes
nhost up --apply-seeds
```

## Test
Switch `current_org_user_id` field in `auth.users` table's JSONB `metadata` column between:
`017477ff-4e55-4be4-902e-61256faa4859` (`org:owner`) and `30726982-30f6-4a57-b2d6-bf87a86cc1e9` (`org:member`) 
for `auth.user.id = 572ad1c0-f97b-4e16-b1f6-8b5ca90f931f` and test below **SignIn** request via [auth.http](auth.http)

```sql
UPDATE auth.users
SET metadata = jsonb_set(metadata, '{current_org_user_id}', '"30726982-30f6-4a57-b2d6-bf87a86cc1e9"')
WHERE id = '572ad1c0-f97b-4e16-b1f6-8b5ca90f931f';
--- revert
UPDATE auth.users
SET metadata = jsonb_set(metadata, '{current_org_user_id}', '"017477ff-4e55-4be4-902e-61256faa4859"')
WHERE id = '572ad1c0-f97b-4e16-b1f6-8b5ca90f931f';
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

Or 

```shell
http POST  https://local.auth.local.nhost.run/v1/signin/email-password \
 email=john.smith@gmail.com \
 password='Str0ngPassw#ord-94|%'
```

Response 

```
HTTP/1.1 200 OK
Content-Length: 1492
Content-Type: application/json
Date: Fri, 06 Dec 2024 01:51:15 GMT
Connection: close

{
  "session": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MzM0NTA3NzUsImh0dHBzOi8vaGFzdXJhLmlvL2p3dC9jbGFpbXMiOnsieC1oYXN1cmEtYWxsb3dlZC1yb2xlcyI6WyJ1c2VyIiwibWUiLCJvcmc6b3duZXIiXSwieC1oYXN1cmEtZGVmYXVsdC1yb2xlIjoib3JnOm93bmVyIiwieC1oYXN1cmEtb3JnLWlkIjoiOGRmZDlhMzEtZGUwMS00N2JlLTkyYTctYmExYzcyMGM2MjcwIiwieC1oYXN1cmEtb3JnLWlkcyI6IntcIjhkZmQ5YTMxLWRlMDEtNDdiZS05MmE3LWJhMWM3MjBjNjI3MFwiLFwiZDVkYmI2YjYtNWU0My00ZGNhLWI4NTUtYmU5YjY1YjY2OTViXCJ9IiwieC1oYXN1cmEtb3JnLXVzZXItaWQiOiIwMTc0NzdmZi00ZTU1LTRiZTQtOTAyZS02MTI1NmZhYTQ4NTkiLCJ4LWhhc3VyYS11c2VyLWVtYWlsIjoiam9obi5zbWl0aEBnbWFpbC5jb20iLCJ4LWhhc3VyYS11c2VyLWlkIjoiNTcyYWQxYzAtZjk3Yi00ZTE2LWIxZjYtOGI1Y2E5MGY5MzFmIiwieC1oYXN1cmEtdXNlci1pcy1hbm9ueW1vdXMiOiJmYWxzZSJ9LCJpYXQiOjE3MzM0NDk4NzUsImlzcyI6Imhhc3VyYS1hdXRoIiwic3ViIjoiNTcyYWQxYzAtZjk3Yi00ZTE2LWIxZjYtOGI1Y2E5MGY5MzFmIn0.WIVWxKXAa38c-qGzHjRfPh3o355FraZ3XINEsy8M6Sg",
    "accessTokenExpiresIn": 900,
    "refreshToken": "420b2f81-1d2c-4190-a8b2-c39218f683a2",
    "refreshTokenId": "2aa8e368-eeeb-4d04-9d1f-516bc6425722",
    "user": {
      "avatarUrl": "https://www.gravatar.com/avatar/1c874909e198bf87d38b50ef7e4d3163?d=mp\u0026r=g",
      "createdAt": "2024-12-02T03:17:53.317046Z",
      "defaultRole": "org:owner",
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
        "me",
        "org:owner"
      ]
    }
  }
}
```

```json
{
  "exp": 1733450775,
  "https://hasura.io/jwt/claims": {
    "x-hasura-allowed-roles": [
      "user",
      "me",
      "org:owner"
    ],
    "x-hasura-default-role": "org:owner",
    "x-hasura-org-id": "8dfd9a31-de01-47be-92a7-ba1c720c6270",
    "x-hasura-org-ids": "{\"8dfd9a31-de01-47be-92a7-ba1c720c6270\",\"d5dbb6b6-5e43-4dca-b855-be9b65b6695b\"}",
    "x-hasura-org-user-id": "017477ff-4e55-4be4-902e-61256faa4859",
    "x-hasura-user-email": "john.smith@gmail.com",
    "x-hasura-user-id": "572ad1c0-f97b-4e16-b1f6-8b5ca90f931f",
    "x-hasura-user-is-anonymous": "false"
  },
  "iat": 1733449875,
  "iss": "hasura-auth",
  "sub": "572ad1c0-f97b-4e16-b1f6-8b5ca90f931f"
}
```

After switching `current_org`

```
HTTP/1.1 200 OK
Content-Length: 1497
Content-Type: application/json
Date: Fri, 06 Dec 2024 01:53:41 GMT
Connection: close

{
  "session": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MzM0NTA5MjEsImh0dHBzOi8vaGFzdXJhLmlvL2p3dC9jbGFpbXMiOnsieC1oYXN1cmEtYWxsb3dlZC1yb2xlcyI6WyJ1c2VyIiwibWUiLCJvcmc6bWVtYmVyIl0sIngtaGFzdXJhLWRlZmF1bHQtcm9sZSI6Im9yZzptZW1iZXIiLCJ4LWhhc3VyYS1vcmctaWQiOiJkNWRiYjZiNi01ZTQzLTRkY2EtYjg1NS1iZTliNjViNjY5NWIiLCJ4LWhhc3VyYS1vcmctaWRzIjoie1wiOGRmZDlhMzEtZGUwMS00N2JlLTkyYTctYmExYzcyMGM2MjcwXCIsXCJkNWRiYjZiNi01ZTQzLTRkY2EtYjg1NS1iZTliNjViNjY5NWJcIn0iLCJ4LWhhc3VyYS1vcmctdXNlci1pZCI6IjMwNzI2OTgyLTMwZjYtNGE1Ny1iMmQ2LWJmODdhODZjYzFlOSIsIngtaGFzdXJhLXVzZXItZW1haWwiOiJqb2huLnNtaXRoQGdtYWlsLmNvbSIsIngtaGFzdXJhLXVzZXItaWQiOiI1NzJhZDFjMC1mOTdiLTRlMTYtYjFmNi04YjVjYTkwZjkzMWYiLCJ4LWhhc3VyYS11c2VyLWlzLWFub255bW91cyI6ImZhbHNlIn0sImlhdCI6MTczMzQ1MDAyMSwiaXNzIjoiaGFzdXJhLWF1dGgiLCJzdWIiOiI1NzJhZDFjMC1mOTdiLTRlMTYtYjFmNi04YjVjYTkwZjkzMWYifQ.XNxDi8nTpauTpZ2HkiKG_8VeEV3IbzK1vkkvIPnO3kE",
    "accessTokenExpiresIn": 900,
    "refreshToken": "27800a23-0c4b-49f8-8be3-bffa1f756948",
    "refreshTokenId": "d385e436-e595-4d53-ad1b-e55687504592",
    "user": {
      "avatarUrl": "https://www.gravatar.com/avatar/1c874909e198bf87d38b50ef7e4d3163?d=mp\u0026r=g",
      "createdAt": "2024-12-02T03:17:53.317046Z",
      "defaultRole": "org:member",
      "displayName": "John Smith",
      "email": "john.smith@gmail.com",
      "emailVerified": false,
      "id": "572ad1c0-f97b-4e16-b1f6-8b5ca90f931f",
      "isAnonymous": false,
      "locale": "en",
      "metadata": {
        "current_org_user_id": "30726982-30f6-4a57-b2d6-bf87a86cc1e9"
      },
      "phoneNumberVerified": false,
      "roles": [
        "user",
        "me",
        "org:member"
      ]
    }
  }
}

```

```json
{
  "exp": 1733450921,
  "https://hasura.io/jwt/claims": {
    "x-hasura-allowed-roles": [
      "user",
      "me",
      "org:member"
    ],
    "x-hasura-default-role": "org:member",
    "x-hasura-org-id": "d5dbb6b6-5e43-4dca-b855-be9b65b6695b",
    "x-hasura-org-ids": "{\"8dfd9a31-de01-47be-92a7-ba1c720c6270\",\"d5dbb6b6-5e43-4dca-b855-be9b65b6695b\"}",
    "x-hasura-org-user-id": "30726982-30f6-4a57-b2d6-bf87a86cc1e9",
    "x-hasura-user-email": "john.smith@gmail.com",
    "x-hasura-user-id": "572ad1c0-f97b-4e16-b1f6-8b5ca90f931f",
    "x-hasura-user-is-anonymous": "false"
  },
  "iat": 1733450021,
  "iss": "hasura-auth",
  "sub": "572ad1c0-f97b-4e16-b1f6-8b5ca90f931f"
}
```
## Hasura Auth Custom

```shell
docker tag nhost/hasura-auth:0.36.1-sumo ghcr.io/xmlking/nhost-multi-tenancy-experiment/hasura-auth:0.36.1-sumo
docker push ghcr.io/xmlking/nhost-multi-tenancy-experiment/hasura-auth:0.36.1-sumo
```

### Export Seeds

```shell
hasura seed create 001_users --database-name default --from-table auth.users --endpoint https://local.hasura.local.nhost.run --admin-secret hasura-admin-secret
hasura seed create 002_user_roles --database-name default --from-table auth.user_roles --endpoint https://local.hasura.local.nhost.run --admin-secret hasura-admin-secret
hasura seed create 003_organizations --database-name default --from-table public.organizations --endpoint https://local.hasura.local.nhost.run --admin-secret hasura-admin-secret
hasura seed create 004_user_org_roles --database-name default --from-table public.user_org_roles --endpoint https://local.hasura.local.nhost.run --admin-secret hasura-admin-secret
```

## Schema

![diagram.png](diagram.png)

## Limitations
