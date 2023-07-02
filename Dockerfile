FROM nginx:stable-alpine3.17-slim

COPY ./public /usr/share/nginx/html

COPY default.conf /etc/nginx/conf.d/default.conf