FROM node:current-alpine3.11 AS build

COPY package*.json ./
RUN npm install



FROM node:current-alpine3.11 AS test

WORKDIR app
# Copy artifacts, sources and tests
COPY src /app
COPY --from=build package*.json /app/
COPY --from=build node_modules /app/node_modules
RUN npm test



FROM alpine:3.12.0 AS release

# Install nodejs and tini
# Create app group/user and folder to host the app
RUN set -xe; \
    apk add --update nodejs && \ 
    apk add --no-cache tini && \
    addgroup -S app && \
    adduser -S -G app app && \
    mkdir app && \
    chown app:app app

WORKDIR app

# Copy artifacts and sources
COPY src /app
COPY --from=build package*.json /app/
COPY --from=build node_modules /app/node_modules

EXPOSE 3000
USER app

# Runtime 
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["node", "server/server.js"]
