.name as $target |
[
	"# ShieldBadges makefile\n# !!!!! WARNING: DO NOT EDIT !!!!!\n# generated content, modification will overwrited\n",
	"\($target).svg="+(.emojis|map("\($target).svg/\(.name).svg")|join(" ")),
	"\($target).png="+(.emojis|map("\($target).png/\(.name).png")|join(" ")),
	"",
	"\($target).png/%.png: \($target).svg/%.svg .\($target).pre\n\tresvg -z 4 --dpi 384 \"$<\" \"$@\"\n\toptipng -q --fix \"$@\"",
	"",
	(.emojis|map(
		{name: .name}+.shield | [
			{o: true, v: "\($target).svg/\(.name).svg: ../\($target).json .\($target).pre\n\tgenerator/cshields-generator"},
			{o: (.style != null), v: "--style \"\(.style)\""},
			{o: (.color != null), v: "--color \"\(.color)\""},
			{o: (.labelColor != null), v: "--label-color \"\(.labelColor)\""},
			{o: true, v: "--"},
			{o: (.label != null), v: "\"\(.label)\""},
			{o: true, v: "\"\(.message)\" | xq -xcf .scripts/formatting-for-emoji.jq > \($target).svg/\(.name).svg\n"}
		] | map(select(.o) | .v) | join(" ")
	) | join("\n"))
] |
join("\n")
