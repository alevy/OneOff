#!/bin/bash

export GEM_HOME="/home/alevy/.gem"

export AWS_PUBLIC_KEY="1ZH236FRB9FYKCRGR9G2"
export AWS_SECRET_KEY="+SQVH40dL6UEgZ5pllfZY/zLKyKl5CI4KyokNUYJ"
date | cat >> /home/alevy/clippers.mail
cat - | ruby /home/alevy/oneoff/mail.rb >> /home/alevy/oneoff/oneoff.out 2>> /home/alevy/oneoff/oneoff.err
