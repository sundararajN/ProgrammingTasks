#!/usr/bin/python
import re  ##importing packages
import sys
from operator import itemgetter
from itertools import islice
from collections import OrderedDict

#reading the contents of the file and opening another file for writing the output file

seq_list = list () #creating empty lists to store the list output
sorted_seq_dict = dict()
search_obj = re.compile(r'[A|T|G|C]+') #creating a regex pattern expression complie object to extract sequences
out_file = open('retrieved sample.fasta','w+') #opening a file for writing the output 

with open('sample.fasta','r') as seq_obj: #opening the file for reading its contents and storing it in an object
    for line in seq_obj:   #looping through each line in the file and when the line matches the pattern, it is extracted and stored in a list
        if search_obj.search(line):
            seq_list.append(line)

seq_obj.close() #file closing

# SeqDuplicatesWithCount function takes in a list of sequences and outputs the repeated sequences in the list with their frequency

def SeqDuplicatesWithCount(seq_l): #defining a function for computing freq
     
      seq_dict = dict() #using dictionary to store the sequences and their counts
      seq_dict_mod = dict()
      #looping through the list of sequences, and for each unique sequence, the count is set to 1 whereas if more
      #than one sequence is present,the looping is incremented the time it occurs in the sequences
      for key in seq_l: 
        if key in seq_dict.keys():
            seq_dict[key] += 1
        else:
            seq_dict[key] = 1 
            
        seq_dict_mod = { key : value for key, value in seq_dict.items() if value > 1} #filter the key value pairs in dictionary.Keeping pairs with value more than 1
                    
      return seq_dict_mod

seq_dict = SeqDuplicatesWithCount(seq_list); #calling the function passing the sequence list
sorted_seq_dict = sorted(seq_dict.items(),key = lambda x:x[1],reverse=True) #sorting the dictionary according to the values in descending order to determine the frequenct ones
n_sorted_items = sorted_seq_dict[0:10] #retrieving the first 10 sorted dictionary items

for seq, count in n_sorted_items:  ##extracting the sequence and count of each sequence and writting it into an output file
    
    out_file.write("%s\t%d\n" %(seq,count))
        
out_file.close() 

