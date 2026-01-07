# Stage 1: build stage
FROM node:lts-alpine as builder

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install

COPY . .

RUN echo $NEXT_PUBLIC_ANALYTICS_ID   # <-- ini gak bakal muncul nilainya saat build image

RUN npm run build

# Stage 2: production stage
FROM node:lts-alpine

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install --production

COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public

EXPOSE 3000

CMD ["npm", "start"]