#!/bin/bash
# Created by ZyCromerZ
sudo apt-get install -y curl git

git config user.name NEETroid
git config user.email 7darkza9@gmail.com

git add . && git commit -sm 'update for next notif' && git push -f --all

SendInfo(){
    if [[ "$2" == "gugel" ]];then
        link="https://android.googlesource.com/kernel/common"
    else
        link="https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git"
    fi
    curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
    -d chat_id="@ZyCromerZ" \
    -d "disable_web_page_preview=true" \
    -d "parse_mode=html" \
    -d text="Kernel Tags <a href='$link'>${1}</a> Released"
}
Total="0"
while [[ "$Total" != "48" ]];do
    if [[ -z "${BOT_TOKEN}" ]];then
        echo "bot token null"
        exit
    else
        wget https://android.googlesource.com/kernel/common/+/refs/heads/android-4.14-stable/Makefile -O A.txt
        wget https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain/Makefile?h=linux-4.14.y -O B.txt

        CheckA="$(cat A.txt | grep '<span class="lit">' | awk -F '<span class="lit">' '{print $4}' | awk -F '</span>' '{print $1}')"
        if [[ "$CheckA" != "$(cat 4.14-common)" ]] && [[ ! -z "$(echo $CheckA | grep "^-\?[0-9]+$")" ]] ;then
            SendInfo "4.14.$CheckA" "gugel"
            echo $CheckA > 4.14-common
            git add . && git commit -sm "update for next notif when tags $(($CheckA+1)) released from https://android.googlesource.com/kernel/common "
        fi

        CheckB="$(cat B.txt | grep "SUBLEVEL = " | awk -F " = " '{print $2}')"
        if [[ "$CheckB" != "$(cat 4.14)" ]] && [[ ! -z "$(echo $CheckB | grep "^-\?[0-9]+$")" ]] ;then
            SendInfo "4.14.$CheckB" "std"
            echo $CheckB > 4.14
            git add . && git commit -sm "update for next notif when tags $(($CheckB+1)) released from https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git "
        fi
        rm -rf *.txt
    fi
    sleep 60s
    Total=$(($Total+1))
    git push -f --all
done