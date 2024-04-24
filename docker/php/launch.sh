#!/bin/sh

set -e

echo 'Install composer dependencies'
composer install

exec $@
