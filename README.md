ITIS taxonomy lookup
====================

![build-sqlite](https://github.com/sckott/itis-lookup/workflows/build-sqlite/badge.svg)

ITIS taxonomy lookup

## how we do

* download ITIS taxonomy from <https://itis.gov/downloads/itisSqlite.zip>
* unzip
* create csv table `itis_lookup.csv`

All above is run once per day on [Github Actions](https://github.com/sckott/itis-lookup/actions?query=workflow%3Abuild)

## Usage

download

```
git clone https://github.com/sckott/itis-lookup.git
cd itis-lookup
```

bundle it

```
bundle install
```

```
rake --tasks
```

```
rake all         # get itis database, create csv file
rake fetch       # get and unzip backbone
rake make_table  # make csv file
```

`rake all` does all the things

Or, you can do each separately with `rake fetch` then `rake make_table`

## ITIS tsn/rank lookup file

<https://sckott.github.io/itis-lookup/itis.txt>

## info

* ITIS taxonomy citation:

> FILL ME INa asdfads

* ITIS taxonomy license: ???
