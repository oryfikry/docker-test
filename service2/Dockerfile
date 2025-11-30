FROM docker.io/oven/bun:latest

WORKDIR /app

# Install curl for healthchecks
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

COPY package.json ./
RUN bun install

COPY index.js ./

EXPOSE 3002
CMD ["bun", "index.js"]
