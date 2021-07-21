# Python program to count words and punctuation using VS code 

## Steps Involved:
1. Initially using vscode, "mapper.py" is created. In this file code is written to extract words and punctuations from the text file named cat.txt. Necessary nltk modules were imported.

2. In reducer file, the code is written to count the similar words that mapper has broken.

3. Along with these 2 files the cat.txt has to be in the same folder.
<img width="589" alt="Screen Shot 2021-07-21 at 4 41 42 PM" src="https://user-images.githubusercontent.com/79874273/126563990-d3a17f6b-2e10-4c9c-a331-f71ec2213ac9.png">


4. From the command prompt, cat command is used to call the cat.txt file to the mapper and reducer as shown:
   cat ./cat.txt | ./mapper.py|sort|./reducer.py

