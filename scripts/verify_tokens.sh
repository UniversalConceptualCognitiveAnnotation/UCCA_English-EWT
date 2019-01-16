#!/usr/bin/env bash

rm -f ucca_tokens.txt ud_tokens.txt
total=$(ls xml | wc -l)
i=1
for xml in xml/*.xml; do
    printf "\r$xml ($i/$total)"
    i=$((i+1))
    TOK_XML="$(grep -Po '(?<=text=")[^"]+' ${xml} | recode xml..unicode | tr -d '\0')"
    id="${xml#*/}"
    id="${id%.*}"
    txt="ud/${id%.*}.txt"
    TOK_UD="$(grep -o '\S\+' ${txt})"
    if [[ "${TOK_XML}" != "${TOK_UD}" ]]; then
        printf "\r$xml $txt\n"
        echo "${TOK_XML}"
        echo "${TOK_UD}"
    fi
    echo "${id} ${TOK_XML}" | tr "\n" " " >> ucca_tokens.txt
    echo >> ucca_tokens.txt
    echo "${id} ${TOK_UD}" | tr "\n" " " >> ud_tokens.txt
    echo >> ud_tokens.txt
done
printf "\r                              \n"
