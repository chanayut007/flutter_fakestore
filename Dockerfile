# Use the official Dart image for Flutter web builds
FROM dart:stable AS build

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git /flutter
ENV PATH="/flutter/bin:/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Enable web support
RUN flutter channel stable && flutter config --enable-web

# Copy project files
WORKDIR /app
COPY . .

# Get dependencies and clean previous builds
RUN flutter pub get
RUN flutter clean

# Build the web release
RUN flutter build web --release

# Use a lightweight web server to serve the build (e.g., nginx)
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose port 80
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]


