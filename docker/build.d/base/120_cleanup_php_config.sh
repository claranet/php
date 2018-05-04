#!/bin/bash

# remove php-fpm configs as they are adding a "www" pool, which does not exist
rm /usr/local/etc/php-fpm.d/*
rm -rf /etc/php
