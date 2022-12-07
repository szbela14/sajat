#!/bin/bash

#a program minden reszeben hasznalatos valtozok
szja=18
szja_folott=36

munkavallaloi=15
magannyugdij=8
penzbeli=2
egeszsegb=4
nyugdijjarulek=15

#nettobol brutto ber szamolasa -n kapcsolo segítségével
while getopts "hn:" OPTION
do
        case $OPTION in
                n)
                    netto_n=$OPTARG
                    #eves brutto ber kiszamitasa
                    brutto_n=$[(netto_n/1000)*1500]
                    brutto_n=$[brutto_n*12]
                    echo "Az evi brutto kereset kb. $brutto_n HUF"
                    
                    #az eves brutto berre vonatkozo adok es jarulekok kiszamitasa
                    if [ $brutto_n -lt 1700000 ]
                    then
                        szja=$[brutto_n*szja/100]
                        echo "Az eves szja kb. $szja HUF"
                        munkavallaloi=$[brutto_n*munkavallaloi/1000]
                        echo "Az eves munkavallaloi jarulek kb. $munkavallaloi HUF"
                        magannyugdij=$[brutto_n*magannyugdij/100]
                        echo "Az eves magannyugdij penztar kb. $magannyugdij HUF"
                        penzbeli=$[brutto_n*penzbeli/100]
                        echo "Az eves penzbeli egeszsegbiztositasi jarulek kb. $penzbeli HUF"
                        egeszsegb=$[brutto_n*egeszsegb/100]
                        echo "Az eves egeszsegbiztositasi jarulek kb. $egeszsegb HUF"
                        nyugdijjarulek=$[brutto_n*nyugdijjarulek/1000]
                        echo "Az eves nyugdij jarulek kb. $nyugdijjarulek HUF"
                    elif [ $brutto_n -gt 1700000 ]
                    then
                        brutto_n_folott=$[brutto_n-1700000]
                        brutto_n_maradek=1700000
                            
                        szja=$[(brutto_n_maradek*szja/100)+brutto_n_folott*szja_folott/100]
                        echo "Az eves szja kb. $szja HUF"
                        munkavallaloi=$[brutto_n*munkavallaloi/1000]
                        echo "Az eves munkavallaloi jarulek kb. $munkavallaloi HUF"
                        magannyugdij=$[brutto_n*magannyugdij/100]
                        echo "Az eves magannyugdij penztar kb. $magannyugdij HUF"
                        penzbeli=$[brutto_n*penzbeli/100]
                        echo "Az eves penzbeli egeszsegbiztositasi jarulek kb. $penzbeli HUF"
                        egeszsegb=$[brutto_n*egeszsegb/100]
                        echo "Az eves egeszsegbiztositasi jarulek kb. $egeszsegb HUF"
                        nyugdijjarulek=$[brutto_n*nyugdijjarulek/1000]
                        echo "Az eves nyugdij jarulek kb. $nyugdijjarulek HUF"
                    fi
                    exit
                    ;;
                h)
                    echo "A program harom argumentumot kezel, sorrendben brutto havi kereset, egyeb brutto havi jovedelmek, osztondijak."
                    echo "A megadott informaciok segitsegevel kiszamolja az eves netto jovedelmet, es a hozzatartozo adok es jarulekok osszeget."
                    echo "A -n kapcsolo egy argumentumot kezel, ez a netto havi kereset."
                    echo "Ebbol kiszamitja az eves brutto jovedelmet, valamint a hozzatartozo adok es jarulekok osszeget."
                    echo "Nettobol bruttoba valo szamitaskor a program kis mertekben elterhet a valos adatoktol"
                    exit
                    ;;
        esac
done

#bruttobol netto ber kiszamitasa, ehhez tartozo valtozok
brutto=$1
egyeb=$2
osztondij=$3

eves_brutto=$[(brutto+egyeb)*12]
eves_osztondij=$[osztondij*12]

brutto_kedvezmenyes=0
eves_brutto_kedvezmenyes=0
eves_brutto_maradek=0
eves_brutto_folott=0

netto_eves=0

#eves netto ber/adok es jarulekok kiszamitasa keresettol fuggoen
if [ $eves_brutto -lt 1400000 ]
then
    echo "Adojovairas veheto igenybe 9000 HUF-ig. Adja meg az osszeget:"
    read adojov
    while [ $adojov -gt 9000 ] || [ $adojov -lt 0 ]
    do
        adojov=0
        echo "Az osszeg nem megfelelo"
        read adojov
    done
    brutto_kedvezmenyes=$[brutto-adojov]
    eves_brutto_kedvezmenyes=$[(brutto+egyeb)*12]
    szja=$[eves_brutto_kedvezmenyes*szja/100]
    munkavallaloi=$[eves_brutto_kedvezmenyes*munkavallaloi/1000]
    magannyugdij=$[eves_brutto_kedvezmenyes*magannyugdij/100]
    penzbeli=$[eves_brutto_kedvezmenyes*penzbeli/100]
    egeszsegb=$[eves_brutto_kedvezmenyes*egeszsegb/100]
    nyugdijjarulek=$[eves_brutto_kedvezmenyes*nyugdijjarulek/1000]
    
    netto_eves=$[(eves_brutto-(szja+munkavallaloi+magannyugdij+penzbeli+egeszsegb+nyugdijjarulek))+osztondij_eves]
    
    echo "Az evi netto kereset $netto_eves HUF"
    echo "Az eves szja $szja HUF"
    echo "Az eves munkavallaloi jarulek $munkavallaloi HUF"
    echo "Az eves magannyugdij penztar $magannyugdij HUF"
    echo "Az eves penzbeli egeszsegbiztositasi jarulek $penzbeli HUF"
    echo "Az eves egeszsegbiztositasi jarulek $egeszsegb HUF"
    echo "Az eves nyugdij jarulek $nyugdijjarulek HUF"
elif [ $eves_brutto -gt 1700000 ]
then
    eves_brutto_folott=$[eves_brutto-1700000]
    eves_brutto_maradek=1700000
    
    szja=$[(eves_brutto_maradek*szja/100)+eves_brutto_folott*szja_folott/100]
    munkavallaloi=$[eves_brutto*munkavallaloi/1000]
    magannyugdij=$[eves_brutto*magannyugdij/100]
    penzbeli=$[eves_brutto*penzbeli/100]
    egeszsegb=$[eves_brutto*egeszsegb/100]
    nyugdijjarulek=$[eves_brutto*nyugdijjarulek/1000]
    
    netto_eves=$[(eves_brutto-(szja+munkavallaloi+magannyugdij+penzbeli+egeszsegb+nyugdijjarulek))+osztondij_eves]
    
    echo "Az evi netto kereset $netto_eves HUF"
    echo "Az eves szja $szja HUF"
    echo "Az eves munkavallaloi jarulek $munkavallaloi HUF"
    echo "Az eves magannyugdij penztar $magannyugdij HUF"
    echo "Az eves penzbeli egeszsegbiztositasi jarulek $penzbeli HUF"
    echo "Az eves egeszsegbiztositasi jarulek $egeszsegb HUF"
    echo "Az eves nyugdij jarulek $nyugdijjarulek HUF"
elif [ $eves_brutto -gt 1400000 ] && [ $eves_brutto -lt 1700000 ]
then
    szja=$[eves_brutto*szja/100]
    munkavallaloi=$[eves_brutto*munkavallaloi/1000]
    magannyugdij=$[eves_brutto*magannyugdij/100]
    penzbeli=$[eves_brutto*penzbeli/100]
    egeszsegb=$[eves_brutto*egeszsegb/100]
    nyugdijjarulek=$[eves_brutto*nyugdijjarulek/1000]
    
    netto_eves=$[(eves_brutto-(szja+munkavallaloi+magannyugdij+penzbeli+egeszsegb+nyugdijjarulek))+osztondij_eves]
    
    echo "Az evi netto kereset $netto_eves HUF"
    echo "Az eves szja $szja HUF"
    echo "Az eves munkavallaloi jarulek $munkavallaloi HUF"
    echo "Az eves magannyugdij penztar $magannyugdij HUF"
    echo "Az eves penzbeli egeszsegbiztositasi jarulek $penzbeli HUF"
    echo "Az eves egeszsegbiztositasi jarulek $egeszsegb HUF"
    echo "Az eves nyugdij jarulek $nyugdijjarulek HUF"
fi