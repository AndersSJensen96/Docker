FROM node:lts-alpine3.19

RUN apk update && apk add bash

RUN npm install -g express-gateway

RUN eg gateway create -n my-gateway -d ./my-gateway -t getting-started

WORKDIR /my-gateway/

ENTRYPOINT npm run start

EXPOSE 8080