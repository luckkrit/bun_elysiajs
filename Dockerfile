# --- STAGE 1: Install dependencies ---
FROM oven/bun:1 AS base
WORKDIR /app

# Install dependencies into a temp directory to cache them
COPY package.json bun.lock ./
RUN bun install --frozen-lockfile

# --- STAGE 2: Run the app ---
FROM oven/bun:1-slim AS release
WORKDIR /app

# Copy node_modules from base stage
COPY --from=base /app/node_modules ./node_modules
COPY . .

# Set environment to production
ENV NODE_ENV=production

# Elysia default port is 3000
EXPOSE 3000

# Run the app
ENTRYPOINT [ "bun", "run", "src/index.ts" ]