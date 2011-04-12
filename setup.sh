#!/bin/bash

sqlite3 `dirname $0`/addresses.db < `dirname $0`/setup.sql

