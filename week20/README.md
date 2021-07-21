# Python program to count words and punctuation using VS code 

## Steps Involved:
1. Initially using vscode, "mapper.py" is created. In this file code is written to extract words and punctuations from the text file named cat.txt. Necessary nltk modules were imported.

2. In reducer file, the code is writtent to count the similar words that mapper has broken.

3. Along with these 2 files the cat.txt has to be in the same folder.

4. From the command prompt, cat command is used to call the cat.txt file to the mapper and reducer as shown:
   cat ./cat.txt | ./mapper.py|sort|./reducer.py
