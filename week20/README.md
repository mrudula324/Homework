# Python program to count words and punctuation using VS code 

## Steps Involved:
1. Initially using vscode, "mapper.py" is created. In this file code is written to extract words and punctuations from the text file named cat.txt. Necessary nltk modules were imported. Here in mapper the values are mapped to zero or more output values.

2. In reducer file, the code is written to reduce the intermediate values (values from the mapper). Values from the reducer are not sorted.

3. Along with these 2 files the cat.txt has to be in the same folder.
<img width="589" alt="Screen Shot 2021-07-21 at 4 41 42 PM" src="https://user-images.githubusercontent.com/79874273/126563990-d3a17f6b-2e10-4c9c-a331-f71ec2213ac9.png">

4. From the command prompt, cat command is used to call the cat.txt file to the mapper and reducer as shown:
   Command need to be run from the respective folder using prompt.
   
![Screen Shot 2021-07-21 at 4 44 50 PM](https://user-images.githubusercontent.com/79874273/126564527-bfbc22f2-cf96-4774-b452-1bc3aa2423a5.png)

## Importance of mapreduce in NLTK:
In real time, while analyzing NLTK the data to be analyzed is huge say multi-terra bytes of data. Mapreduce is used to anayze such data as mapreduce uses parallel processing on thousands of nodes. As processing data is memory intense and resource intense it is very advisable to use mapreduce in nltk. Along with this mapreduce takes care of scheduling, monitering and rerunning the failed jobs.
