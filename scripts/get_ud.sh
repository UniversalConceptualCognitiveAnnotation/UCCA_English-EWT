#!/bin/bash

git clone -q https://github.com/UniversalDependencies/UD_English-EWT --branch=r2.5
pip install -U semstr udapi

# Extract all UD-annotated docs for which we also have UCCA annotations
sed 's/reviews-//' UD_English-EWT/*.conllu > ud.conllu
grep -Pho '(?<=passageID=")[^"]*(?=")' xml/* | xargs python -m semstr.scripts.split ud.conllu -o ud --doc-ids
cat ud/*.conllu > ud.conllu

# Write the tokenized text of each CoNLL-U sentence to a file
sed 's/SpaceAfter=No/_/;/^# text = /d' ud/*.conllu | udapy read.Conllu write.Conllu |
  while read line; do
    if [[ ${line} == "# sent_id = "* ]]; then
      sent_id="${line#*= }"
    elif [[ ${line} == "# text = "* ]]; then
      text="${line#*= }"
      echo "${text}" > "ud/${sent_id}.txt"
      sent_id=
    fi
  done || exit 1

# Split the UCCA passages to sentences exactly like the UD documents are split
total=$(ls xml | wc -l)
i=1
for xml in xml/*; do
  doc_id="${xml#*/}"
  doc_id="${doc_id%.xml}"
  cat "ud/${doc_id}-"*.txt > "ud/${doc_id}.txt"
  printf "\rSplitting $xml to sentences... ($i/$total)"
  i=$((i+1))
  python -m scripts.standard_to_sentences "${xml}" --sentences "ud/${doc_id}.txt" -o sentences_by_ud -b --suffix-format='-%04d' --suffix-start=1 2>/dev/null || exit 1
  python -m scripts.standard_to_text "sentences_by_ud/${doc_id}-"* -o txt 2>/dev/null || exit 1
  for sentence in "sentences_by_ud/${doc_id}-"*; do
    txt=${sentence#*/}
    if ! grep -qFxf- "ud/${doc_id}.txt" < "txt/${txt%.*}.txt"; then
      # Try another way
      found=
      while read line; do
        grep -qFx "$line" "txt/${txt%.*}.txt" && found=1
      done < "ud/${doc_id}.txt"
      if [ -z "$found" ]; then
        echo
        echo Could not match "txt/${txt%.*}.txt" to any line from "ud/${doc_id}.txt":
        head -n-0 "txt/${txt%.*}.txt" "ud/${doc_id}.txt"
        rm -fv "${sentence}"
      fi
    fi
  done
done
echo
echo Wrote sentences_by_ud

