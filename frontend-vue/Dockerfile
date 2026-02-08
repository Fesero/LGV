FROM node:20-alpine

LABEL maintainer="cultivation-game"
LABEL service="frontend"

RUN apk add --no-cache git curl

WORKDIR /app

RUN chown -R node:node /app

USER node

COPY --chown=node:node package*.json ./

RUN npm install

COPY --chown=node:node . .

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
    CMD wget -q --spider http://localhost:3000 || exit 1

CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0"]
