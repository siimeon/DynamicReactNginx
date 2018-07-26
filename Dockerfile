FROM node:8 as node
WORKDIR /usr/src/app
COPY package.json .
RUN  yarn install
COPY . .

FROM node:8 as builder
ENV NODE_ENV 'production'
WORKDIR /usr/src/app
COPY --from=node /usr/src/app/ .
RUN mkdir -p build
RUN yarn build

FROM nginx:stable-alpine as deployment
RUN apk add --update bash && rm -rf /var/cache/apk/*
# Entrypoint script
COPY ./nginx/entrypoint.sh /usr/local/bin/entrypoint
# Nginx config file template
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf
# React app code
COPY --from=builder /usr/src/app/build/ /usr/share/nginx/html/
# NGINX VARIABLES
ENV SERVER_NAME 'localhost'
ENV GZIP 'on'
# REACT APP VARIABLES
ENV API_ENDPOINT 'https://backend.example.com'

ENTRYPOINT [ "entrypoint" ]
CMD ["nginx", "-g", "daemon off;"]
