#!/bin/bash

RED='\033[0;31m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
ORANGE='\033[0;33m' 
PUR='\033[0;35m'
GRN="\e[32m"
WHI="\e[37m"
NC='\033[0m'
echo ""
cat <<EOF

------------------------------------------------------
[IDSYSTEM404] APPLE VALID EMAIL [UPDATE 08 APRIL 2018]
------------------------------------------------------

EOF

usage() { 
  echo "Usage: ./myscript.sh COMMANDS: [-i <list.txt>] [-r <folder/>] [-l {1-1000}] [-t {1-10}] OPTIONS: [-d] [-c]

Command:
-i (20k-US.txt)     File input that contain email to check
-r (result/)        Folder to store the result live.txt and die.txt
-l (60|90|110)      How many list you want to send per delayTime
-t (3|5|8)          Sleep for -t when check is reach -l fold

Options:
-d                  Delete the list from input file per check
-c                  Compress result to compressed/ folder and
                    move result folder to haschecked/
-h                  Show this manual to screen
-u                  Check integrity file then update
"
  exit 1 
}

# Assign the arguments for each
# parameter to global variable
while getopts ":i:r:l:t:dchu" o; do
    case "${o}" in
        i)
            inputFile=${OPTARG}
            ;;
        r)
            targetFolder=${OPTARG}
            ;;
        l)
            sendList=${OPTARG}
            ;;
        t)
            perSec=${OPTARG}
            ;;
        d)
            isDel='y'
            ;;
        c)
            isCompress='y'
            ;;
        h)
            usage
            ;;
        u)
            updater "manual"
            ;;
    esac
done

if [[ $inputFile == '' || $targetFolder == '' || $sendList == '' || $perSec == '' ]]; then
  cli_mode="interactive"
else
  cli_mode="interpreter"
fi

# Assign false value boolean
# to both options when its null
if [ -z "${isDel}" ]; then
  isDel='n'
fi

if [ -z "${isCompress}" ]; then
  isCompress='n'
fi

SECONDS=0

# Asking user whenever the
# parameter is blank or null
if [[ $inputFile == '' ]]; then
  # Print available file on
  # current folder
  # clear
  read -p "Masukkan File Maillist: " inputFile
fi

if [[ $targetFolder == '' ]]; then
  read -p "Masukkan Folder Penyimpanan: " targetFolder
  # Check if result folder exists
  # then create if it didn't
  if [[ ! -d "$targetFolder" ]]; then
    echo "[+] Pembuatan Folder Penyimpanan $targetFolder/"
    mkdir $targetFolder
  else
    read -p "$targetFolder/ folder sudah ada!, menduplikasi ? [y/n]: " isAppend
    if [[ $isAppend == 'n' ]]; then
      exit
    fi
  fi
else
  if [[ ! -d "$targetFolder" ]]; then
    echo "[+] Pembuatan Folder Penyimpanan $targetFolder/"
    mkdir $targetFolder
  fi
fi

if [[ $isDel == '' || $cli_mode == 'interactive' ]]; then
  read -p "Hapus list setelah di cek ? [y/n]: " isDel
fi

if [[ $isCompress == '' || $cli_mode == 'interactive' ]]; then
  read -p "Compress hasil ? [y/n]: " isCompress
fi

if [[ $sendList == '' ]]; then
  read -p "Mau berapa scan email perdetik: " sendList
fi

if [[ $perSec == '' ]]; then
  read -p "Delay: " perSec
fi

idsystem404() {
  SECONDS=0

  check=`curl 'https://appleid.apple.com/account/validation/appleid' -H 'scnt: '$scnt'' -H 'Origin: https://appleid.apple.com' -H 'Accept-Encoding: gzip, deflate, br' -H 'X-Apple-I-FD-Client-Info: {"U":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84 Safari/537.36","L":"en-US","Z":"GMT+08:00","V":"1.1","F":"sWa44j1e3NlY5BSo9z4ofjb75PaK4Vpjt3Q9cUVlOrXTAxw63UYOKES5jfzmkflJfmczl998tp7ppfAaZ6m1CdC5MQjGejuTDRNziCvTDfWk3qwyWEQEe6qgXK_Pmtd0SHp815LyjaY2.rINj.rINYOK0UjVsYUMnGWFfwMHDCQyG5me6sBLSsbXzU0l6sqKIrGfuzwg9wK9weEwHXXTSHCSPmtd0wVYPIG_qvoPfybYb5EvYTrYesR0CjEcIqnuWxf7_OLgiPFMtrs1OeyjaY2_GGEQIgwe98vDdYejftckuyPBDjaY2ftckZZLQ084akJlJWu_uWA16fUfR0odm_dhrxbuJjkWxv5iJ6KVg8cGYiKY.6elV2pN9csgdmX3ivm_Ud_UeAwHCSFQ_0pNvS_MNJZNlY5DuV25BNnOVgw24uy.CfT"}' -H 'Accept-Language: en-US,en;q=0.9,id;q=0.8,fr;q=0.7,la;q=0.6' -H 'X-Requested-With: XMLHttpRequest' -H 'Cookie: idclient=web; dslang=US-EN; site=USA; aidsp='$sessionId'; ccl=OXqm9r6b+jMZIrOKHBgGZQ==; geo=ID' -H 'Connection: keep-alive' -H 'X-Apple-Api-Key: '$apiKey'' -H 'X-Apple-ID-Session-Id: '$sessionId'' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84 Safari/537.36' -H 'Content-Type: application/json' -H 'Accept: application/json, text/javascript, */*; q=0.01' -H 'Referer: https://appleid.apple.com/account' -H 'X-Apple-Request-Context: create' --data-binary '{"emailAddress":"'$1'"}' --compressed -D - -s`
  duration=$SECONDS
  header="`date +%H:%M:%S`"
  footer="[IDSYSTEM404 APPLE VALID EMAIL] $(($duration % 60))sec.\n"
  val="$(echo "$check" | grep -c 'used" : true')"
  inv="$(echo "$check" | grep -c 'used" : false')"
  bad="$(echo "$check" | grep -c 'valid" : false')"
  icl="$(echo "$check" | grep -c 'appleOwnedDomain" : true')"

  if [[ $val > 0 || $icl > 0 ]]; then
    printf "[$header] $2/$3. ${GRN}LIVE => $1 ${NC} $footer"
    echo "LIVE => $1" >> $4/live.txt
  else
    if [[ $inv > 0 || $bad > 0 ]]; then
      printf "[$header] $2/$3. ${RED}DIE => $1 ${NC} $footer"
      echo "DIE => $1" >> $4/die.txt
    else
      printf "[$header] $2/$3. ${CYAN}UNKNOWN => $1 ${NC} $footer"
      echo "$1 => $check" >> reason.txt
      echo "TIDAK DIKETAHUI => $1" >> $inputFile
    fi
  fi

  printf "\r"
}

if [[ ! -f $inputFile ]]; then
  echo "[404] File Maillist Tidak Ditemukan!"
  ls -l
  exit
fi

# Preparing file list 
# by using email pattern 
# every line in $inputFile
echo "[+] Scan Maillist"
grep -Eiorh '([[:alnum:]_.-]+@[[:alnum:]_.-]+?\.[[:alpha:].]{2,6})' $inputFile | tr '[:upper:]' '[:lower:]' | sort | uniq > temp_list && mv temp_list $inputFile

# Finding match mail provider
echo "########################################"
# Print total line of mailist
totalLines=`grep -c "@" $inputFile`
echo "Total ada $totalLines Email di list kamu."
echo " "
echo "Hotmail: `grep -c "@hotmail" $inputFile`"
echo "Yahoo: `grep -c "@yahoo" $inputFile`"
echo "Gmail: `grep -c "@gmail" $inputFile`"
echo "########################################"

# Extract email per line
# from both input file
IFS=$'\r\n' GLOBIGNORE='*' command eval  'mailist=($(cat $inputFile))'
con=1

getKey() {
  echo "Mengambil Token baru. Tunggu..."
  wait
  resp=`curl 'https://appleid.apple.com/account' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8' -H 'Connection: keep-alive' -H 'Accept-Encoding: gzip, deflate, br' -H 'Accept-Language: en-US,en;q=0.9,id;q=0.8,fr;q=0.7,la;q=0.6' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84 Safari/537.36' --compressed -D - -s -o /dev/null`
  scnt="$(echo "$resp" | grep "scnt: " | cut -c7- | xargs)"
  sessionId="$(echo "$resp" | grep "aidsp" | awk -F[=\;] '{print $2}' | xargs)"
  apiKey='cbf64fd6843ee630b463f358ea0b707b'

  # echo "$resp"
  # echo "SCNT: $scnt"
  # echo "SESSIONID: $sessionId"

  if [[ $scnt == '' || $sessionId == '' || $apiKey = '' ]]; then
    sleep 4
    echo "IP Kamu di Blokir oleh Apple."
    getKey
    sleep 2
  fi
}

getKey

echo "[+] Mengirim $sendList Email per $perSec detik"

for (( i = 0; i < "${#mailist[@]}"; i++ )); do
  username="${mailist[$i]}"
  indexer=$((con++))
  tot=$((totalLines--))
  fold=`expr $i % $sendList`
  if [[ $fold == 0 && $i > 0 ]]; then
    header="`date +%H:%M:%S`"
    duration=$SECONDS
    echo "[$header] Menunggu $perSec detik. $(($duration / 3600)) jam $(($duration / 60 % 60)) menit and $(($duration % 60)) detik terlampaui, dengan $sendList requests / $perSec detik."
    sleep $perSec
  fi
  vander=`expr $i % 8`
  if [[ $vander == 0 && $i > 0 ]]; then
    getKey
  fi
  
  idsystem404 "$username" "$indexer" "$tot" "$targetFolder" "$inputFile" &

  if [[ $isDel == 'y' ]]; then
    grep -v -- "$username" $inputFile > "$inputFile"_temp && mv "$inputFile"_temp $inputFile
  fi
done 

# waiting the background process to be done
# then checking list from garbage collector
# located on $targetFolder/unknown.txt
echo "[+] Menunggu sampai selesai.."
wait
wc -l $targetFolder/*

if [[ $isCompress == 'y' ]]; then
  tgl=`date`
  tgl=${tgl// /-}
  zipped="$targetFolder-$tgl.zip"

  echo "[+] Compress Hasil"
  zip -r "compressed/$zipped" "$targetFolder/die.txt" "$targetFolder/live.txt"
  echo "[+] Menyimpan ke compressed/$zipped"
  mv $targetFolder haschecked
  echo "[+] $targetFolder sudah di pindahkan ke folder haschecked"
fi
#rm $inputFile
duration=$SECONDS
echo "$(($duration / 3600)) jam $(($duration / 60)) menit dan $(($duration % 60)) detik terlampaui."
echo "+==========+ IDSYSTEM404 APPLE VALID EMAIL +==========+"