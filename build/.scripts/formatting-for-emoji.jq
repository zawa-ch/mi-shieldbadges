.svg."@height" |= (tonumber|.+8|tostring) |
.svg.g |= map(
	."@transform" |= .+"translate(0,4)"
)
