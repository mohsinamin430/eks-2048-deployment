FROM nginx:alpine3.24-slim@sha256:80149a0e5bc9fa0b8beaff5b8a453f71ba8ba038895d418381297ffa5cd57782
WORKDIR /app
COPY . /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
