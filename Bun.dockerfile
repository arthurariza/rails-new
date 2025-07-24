# syntax=docker/dockerfile:1

ARG BUN_VERSION=1.2.18
FROM oven/bun:$BUN_VERSION

WORKDIR /app

COPY package.json bun.lock* ./

RUN --mount=type=cache,target=/root/.bun/install/cache \
    bun install --frozen-lockfile