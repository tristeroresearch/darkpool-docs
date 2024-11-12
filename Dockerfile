# Stage 1: Build the MkDocs site
FROM python:3.9-slim AS builder

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . /app
RUN mkdocs build

# Stage 2: Serve with Nginx
FROM nginx:alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/site /usr/share/nginx/html

ENV PORT=8080
EXPOSE $PORT

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
