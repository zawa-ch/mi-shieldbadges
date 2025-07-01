#! /bin/bash

preflight-check() {
	local -r PRE_REQUISITES=("curl" "jq" "xq" "resvg"); local -i result=0
	locate() { local o=""; o=$(which "$1") && printf "found %s: %s\n" "$1" "$o"; }
	for i in "${PRE_REQUISITES[@]}"; do locate "$i" || result=1; done
	return $result
}
preflight-check || {
	printf "\e[31m\e[7m*** Pre-flight checks failed ***\e[27m\e[0m\nThe required package is missing or unreachable from the PATH of this environment.\n" >&2
	return 1
}
touch .preflight-check
