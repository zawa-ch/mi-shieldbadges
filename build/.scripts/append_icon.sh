#! /bin/bash

[ $# -ge 2 ] || {
	printf "\e[31m\e[7m*** Assersion failure ***\e[27m\e[0m\nToo few arguments.\n" >&2
	exit 1
}
readonly icon_file="$1"
readonly fg_color="$2"

#shellcheck disable=SC2016
icon=$(xq --arg fill "$fg_color" '.svg|=({"@id":"l","@fill":$fill}+.|del(."@xmlns"))' "$icon_file") || exit; readonly icon
#shellcheck disable=SC2016
xq -xc --slurpfile icon_svg <(cat <<<"$icon") '.svg|=(to_entries|.[(map(.key)|index("linearGradient"))]={key:"defs",value:($icon_svg.[0]+{linearGradient:.[(map(.key)|index("linearGradient"))]})}|from_entries)|.svg.g[1]|=(to_entries|(.[0]={key:"use",value:{"@href":"#l","@x":"5","@y":"3","@width":"14","@height":"14"}})|from_entries|del(.image))|.svg."@height"|=(tonumber|.+8|tostring)|.svg.g|=map(."@transform"|=.+"translate(0,4)")'
