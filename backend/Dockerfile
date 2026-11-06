FROM node:22-slim AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:22-slim
WORKDIR /app
ENV NODE_ENV=production
COPY package*.json ./
RUN npm ci --omit=dev
COPY --from=build /app/dist ./dist
COPY drizzle ./drizzle
EXPOSE 3000
# міграції при старті, потім сервер
CMD ["sh", "-c", "node dist/db/migrate.js && node dist/server.js"]
