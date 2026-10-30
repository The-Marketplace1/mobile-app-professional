# syntax=docker/dockerfile:1.7
FROM ghcr.io/cirruslabs/flutter:3.32.0 AS build

WORKDIR /workspace
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get
COPY . .

ARG API_GATEWAY_URL=""
ARG REALTIME_SERVICE_URL=""
ARG MAPBOX_PUBLIC_TOKEN=""
RUN --mount=type=secret,id=android_key_properties,target=/workspace/android/key.properties,required=true \
    --mount=type=secret,id=android_keystore,target=/workspace/android/upload-keystore.jks,required=true \
    flutter build apk --release \
    --dart-define="API_GATEWAY_URL=${API_GATEWAY_URL}" \
    --dart-define="REALTIME_SERVICE_URL=${REALTIME_SERVICE_URL}" \
    --dart-define="MAPBOX_PUBLIC_TOKEN=${MAPBOX_PUBLIC_TOKEN}"

FROM scratch
COPY --from=build /workspace/build/app/outputs/flutter-apk/app-release.apk /ProfessionalApp.apk

