ARG BUN_VERSION=1.2.18
FROM oven/bun:$BUN_VERSION

WORKDIR /app

COPY package.json bun.lock ./

RUN bun install --frozen-lockfile