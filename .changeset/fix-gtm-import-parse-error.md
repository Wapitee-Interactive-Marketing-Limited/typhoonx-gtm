---
'typhoonx-gtm': patch
---

Fix the template failing to import into Google Tag Manager with "extraneous input '='". The sandboxed code used compound assignments (`+=`, `-=`), which GTM's parser does not accept.
