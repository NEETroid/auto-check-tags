#!/bin/bash
# Created by ZyCromerZ
sudo apt-get install -y curl git

ForA="$(cat 4.4-common)"
ForB="$(cat 4.14-common)"
ForC="$(cat 4.4)"
ForD="$(cat 4.14)"

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
    -d chat_id="@NeutrinoCh" \
    -d "disable_web_page_preview=true" \
    -d "parse_mode=html" \
    -d text="Kernel Tags ${1} Available on $link"
}
Total="0"
while [[ "$Total" != "58" ]];do
    if [[ -z "${BOT_TOKEN}" ]];then
        echo "bot token null"
        exit
    else
        wget https://android.googlesource.com/kernel/common/+/refs/heads/android-4.4-p/Makefile -O A.txt
        wget https://android.googlesource.com/kernel/common/+/refs/heads/android-4.14-stable/Makefile -O B.txt
        wget https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain/Makefile?h=linux-4.4.y -O C.txt
        wget https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain/Makefile?h=linux-4.14.y -O D.txt

        if [[ ! -z "$(cat A.txt | grep '<span class="lit">'$ForA'</span>')" ]];then
            SendInfo "4.4.${ForA}" "gugel"
            ForA=$(($ForA+1))
            echo $ForA > 4.4-common
        fi

        if [[ ! -z "$(cat B.txt | grep '<span class="lit">'$ForB'</span>')" ]];then
            SendInfo "4.14.${ForB}" "gugel"
            ForB=$(($ForB+1))
            echo $ForB > 4.14-common
        fi
        if [[ ! -z "$(cat C.txt | grep "SUBLEVEL = $ForC")" ]];then
            SendInfo "4.4.${ForC}" "std"
            ForC=$(($ForC+1))
            echo $ForC > 4.4
        fi

        if [[ ! -z "$(cat D.txt | grep "SUBLEVEL = $ForD")" ]];then
            SendInfo "4.14.${ForD}" "std"
            ForD=$(($ForD+1))
            echo $ForD > 4.14
        fi
        rm -rf A.txt B.txt C.txt D.txt
    fi
    sleep 60s
    Total=$(($Total+1))
    git add . && git commit -sm 'update for next notif'
    git push -f --all
done