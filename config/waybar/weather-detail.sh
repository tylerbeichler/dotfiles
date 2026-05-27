#!/bin/bash

# Get coordinates from IP geolocation
geo=$(curl -fsS --max-time 3 "https://ipinfo.io" 2>/dev/null) || exit 1
coords=$(echo "$geo" | jq -r '.loc')
lat=$(echo "$coords" | cut -d',' -f1)
lon=$(echo "$coords" | cut -d',' -f2)

# Open-Meteo — accurate hyperlocal data, no API key required
data=$(curl -fsS --max-time 5 \
  "https://api.open-meteo.com/v1/forecast?latitude=${lat}&longitude=${lon}&current=temperature_2m,relative_humidity_2m,precipitation,weather_code&temperature_unit=fahrenheit&precipitation_unit=mm" \
  2>/dev/null) || exit 1

temp=$(echo "$data" | jq -r '.current.temperature_2m | round')
humidity=$(echo "$data" | jq -r '.current.relative_humidity_2m')
precip=$(echo "$data" | jq -r '.current.precipitation')
wcode=$(echo "$data" | jq -r '.current.weather_code')

[[ -z "$temp" || "$temp" == "null" ]] && exit 1

# WMO weather code to description
case $wcode in
  0)     desc="Clear sky" ;;
  1)     desc="Mostly clear" ;;
  2)     desc="Partly cloudy" ;;
  3)     desc="Overcast" ;;
  45|48) desc="Foggy" ;;
  51)    desc="Light drizzle" ;;
  53)    desc="Drizzle" ;;
  55)    desc="Heavy drizzle" ;;
  56|57) desc="Freezing drizzle" ;;
  61)    desc="Light rain" ;;
  63)    desc="Rain" ;;
  65)    desc="Heavy rain" ;;
  66|67) desc="Freezing rain" ;;
  71)    desc="Light snow" ;;
  73)    desc="Snow" ;;
  75)    desc="Heavy snow" ;;
  77)    desc="Snow grains" ;;
  80)    desc="Light showers" ;;
  81)    desc="Showers" ;;
  82)    desc="Heavy showers" ;;
  85|86) desc="Snow showers" ;;
  95)    desc="Thunderstorm" ;;
  96|99) desc="Hail storm" ;;
  *)     desc="Unknown" ;;
esac

COLOR_GOOD="#00dce8"
COLOR_MEDIUM="#c050a0"
COLOR_HIGH="#d05060"

# Humidity color
h=$humidity
if (( h < 60 )); then hcolor=$COLOR_GOOD
elif (( h < 80 )); then hcolor=$COLOR_MEDIUM
else hcolor=$COLOR_HIGH
fi

# Precipitation severity from code
case $wcode in
  55|65|66|67|75|82|95|96|99) pcolor=$COLOR_HIGH ;;
  51|53|56|57|61|63|71|73|77|80|81|85|86) pcolor=$COLOR_MEDIUM ;;
  *) pcolor=$COLOR_GOOD ;;
esac

# Format
precip_mm=$(echo "$precip" | awk '{printf ($1 == int($1)) ? "%dmm" : "%.1fmm", $1}')
precip_in=$(echo "$precip" | awk '{printf "%.2f\"", $1 / 25.4}')
if [[ $pcolor != $COLOR_GOOD ]]; then
  precip_text="${desc} (${precip_mm} / ${precip_in})"
else
  precip_text="$desc"
fi

echo "{\"text\":\"${temp}° · <span foreground='${hcolor}'>${humidity}% humidity</span> · <span foreground='${pcolor}'>${precip_text}</span>\"}"
