# Passport Inspector Platform

A microservices-based system for passport data verification, integrating with
a mocked external SMEV service.

This is an umbrella repository: it does not contain service source code.
Each service lives in its own repository and is cloned separately for local
setup (see below).

## Services

| Repository                                                                               | Container                      | Role                                        | Stack                   | Port        |
|------------------------------------------------------------------------------------------|--------------------------------|---------------------------------------------|-------------------------|-------------|
| [ms-passport-inspector-gateway](https://github.com/NAIIIK/ms-passport-inspector-gateway) | ms-passport-inspector-gateway  | BFF / single entry point                    | Spring Boot             | 8082        |
| [ms-passport-inspector](https://github.com/NAIIIK/ms-passport-inspector)                 | ms-passport-inspector          | Core business logic, file storage via MinIO | Spring Boot, PostgreSQL | 8080        |
| [smev-api-mock](https://github.com/NAIIIK/smev-api-mock)                                 | smev-api-mock                  | Mock of the external SMEV service (REST)    | Spring Boot             | 8081        |
| - (infra)                                                                                | passport-minio                 | Object storage for passport files           | MinIO                   | 9000 / 9001 |

## Architecture

// TODO

## Getting started

1. Copy `.env.example` to `.env` and fill in your own values:

```bash
   cp .env.example .env
```

2. Clone all service repositories next to this file:

```bash
   git clone https://github.com/NAIIIK/ms-passport-inspector.git
   git clone https://github.com/NAIIIK/ms-passport-inspector-gateway.git
   git clone https://github.com/NAIIIK/smev-api-mock.git
```

3. Start everything:

```bash
   docker compose up
```

4. The gateway will be available at `http://localhost:8082`.

## Architecture decisions

// TODO

## Notes

- `.env` is git-ignored; only `.env.example` with placeholder values is committed.
- Service folders (`ms-passport-inspector/`, etc.) are created locally by
  cloning and are not part of this repository - check `.gitignore`.
