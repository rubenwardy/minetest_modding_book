#!/bin/bash

jekyll build --config _config.yml,_conf_wc.yml
./utils/_count_words.js
