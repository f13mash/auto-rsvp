#!/bin/bash
api_key=$1
group=$2
res=$(curl -s "http://api.meetup.com/2/events?key=$api_key&group_urlname=$group&sign=true" | jq '.results[] | .id')
res=${res//\"/}
echo $res
events=($res)
store=~/.meetuprsvp
touch $store
rsvped=$(cat $store)
for ev in "${events[@]}"
do
	if [[ "$ev" != "*$rsvped*" ]]
	then
		echo "rsvping yes to event $ev"
		res=$(curl -s "https://api.meetup.com/2/rsvp/" -F "event_id=$ev" -F 'rsvp=yes' -F "key=$api_key" > /dev/null)
		rsvped="$rsvped $ev"
	fi	
done
echo "$rsvped">$store
