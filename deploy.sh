#!/bin/bash

find . -type f -name '*.scss'  -exec cat {} + >> styles.scss
bundle exec sass styles.scss > public/css/styles.css
