#!/bin/bash 

set -e

old_IFS=$IFS
IFS=$'\n'

input=$1
output=$2

#lines=($(cat sample.out)) 
lines=($(cat $input)) 
header="FunctionRate_HistTime_HistCountSamplesMinMaxAvgVarianceLeaf?"
#header="timesecondssecondscallss/calls/callname"
# header="timesecondssecondscallsms/callms/callname"
data_done="--------Histograms------------"

l=$(echo ${lines[0]}  | tr -d ' '); 
counter=0 
while [ "$l" != "$header" ] 
do 
  counter=$((counter + 1));
  l=$(echo ${lines[$counter]}  | tr -d ' '); 
  #echo $l;
  printf ".";
done 
printf "\n";

echo "Found headers on line" 
echo $counter 


for data in "${lines[@]:$counter}";
do 
    curr_ns=$(echo $data | tr -d ' ');
    if [ "$curr_ns" = "$data_done" ]; 
    then 
	printf "\n";
	echo "found end of dynaprof data" ;
	break;
    fi
    

    # squeeze whitespaces 
    trimmed=$(echo $data | sed -e 's/^ *//' -e 's/ *$//');
    squeezed=$(echo $trimmed | tr -s ' ');

    # parse the data 
    # 10 fields separated by whitespace. 
    echo $(echo $squeezed | tr ' ' ',') >> $output; 
    #echo $(echo $tmp | cut -d',' -f1,2,3,4,5,6,7) >> $output;
    
    printf "*" 
  
   
 
   


done

printf "\n";
echo "DONE!";


IFS=$old_IFS
