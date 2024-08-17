This app was created inside a docker container that was started with
```
docker run -it -v /Users/me/development:/development -w /development ruby:latest bash
```

## Restoring from sqlite files
- Make sure you have the .sqlite3, sqlite3-wal, and sqlite3-shm files.
- Run `rails db:create db:migrate`
- Copy over all three files, replacing the files that rails created.
#### If you need to change environments you will have to export and import the db
Importing data from prod to development:
- `sqlite3 storage/development.sqlite3`
- `.output storage/dev.sql`
- `.dump`
- `.exit`
- `rails db:drop db:create db:migrate`
- `sqlite3 storage/development.sqlite3`
- `.read storage/dev.sql`
- There will probably be some migration, ar_internal_metadata, and index errors. You can get rid of the migration and ar_internal_metadata errors by running these commands before:
  - `delete from ar_internal_metadata;`
  - `delete from schema_migrations;`
#### Database Backups
The database is backed up nightly via a cron job that rsyncs the deploy home directory to the `/mnt/database_backup` volume. That volume is then backed up by the cloud provider. You can check the cron logs by running `sudo grep CRON /var/sys/log`. I installed Postfix to handle messages.
#### Kamal Deploys
- You will need the kamal alias. You can find this alias in the docs if you don't have it.
- You will need to copy the .env.tmpl and fill it in if you are on a new machine.
- `Kamal setup` if you are doing it for the first time on a server or `kamal deploy` if you are not.
- Currently we only deploy to dev via kamal
