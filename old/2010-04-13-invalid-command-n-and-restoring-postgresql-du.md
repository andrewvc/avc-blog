# Invalid Command \N and restoring PostgreSQL dumps

During a recent DB restore from Heroku onto my local machine I got a ton of
"Invalid Command \N" errors after doing a psql DBNAME -f DUMP.sql .

It took a lot of googling but I finally found [the
answer](http://openacs.org/forums/message-view?message_id=148479).

You've got to drop and recreate the database like so:

`dropdb DBNAME && createdb -T template0 DBNAME`

Then you can continue on your way, everything should work fine.

