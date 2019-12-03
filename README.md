# Nim API Skeleton

A project just for fun to meet a beautiful [Nim](https://nim-lang.org/) language and cute [Jester](https://github.com/dom96/jester) web framework.

## Requirements

- nim >= 1.0.0
- nimble
- [libjwt](https://github.com/benmcollins/libjwt)

### Prepare database

`sh ./bin/createdb`

The application uses a simple SQLite database

## Build & Run

`nimble run`

## Tests

To execute the unit tests:

`nimble test`

## Running task

Example for VSCode `.vscode/tasks.json`

```
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "build nad run project",
            "type": "shell",
            "command": "nimble",
            "args": ["run", "simpleapi"],
            "options": {
                "cwd": "${workspaceRoot}",
		"env": {
			"JWT_SECRET": "1234567890"
		}
            },
            "group": {
                "kind": "build",
                "isDefault": true
            }
        }
    ]
}

```

JWT_SECRET – authentication secret as ENV variable for application. Put here whatever you want.

## API usage

### Authenticate User

```http
POST /auth/@userId
```

Example

```http
POST /auth/8A660FC9-1359-4DC3-8312-0693542980D8
```

Response
```json
HTTP/1.1 200 OK
Content-Length: 219
Content-Type: application/json
Date: Tue, 03 Dec 2019 17:18:51 GMT
Server: HttpBeast

{
    "jwt": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOiIxNTc1Mzk3MTMyIiwiaXNzIjoiOEE2NjBGQzktMTM1OS00REMzLTgzMTItMDY5MzU0Mjk4MEQ4In0.UTxrDpgmkGBRycueCkobl6boFDRLOp4L6jAHnb97GmI",
    "message": "User has been authenticated."
}
```

### Get User info

```http
GET /user
```

Example

```http
GET /user "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOiIxNTc1Mzk3MTMyIiwiaXNzIjoiOEE2NjBGQzktMTM1OS00REMzLTgzMTItMDY5MzU0Mjk4MEQ4In0.UTxrDpgmkGBRycueCkobl6boFDRLOp4L6jAHnb97GmI"
```

Response

```json
HTTP/1.1 200 OK
Content-Length: 64
Content-Type: application/json
Date: Tue, 03 Dec 2019 17:20:46 GMT
Server: HttpBeast

{
    "name": "Test App",
    "uid": "8A660FC9-1359-4DC3-8312-0693542980D8"
}
```

Fail

```json
HTTP/1.1 401 Unauthorized
Content-Length: 63
Content-Type: application/json
Date: Tue, 03 Dec 2019 17:20:39 GMT
Server: HttpBeast

{
    "error": "user.unauthorized",
    "message": "Unauthorized request."
}
```

# License

 MIT