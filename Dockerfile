FROM nginx:alpine-slim

WORKDIR /app

RUN apk upgrade --no-cache \
    && rm -rf /usr/share/nginx/html/* 

COPY /app /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]