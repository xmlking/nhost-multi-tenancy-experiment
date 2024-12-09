# nHost multi-tenancy experiment

## Start

```shell
nhost down --volumes
nhost up --apply-seeds
```

## Test

Switch `is_current_org` true between:
1. org_id = `8dfd9a31-de01-47be-92a7-ba1c720c6270`  (role: `org:owner`) 
2. org_id = `d5dbb6b6-5e43-4dca-b855-be9b65b6695b`  (role: `org:member`)

for user_id = `572ad1c0-f97b-4e16-b1f6-8b5ca90f931f` and test below **SignIn** request via [auth.http](auth.http)

```sql
UPDATE public.user_org_roles SET is_current_org = true WHERE user_id = '572ad1c0-f97b-4e16-b1f6-8b5ca90f931f' and org_id = 'd5dbb6b6-5e43-4dca-b855-be9b65b6695b';
UPDATE public.user_org_roles SET is_current_org = true WHERE user_id = '572ad1c0-f97b-4e16-b1f6-8b5ca90f931f' and org_id = '8dfd9a31-de01-47be-92a7-ba1c720c6270';
```

```http
### SignIn
# @name signIn
POST {{authEndpoint}}/signin/email-password
Content-Type: application/json

{
  "email": "john.smith@chinthagunta.com",
  "password": "Str0ngPassw#ord-94|%"
}
```

Or

```shell
http POST  https://local.auth.local.nhost.run/v1/signin/email-password \
 email=john.smith@chinthagunta.com \
 password='Str0ngPassw#ord-94|%'
```

Response

```
HTTP/1.1 200 OK
Content-Length: 1366
Content-Type: application/json
Date: Sun, 08 Dec 2024 21:58:44 GMT

{
    "session": {
        "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MzM2OTYwMjQsImh0dHBzOi8vaGFzdXJhLmlvL2p3dC9jbGFpbXMiOnsieC1oYXN1cmEtYWxsb3dlZC1yb2xlcyI6WyJ1c2VyIiwibWUiLCJvcmc6b3duZXIiXSwieC1oYXN1cmEtZGVmYXVsdC1yb2xlIjoib3JnOm93bmVyIiwieC1oYXN1cmEtb3JnLWlkIjoiOGRmZDlhMzEtZGUwMS00N2JlLTkyYTctYmExYzcyMGM2MjcwIiwieC1oYXN1cmEtb3JnLWlkcyI6IntcImQ1ZGJiNmI2LTVlNDMtNGRjYS1iODU1LWJlOWI2NWI2Njk1YlwiLFwiOGRmZDlhMzEtZGUwMS00N2JlLTkyYTctYmExYzcyMGM2MjcwXCJ9IiwieC1oYXN1cmEtdXNlci1lbWFpbCI6ImpvaG4uc21pdGhAY2hpbnRoYWd1bnRhLmNvbSIsIngtaGFzdXJhLXVzZXItaWQiOiI1NzJhZDFjMC1mOTdiLTRlMTYtYjFmNi04YjVjYTkwZjkzMWYiLCJ4LWhhc3VyYS11c2VyLWlzLWFub255bW91cyI6ImZhbHNlIn0sImlhdCI6MTczMzY5NTEyNCwiaXNzIjoiaGFzdXJhLWF1dGgiLCJzdWIiOiI1NzJhZDFjMC1mOTdiLTRlMTYtYjFmNi04YjVjYTkwZjkzMWYifQ.b-GORjchcVoj1M_FrBanEAKu6n4mSSjTLvAQwrXRLqk",
        "accessTokenExpiresIn": 900,
        "refreshToken": "29b90216-1cb9-49e9-9124-47348212e443",
        "refreshTokenId": "a905e591-e9bf-49ed-a05f-fab91728634c",
        "user": {
            "avatarUrl": "https://www.gravatar.com/avatar/1c874909e198bf87d38b50ef7e4d3163?d=mp&r=g",
            "createdAt": "2024-12-02T03:17:53.317046Z",
            "defaultRole": "org:owner",
            "displayName": "John Smith",
            "email": "john.smith@chinthagunta.com",
            "emailVerified": false,
            "id": "572ad1c0-f97b-4e16-b1f6-8b5ca90f931f",
            "isAnonymous": false,
            "locale": "en",
            "metadata": {},
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
  "exp": 1733696024,
  "https://hasura.io/jwt/claims": {
    "x-hasura-allowed-roles": [
      "user",
      "me",
      "org:owner"
    ],
    "x-hasura-default-role": "org:owner",
    "x-hasura-org-id": "8dfd9a31-de01-47be-92a7-ba1c720c6270",
    "x-hasura-org-ids": "{\"d5dbb6b6-5e43-4dca-b855-be9b65b6695b\",\"8dfd9a31-de01-47be-92a7-ba1c720c6270\"}",
    "x-hasura-user-email": "john.smith@chinthagunta.com",
    "x-hasura-user-id": "572ad1c0-f97b-4e16-b1f6-8b5ca90f931f",
    "x-hasura-user-is-anonymous": "false"
  },
  "iat": 1733695124,
  "iss": "hasura-auth",
  "sub": "572ad1c0-f97b-4e16-b1f6-8b5ca90f931f"
}
```

After switching `current_org`

```
HTTP/1.1 200 OK
Content-Length: 1370
Content-Type: application/json
Date: Sun, 08 Dec 2024 21:58:33 GMT

{
    "session": {
        "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3MzM2OTYwMTMsImh0dHBzOi8vaGFzdXJhLmlvL2p3dC9jbGFpbXMiOnsieC1oYXN1cmEtYWxsb3dlZC1yb2xlcyI6WyJ1c2VyIiwibWUiLCJvcmc6bWVtYmVyIl0sIngtaGFzdXJhLWRlZmF1bHQtcm9sZSI6Im9yZzptZW1iZXIiLCJ4LWhhc3VyYS1vcmctaWQiOiJkNWRiYjZiNi01ZTQzLTRkY2EtYjg1NS1iZTliNjViNjY5NWIiLCJ4LWhhc3VyYS1vcmctaWRzIjoie1wiOGRmZDlhMzEtZGUwMS00N2JlLTkyYTctYmExYzcyMGM2MjcwXCIsXCJkNWRiYjZiNi01ZTQzLTRkY2EtYjg1NS1iZTliNjViNjY5NWJcIn0iLCJ4LWhhc3VyYS11c2VyLWVtYWlsIjoiam9obi5zbWl0aEBjaGludGhhZ3VudGEuY29tIiwieC1oYXN1cmEtdXNlci1pZCI6IjU3MmFkMWMwLWY5N2ItNGUxNi1iMWY2LThiNWNhOTBmOTMxZiIsIngtaGFzdXJhLXVzZXItaXMtYW5vbnltb3VzIjoiZmFsc2UifSwiaWF0IjoxNzMzNjk1MTEzLCJpc3MiOiJoYXN1cmEtYXV0aCIsInN1YiI6IjU3MmFkMWMwLWY5N2ItNGUxNi1iMWY2LThiNWNhOTBmOTMxZiJ9.83vQQ3PKvhl7XJQndDI1-ZoiJbGPLEMx5oYUCcD9Hf8",
        "accessTokenExpiresIn": 900,
        "refreshToken": "5ede6c06-8281-45a0-9a31-4b58f5babf4e",
        "refreshTokenId": "df7a1bee-ddb0-4806-b77c-2a68aaedd4c4",
        "user": {
            "avatarUrl": "https://www.gravatar.com/avatar/1c874909e198bf87d38b50ef7e4d3163?d=mp&r=g",
            "createdAt": "2024-12-02T03:17:53.317046Z",
            "defaultRole": "org:member",
            "displayName": "John Smith",
            "email": "john.smith@chinthagunta.com",
            "emailVerified": false,
            "id": "572ad1c0-f97b-4e16-b1f6-8b5ca90f931f",
            "isAnonymous": false,
            "locale": "en",
            "metadata": {},
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
  "exp": 1733696013,
  "https://hasura.io/jwt/claims": {
    "x-hasura-allowed-roles": [
      "user",
      "me",
      "org:member"
    ],
    "x-hasura-default-role": "org:member",
    "x-hasura-org-id": "d5dbb6b6-5e43-4dca-b855-be9b65b6695b",
    "x-hasura-org-ids": "{\"8dfd9a31-de01-47be-92a7-ba1c720c6270\",\"d5dbb6b6-5e43-4dca-b855-be9b65b6695b\"}",
    "x-hasura-user-email": "john.smith@chinthagunta.com",
    "x-hasura-user-id": "572ad1c0-f97b-4e16-b1f6-8b5ca90f931f",
    "x-hasura-user-is-anonymous": "false"
  },
  "iat": 1733695113,
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
hasura seed create 001_roles --database-name default --from-table auth.roles --endpoint https://local.hasura.local.nhost.run --admin-secret hasura-admin-secret
hasura seed create 002_users --database-name default --from-table auth.users --endpoint https://local.hasura.local.nhost.run --admin-secret hasura-admin-secret
hasura seed create 003_user_roles --database-name default --from-table auth.user_roles --endpoint https://local.hasura.local.nhost.run --admin-secret hasura-admin-secret
hasura seed create 004_organizations --database-name default --from-table public.organizations --endpoint https://local.hasura.local.nhost.run --admin-secret hasura-admin-secret
hasura seed create 005_user_org_roles --database-name default --from-table public.user_org_roles --endpoint https://local.hasura.local.nhost.run --admin-secret hasura-admin-secret
hasura seed create 007_groups --database-name default --from-table public.groups --endpoint https://local.hasura.local.nhost.run --admin-secret hasura-admin-secret
hasura seed create 008_user_groups --database-name default --from-table public.user_groups --endpoint https://local.hasura.local.nhost.run --admin-secret hasura-admin-secret
```

## Schema

![diagram.png](diagram.png)

## Limitations
