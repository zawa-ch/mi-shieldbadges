#! /bin/bash

__main() {
local -r SIMPLE_ICONS_DATA_BRANCH='heads/master'
local -r SIMPLE_ICONS_DATA_URI="https://github.com/simple-icons/simple-icons/raw/refs/${SIMPLE_ICONS_DATA_BRANCH}/_data/simple-icons.json"
local -r SHIELDS_STATIC_ENDPOINT='https://img.shields.io/badge'
local sd;	sd=$(cd "$(dirname "$0")" && pwd) || return;	local -r sd
curl --version >/dev/null || return
jq --version >/dev/null || return
xq --version >/dev/null || return
resvg --version >/dev/null || return
# shellcheck source=lib.sh
. "$sd/lib.sh" || return
mkdir -p "$sd/build" && cd "$sd/build" || return
mkdir -p "brands" && cd "brands" || return
local si_data;	si_data=$(curl -sL "${SIMPLE_ICONS_DATA_URI}" | jq -c '.') || return
local health='true'
while read -rd $'\0' i; do
	! [ -f "$(jq -r '.slug' <<<"$i").png" ] || continue;
	echo "make_brand_badges: making $(echo "$i" | jq -r '.slug') ..." >&2
	local d;	d=$(curl -sfG "$(jq -r '.url' <<<"$i")") || { health='false'; continue; }
	local l;	l=$(xq -r '.svg.g[1].image.["@xlink:href"]|if type=="string" then . else "make_brand_badges: Logo image not found\n"|halt_error(1) end|ltrimstr("data:image/svg+xml;base64,")' <<<"$d") || { echo "make_brand_badges: Ignore this build and proceed to the next." >&2; continue; }
	local l;	l=$(base64 -d <<<"$l" | xq '.svg|=({"@id":"l"}+.|del(."@xmlns"))') || { health='false'; continue; }
	# shellcheck disable=SC2016
	d=$(xq -xc --slurpfile icon_svg <(cat <<<"$l") '.svg|=(to_entries|.[(map(.key)|index("linearGradient"))]={key:"defs",value:($icon_svg.[0]+{linearGradient:.[(map(.key)|index("linearGradient"))]})}|from_entries)|.svg.g[1]|=(to_entries|(.[0]={key:"use",value:{"@href":"#l","@x":"5","@y":"3","@width":"14","@height":"14"}})|from_entries|del(.image))|.svg."@height"|=(tonumber|.+8|tostring)|.svg.g|=map(."@transform"|=.+"translate(0,4)")' <<<"$d") || { health='false'; continue; }
	local meta;	meta=$(jq -c '{fileName:"\(.slug).png",downloaded:true,emoji:{host:null,name:.slug,category:"Shields/brands",type:"image/png",aliases:([.title]+.aliases?.aka//[]+[.aliases.loc[]]|map(sub(" ";"_";"g"))),license:"https://github.com/simple-icons/simple-icons/blob/master/LICENSE.md",localOnly:false,isSensitive:false}}' <<<"$i") || { health='false'; continue; }
	rasterize "$(echo "$i" | jq -r '.slug').png" <<<"$d" || { health='false'; continue; }
	update_meta <<<"$meta" || { health='false'; continue; }
done < <(echo "$si_data" | jq --raw-output0 --arg shields "${SHIELDS_STATIC_ENDPOINT}" 'def title_to_slug: {"+":"plus",".":"dot","&":"and","đ":"d","ħ":"h","ı":"i","ĸ":"k","ŀ":"l","ł":"l","ß":"ss","ŧ":"t"} as $replacements|ascii_downcase|sub("(?<c>[\($replacements|keys|join(""))])";$replacements.[.c];"g")|sub("[^a-z\\d]";"";"g"); def badge_content: sub("(?<c>[_ -])";.c as $c|{"_":"__"," ":"_","-":"--"}|.[$c];"g")|@uri; def hex_tonumber: {"0":0,"1":1,"2":2,"3":3,"4":4,"5":5,"6":6,"7":7,"8":8,"9":9,"a":10,"b":11,"c":12,"d":13,"e":14,"f":15} as $num_map|sub("[^a-fA-F\\d]";"";"g")|split("")|reduce .[] as $c (0;.*16+($num_map.[($c|ascii_downcase)])); def hex_to_rgb: if test("^[a-fA-F\\d]{6}$") then capture("(?<r>[a-fA-F\\d]{2})(?<g>[a-fA-F\\d]{2})(?<b>[a-fA-F\\d]{2})")|map_values(hex_tonumber) else error("Input is not a hex color code") end; def rgb_illuminance: 0.2989*.r+0.5866*.g+0.1144*.b; def detect_fg: if .>=175.95 then "black" else "white" end; .icons | .[] | ({slug:(.title|title_to_slug),name:.slug,url:"\($shields)/\(.title|badge_content)-\(.hex)?logo=\(.title|title_to_slug)&style=flat&logoColor=\(.hex|hex_to_rgb|rgb_illuminance|detect_fg)"}+.) | tojson')
[ "$health" == 'true' ] || return
zip "../brands.zip" -- *
}
(__main)
