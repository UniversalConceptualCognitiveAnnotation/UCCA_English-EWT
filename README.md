UCCA English Web Treebank Corpus
================================
Version 1.0 (March 22, 2019)
-----------------------------

This bundle contains 723 passages from the reviews section of the English Web Treebank (LDC2012T13),
annotated according to the foundational layer of UCCA, v2.0. 
The passages are given as xmls in the [UCCA format](https://github.com/UniversalConceptualCognitiveAnnotation/docs/blob/master/FORMAT.md).
This corpus contains 55590 tokens over 3813 sentences, as tokenized and split according
to the [Universal Dependencies English Web Treebank](http://github.com/UniversalDependencies/UD_English-EWT).


Files included
--------------
1. The passages files in XML format. file names are of the form `XXX.xml` where XXX 
   is the passage ID. Please see [the UCCA resource webpage](http://www.cs.huji.ac.il/~oabend/ucca.html)
   for a software package for reading and using these files.
3. [`scripts/get_ud.sh`](scripts/get_ud.sh): script to download all UD-annotated sentences corresponding
   to the UCCA passages in this corpus, and split the UCCA passages according to the UD sentences.
   The split UD files are saved in `ud`, and the split UCCA files in `sentences_by_ud`.
