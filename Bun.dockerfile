ARG BUN_VERSION
FROM oven/bun:$BUN_VERSION

WORKDIR /app

COPY . .

RUN bun install