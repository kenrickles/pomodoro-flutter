#!/bin/bash
set -e

# Download Flutter
git clone https://github.com/flutter/flutter.git --depth 1 -b stable $HOME/flutter
export PATH="$PATH:$HOME/flutter/bin"

# Install dependencies
flutter pub get

# Enable web
flutter config --enable-web

# Build web app
flutter build web --release

# Navigate to the build output directory
cd build/web

# Create a Netlify _redirects file for proper routing
echo "/* /index.html 200" > _redirects