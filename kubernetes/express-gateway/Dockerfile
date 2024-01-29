FROM node:lts-alpine3.19

RUN apk update && apk add bash

RUN npm install -g express-gateway

RUN eg gateway create -n my-gateway -d ./my-gateway -t basic

RUN eg plugins install -g express-gateway-plugin-rewrite

WORKDIR /my-gateway/

COPY ./config/ ./config/

ENTRYPOINT npm run start

EXPOSE 8080