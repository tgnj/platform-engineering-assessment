# Changeslog

## FIXED

- FIX: performance on /visitors
  Added will_paginate to page the output instead of displaying everything (to scale). Limitation, will_paginate
  currently (or since ever) support cursor.

- FIX: /visitors/<id>
  Set a limit to the recent visits to 50.

## TODO

- Dockerfile
- CI/CD using Github Actions
- Terraform
