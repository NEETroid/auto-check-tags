#!/bin/bash
# Created by ZyCromerZ
sudo apt-get install -y curl git

ForA="$(cat 4.4)"
ForB="$(cat 4.14)"

SendInfo(){
    curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
    -d chat_id="-1001400256602" \
    -d "disable_web_page_preview=true" \
    -d "parse_mode=html" \
    -d text="Kernel Tags ${1} Ready on https://android.googlesource.com/kernel/common, when upstream?"
}
Total="0"
RunCheck()
{
    if [[ -z "${BOT_TOKEN}" ]];then
        echo "bot token null"
        exit 0
    else
        wget https://android.googlesource.com/kernel/common/+/refs/heads/android-4.4-p/Makefile -O A.txt
        wget https://android.googlesource.com/kernel/common/+/refs/heads/android-4.14-stable/Makefile -O B.txt

        if [[ ! -z "$(cat A.txt | grep '<span class="lit">'$ForA'</span>')" ]];then
            SendInfo "4.4.${ForA}"
            ForA=$(($ForA+1))
            echo $ForA > 4.4
        fi

        if [[ ! -z "$(cat B.txt | grep '<span class="lit">'$ForB'</span>')" ]];then
            SendInfo "4.14.${ForB}"
            ForB=$(($ForB+1))
            echo $ForB > 4.14
        fi
        rm -rf A.txt B.txt
    fi
    sleep 30s
    if [[ "$Total" == "28" ]];then
        exit
    fi
    Total=$(($Total+1))
    RunCheck
}
RunCheck

git config --global user.name NEETroid
git config --global user.email 7darkza9@gmail.com

git add . && git commit -sm 'update for next notif' && git push -f --all