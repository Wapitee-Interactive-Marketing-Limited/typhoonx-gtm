# typhoonx-gtm

## 1.1.0

### Minor Changes

- b97f282: Make **GA4 Measurement ID** optional. Without it, events are sent without `ga_session_id`.

## 1.0.1

### Patch Changes

- 253cb2b: Fix the template failing to import into Google Tag Manager with "extraneous input '='". The sandboxed code used compound assignments (`+=`, `-=`), which GTM's parser does not accept.

## 1.0.0

### Major Changes

- Initial release.
