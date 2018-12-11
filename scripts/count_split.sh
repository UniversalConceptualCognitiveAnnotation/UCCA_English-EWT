grep sent_id ud.conllu | awk '{print $5}' | grep -f- -c UD_English-EWT/en_ewt-ud-*.conllu
