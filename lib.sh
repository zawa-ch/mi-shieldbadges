#! /bin/bash

rasterize() {
	local output;	output=$(readlink -m "$1") || return
	resvg -z 4.0 --dpi 384 --resources-dir / - "$output"
}

update_meta() {
	[ -f "meta.json" ] || jq -nc '{"metaVersion":2,emojis:[]}' >"meta.json" || return
	local emoji;	emoji=$(jq -Rc --slurp 'fromjson') || return
	local meta;	meta=$(jq -Rc --slurp 'fromjson' "meta.json") || return
	meta=$(jq -c --argjson emoji "$emoji" '.emojis|=map(select(.fileName!=$emoji.fileName))+[$emoji]' <<< "$meta") || return
	jq '.' <<<"$meta" >"meta.json"
}
