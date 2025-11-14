# Stage 1: Build Flutter Web App
FROM ghcr.io/cirruslabs/flutter:stable AS build

# Set working directory
WORKDIR /app

# Copy pubspec files
COPY pubspec.yaml pubspec.lock ./

# Get dependencies
RUN flutter pub get

# Copy the rest of the application
COPY . .

# Create .env file for build (will be replaced at runtime if needed)
RUN echo "APPWRITE_PUBLIC_ENDPOINT=https://cloud.appwrite.io/v1" > .env && \
    echo "APPWRITE_PROJECT_ID=placeholder" >> .env && \
    echo "APPWRITE_PROJECT_NAME=placeholder" >> .env && \
    echo "APPWRITE_DATABASE_ID=placeholder" >> .env && \
    echo "APPWRITE_USERS_COLLECTION_ID=placeholder" >> .env && \
    echo "PTV_API_KEY=placeholder" >> .env && \
    echo "PTV_PROXY_BASE=https://www.ta.joshihomeserver.ip64.net" >> .env

# Build web app for production (ohne --web-renderer, wurde in Flutter 3.22+ entfernt)
RUN flutter build web --release

# Stage 2: Serve with Nginx
FROM nginx:alpine

# Install wget for healthcheck
RUN apk add --no-cache wget

# Copy built web app from build stage
COPY --from=build /app/build/web /usr/share/nginx/html

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
