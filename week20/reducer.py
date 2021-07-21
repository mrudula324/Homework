#!/usr/bin/env python
#shebang line ^

import sys
from collections import Counter

tot_list=[]
word = None

#lines getting passed in from the mapper
for line in sys.stdin:
    line = line.strip()

    word, count = line.split("\t",1)

    tot_list.append(word.lower())

count = Counter(tot_list)
print (count)
    
