# typhoonx-gtm

## 1.0.1

### Patch Changes

- 253cb2b: Fix the template failing to import into Google Tag Manager with "extraneous input '='". The sandboxed code used compound assignments (`+=`, `-=`), which GTM's parser does not accept.

## 1.0.0

### Major Changes

- Initial release.
