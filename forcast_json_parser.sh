#!/bin/bash

#get the webpage
curl -k https://weather.com/weather/hourbyhour/l/ISXX0026:1:IS -o out.html

#parse out table columns data of interest (time, desc, temp, feel, percip, humidity and wind)
grep -oP 'headers="time".*?</span>' out.html | grep -oP '(?<=<span class="dsx-date">).*?(?=</span>)' > time.txt
grep -oP 'headers="description".*?</span>' out.html | grep -oP '(?<=<span>).*?(?=</span>)' > description.txt
grep -oP 'headers="temp".*?</span>' out.html | grep -oP '\d+' > temp.txt
grep -oP 'headers="feels".*?</span>' out.html | grep -oP '\d+' > feels.txt
grep -oP 'headers="precip".*?</div>' out.html| grep -oP '(?<=<span>)\d+' > percip.txt #in percentage
grep -oP 'headers="humidity".*?</div>' out.html | grep -oP '(?<=<span>)\d+' > humidity.txt
grep -oP 'headers="wind".*?mph' out.html | cut -d'>' -f3 > wind.txt

#assertions/tests can be made to make sure exactly the same ammount of records were parsed for each data.

#create the json by joining the columns in a json format in a simple loop.
echo '{' > forcast_data.json
COUNTER=`cat time.txt | wc -l`
for i in $(seq 1 $COUNTER)
do
	time=`sed -n "${i}p" time.txt`
	desc=`sed -n "${i}p" description.txt`
	temp=`sed -n "${i}p" temp.txt`
	feels=`sed -n "${i}p" feels.txt`
	percip=`sed -n "${i}p" percip.txt`
	humidity=`sed -n "${i}p" humidity.txt`
	wind=`sed -n "${i}p" wind.txt`
	
	echo -e "\t\"$time\":{" >> forcast_data.json
	echo -e "\t\t\"DESC\": \"$desc\"," >> forcast_data.json
	echo -e "\t\t\"TEMP\": \"$temp\"," >> forcast_data.json
	echo -e "\t\t\"FEEL\": \"$feels\"," >> forcast_data.json
	echo -e "\t\t\"PERCIP\": \"$percip%\"," >> forcast_data.json
	echo -e "\t\t\"HUMIDITY\": \"$humidity%\"," >> forcast_data.json
	echo -e "\t\t\"WIND\": \"$wind\"" >> forcast_data.json
	echo -e "\t}" >> forcast_data.json
done
echo '}' >> forcast_data.json

#I have actually done this in a more "elegant" way by joining the files using the paste command, but opted not to use it because it is less readable. see following commented code:
#sed -i 's/\(.*\)/"\1":{/g' time.txt
#sed -i 's/\(.*\)/"DESC":"\1",/g' description.txt
#sed -i 's/\(.*\)/"TEMP":"\1",/g' temp.txt
#sed -i 's/\(.*\)/"FEEL":"\1",/g' feels.txt
#sed -i 's/\(.*\)/"PERCIP":"\1%",/g' percip.txt
#sed -i 's/\(.*\)/"HUMIDITY":"\1%",/g' humidity.txt
#sed -i 's/\(.*\)/"WIND":"\1" }/g' wind.txt
#
#echo '{' > forcast_data.json
#paste -d' ' time.txt description.txt temp.txt feels.txt percip.txt humidity.txt wind.txt >> forcast_data.json
#echo '}' >> forcast_data.json


#cleanup:
rm -f out.html time.txt description.txt temp.txt feels.txt percip.txt humidity.txt wind.txt
