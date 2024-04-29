# Changeslog

## FIXED

- FIX: rename the attendance_consumer.rb to attendance_consumer_spec.rb. Reimplement the attendance_consumer.

- ADDED: index for attendance entity_identifier, site_identifier, sign_in_time, sign_out_time.

- FIX: performance on /visitors
  Added will_paginate to page the output instead of displaying everything (to scale). Limitation, will_paginate
  currently (or since ever) support cursor.

- FIX: /visitors/<id>
  Set a limit to the recent visits to 50.

## PENDING ISSUES

- Rails cache doesn't work in development (whether turned on by dev:cache or not). Was going to cache the Visit#recent

## TODO

- Dockerfile
- CI/CD using Github Actions
- Terraform
