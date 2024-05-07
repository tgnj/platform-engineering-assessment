# Changeslog

## FIXED

- ADDED: Makefile to quickly setup local development environment

- FIX: permission issue with rails:rails resolved.

- ADDED: docker compose can now stand up kafka db web and consumer. Shouldn't kafka work with zookeeper?

- ADDED: add Github Actions workflow

- ADDED: are able to access postgresql using psql -h 0.0.0.0 -p 5432 -U rails
  Can switch to the rails db using /c procare_production

- ADDED: dockerfile

- ADDED: add simulate:attendance to test attendance_producer. Probably need to use topic instead of payload#event.

- FIX: fix attendance_consumer test. Caveat: doesn't actually consume the messages. Limitation to testing.

- FIX: rename the attendance_consumer.rb to attendance_consumer_spec.rb. Reimplement the attendance_consumer.

- ADDED: index for attendance entity_identifier, site_identifier, sign_in_time, sign_out_time.

- FIX: performance on /visitors
  Added will_paginate to page the output instead of displaying everything (to scale). Limitation, will_paginate
  currently (or since ever) support cursor.

- FIX: /visitors/<id>
  Set a limit to the recent visits to 50.

## KNOWN ISSUES

- For local development, need to switch from kafka:9092 to localhost:9092.

- We don't really need to include the visitors because all is referenced by visitor_id anyway.

## PENDING ISSUES

- TODO: was going to cache Visit#recent but it is pointless atm.
