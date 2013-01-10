/* Create _version table to support migrations */

create table _version (
    id serial,
    version varchar(64),
    datetime timestamp
);

/* Create a schema for tables that are specific for LMV Bright. */

create schema lmv_bright;
