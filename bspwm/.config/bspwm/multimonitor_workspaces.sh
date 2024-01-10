#!/bin/bash

monitor_count=$(bspc query -M | wc -l)
if [[ $monitor_count == 1 ]]; then
  bspc monitor -d I II III IV V VI VII VIII IX X
elif [[ $monitor_count == 2 ]]; then
  bspc monitor "$(bspc query -M | awk NR==1)" -d I II III IV V
  bspc monitor "$(bspc query -M | awk NR==2)" -d VI VII VIII IX X
elif [[ $monitor_count == 3 ]]; then
  bspc monitor "$(bspc query -M | awk NR==1)" -d I II III IV
  bspc monitor "$(bspc query -M | awk NR==2)" -d V VI VII
  bspc monitor "$(bspc query -M | awk NR==3)"-d VIII IX X
elif [[ $monitor_count == 4 ]]; then
  bspc monitor "$(bspc query -M | awk NR==1)" -d I II III
  bspc monitor "$(bspc query -M | awk NR==2)" -d IV V VI
  bspc monitor "$(bspc query -M | awk NR==3)" -d VII VIII
  bspc monitor "$(bspc query -M | awk NR==4)" -d IX X
elif [[ $monitor_count == 5 ]]; then
  bspc monitor "$(bspc query -M | awk NR==1)" -d I II
  bspc monitor "$(bspc query -M | awk NR==2)" -d III IV
  bspc monitor "$(bspc query -M | awk NR==3)" -d V VI
  bspc monitor "$(bspc query -M | awk NR==4)" -d VII VIII
  bspc monitor "$(bspc query -M | awk NR==5)" -d IX X
else
  monitor_index=1
  for monitor in $(bspc query -M); do
    bspc monitor "$monitor" \
      -n "$monitor_index" \
      -d $monitor_index/{a,b,c}
    ((monitor_index = monitor_index + 1))
  done
fi
