#!/bin/sh
echo "working with list and loops in bash"

# setting up an array
arr=('kurto', 'murto', 'stavre', 'navre')

# an attempt to print the array will not list all the items from the array
echo $arr

# listin the array items
echo ${arr[*]}

# accessing the array elements by zero-based index
echo ${arr[1]}

# string concatenation
echo "the item with index 1 is ${arr[1]}"

# for accessing the last element, it is not like in python for accessing the last element, this will fail
echo ${arr[-1]}

# in order to access the last element first the length of the array needs to be determined
arrayLength=${#arr[*]}
echo "the list has $arrayLength items" 

echo "the last item in the list is ${arr[$arrayLength-1]}"

for i in "${arr[@]}"
do
    echo -n "$i"
done

for itm in ${arr[*]}
do
    echo $itm
done