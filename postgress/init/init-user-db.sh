#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER key_user;
    CREATE DATABASE key_db;
    GRANT ALL PRIVILEGES ON DATABASE key_db TO key_user;
    ALTER USER key_user PASSWORD 'key_password';
EOSQL