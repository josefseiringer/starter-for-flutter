FROM dart:stable AS build

# Set working directory
WORKDIR /app

# Copy dependency files
COPY pubspec.* ./
RUN dart pub get

# Copy source code
COPY . .

# Compile to native executable
RUN dart compile exe bin/server.dart -o server

# Build minimal runtime image
FROM debian:stable-slim

# Install CA certificates for HTTPS
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

# Copy compiled app and .env
WORKDIR /app
COPY --from=build /app/server .
COPY --from=build /app/.env .

# Expose port
EXPOSE 8080

# Set environment
ENV PORT=8080
ENV HOST=0.0.0.0

# Run server
CMD ["./server"]
