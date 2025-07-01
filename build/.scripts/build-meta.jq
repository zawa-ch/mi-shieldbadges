.category as $category |
.license as $license |
{
	metaVersion: 2,
	emojis: (.emojis | map({
		fileName: "\(.name).png",
		downloaded: true,
		emoji: {
			host: null,
			name: (.name),
			category: $category,
			type: "image/png",
			aliases: (.aliases // []),
			license: $license,
			localOnly: (.localOnly // false),
			isSensitive: (.isSensitive // false)
		}
	}))
}