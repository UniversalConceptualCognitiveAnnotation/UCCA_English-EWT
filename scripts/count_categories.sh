#!/bin/bash

grep --exclude-dir=.git -Phro '(?<=type=").(?=")' $* | sort | tee >(wc -l) | uniq -c | awk '/[A-Za-z]/;END{print $2}'
