#!/bin/bash

spinner () {
    spin='-\|/'

    i=0
    while kill -0 $1 2>/dev/null
    do
    i=$(( (i+1) %4 ))
    printf "\r[${spin:$i:1}] $2"
    sleep .1
    done

}

echo "-=-=- Virtual Env Creator -=-=-"

#################### Required package
# virtualenv jupyter ipykernel

for val in numpy ; do
 	if pip show $val > /dev/null ; then
        echo [✔︎] $val found.
    else
        exit 1
    fi
done


#################### Retrieve python version 

python_version=($(ls /usr/local/bin | grep "^python[0-9.]*$" | xargs -I % sh -c "echo /usr/local/bin/%")) 
python_version+=($(ls /usr/bin | grep "^python[0-9.]*$" | xargs -I % sh -c "echo /usr/bin/%")) 

echo "Available python version "


for i in "${!python_version[@]}"; do
    printf "%s) %s\n" "$((i+1))" "${python_version[$i]}"
done


echo -en "\e[1A"; echo -en "\e[0K\rSelect python version from the above list: "
IFS= read -r opt

while ! [[ $opt =~ ^[0-9]+$ ]] || ! (( (opt > 0) && (opt <= "${#python_version[@]}") )); do
    echo -en "\e[10A"; echo -ne "\e[0K\rSelect python version from the above list: "
    IFS= read -r opt
done

read -p "Name your virtual environment: " venvname

#################### Creating venv
#echo -ne "[✺] Creating virtual environment"
virtualenv -p ${python_version[$((opt - 1))]} $venvname > /dev/null &
pid=$! # Process Id of the previous running command

spinner $pid "Creating virtual environment"

printf "\e[2K \r"
echo "[✔︎] Virtual environment created"

#################### Installing venv as jupyter kernel
source $venvname/bin/activate
pip install ipykernel > /dev/null &
pid=$! # Process Id of the previous running command

spinner $pid "Installing ipykernel"

if pip show ipykernel > /dev/null ; then
    printf "\e[2K \r"
    echo "[✔︎] ipykernel installed on virtual environment."
else
    exit 1
fi

read -p "Name virtual environment kernel's name (default value=${venvname}): " kernelname

if [ -z "$kernelname" ]; then
    kernelname="$venvname"
fi
   
out=`ipython kernel install --user --name=$kernelname`

#################### Check if kernel.json is valid

regex="Installed kernelspec .* in (.*)"

if [[ $out =~ $regex ]]
then
    kernelFile="${BASH_REMATCH[1]}/kernel.json"    
    python_suffix=${python_version[$((opt - 1))]} | grep "^python[0-9.]*$"
    python_truth="  \"`pwd`/$venvname/bin/$python_suffix\","
    line=`grep -nr "\"argv\": \[" $kernelFile | cut -d ":" -f2`
    python_kernel=`sed "$((line+1))!d" $kernelFile`

    if [ "$python_kernel" != "$python_truth" ]; then
        sed "s#$python_kernel#$python_truth#" "$kernelFile" > "$kernelFile.tmp"
        mv "$kernelFile.tmp" "$kernelFile"
    fi
else
    echo "[✘] Couldn't validate kernel file"
    exit 1
fi
    echo "[✔︎] Validated kernel file"

echo "[✔︎] Installation done"