# Mobile architecture

## Runtime

- `lib/app/`: app lifecycle, Riverpod providers, and GoRouter navigation
- `lib/core/`: compile-time configuration, domain types, Dio networking,
  secure session storage, theme, and WebSocket client
- `lib/features/`: feature-scoped repositories and presentation
- `lib/shared/`: reusable UI elements
- `docs/api-gateway.openapi.yaml`: the only marketplace API contract

All cross-service reads and writes must pass through `ApiClient` to the API
Gateway. Feature repositories map app operations to contract paths. Do not add
database credentials, direct service URLs, Twilio SDKs, or business rules that
belong on the server.

## Session and realtime

Access and refresh tokens are stored with `flutter_secure_storage`. Requests
attach the access token as a bearer token. A restored token is checked through
`GET auth/me`. Realtime is a client-only WebSocket connection; configure it with
`REALTIME_SERVICE_URL` and authenticate/authorize according to the realtime
service contract.

## Location

The map is a display surface, not a location collector. The
`JobLocationPermission` domain rule requires both an active job and explicit
Gateway authorization. The current API contract has no authorization or
location-update route, so GPS capture and transmission are intentionally not
implemented.

## Current API limitations

The contract currently lacks registration/document-upload, call-initiation,
and job-location authorization/update operations. The UI must not simulate
success for these flows. Extend the contract and implement the server-side
Gateway/Communication behavior before enabling them.

