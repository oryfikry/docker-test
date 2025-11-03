FROM docker.io/oven/bun:latest

WORKDIR /app

COPY package.json ./
RUN bun install

COPY index.js ./

EXPOSE 3002
CMD ["bun", "index.js"]
