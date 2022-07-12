eval "$(/opt/homebrew/bin/brew shellenv)"

for file in ~/.{aliases,functions,path,exports,extra}; do
	if [[ -r "$file" ]] && [[ -f "$file" ]]; then
		source "$file"
	fi
done
unset file
