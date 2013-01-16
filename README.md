Osmify
======

OSMify is built for two purposes:

* Import [Lantmäteriets GSD data](http://www.lantmateriet.se/Kartor-och-geografisk-information/Kartor/Sverigekartor/GSD-Sverigekartor-vektor/) from Shape files to PostGis
* Package (parts of) the data in a form that more resembles OpenStreetMap's structure, particularily to be able to use MapBox's [OSM Bright](https://github.com/mapbox/osm-bright) styling with as few modifications as possible.

Requirements
------------

Software:
* PostgreSQL (tested with 9.1)
* PostGIS (tested with 1.5)
* Python 2.7
* [Godwit](https://github.com/perliedman/godwit)

Data:
* Lantmäteriets GSD Data in ESRI Shapefile format

Usage
-----

First step is to import the Shapefile data to PostgreSQL/PostGIS. OSMify needs
to be configured by providing a ```config.py``` file:

```Python
db = {
    'host': 'localhost',
    'name': 'lmv-test',
    'user': 'postgres',
    'password': 'supersecret'
}

# None means no log, otherwise name of log (mostly shp2pgsql's output)
log_file = None

# Path to shp2pgsql
shp2pgsql = 'C:/Program Files/PostgreSQL/bin/shp2pgsql.exe'

gsd = {
    # Path to GSD's Shapefiles root
    'path': 'D:/Documents/lmv-gsd',
    # The SRID of the delivered data
    'srid': 3006
}
```
