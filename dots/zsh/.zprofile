test -d /opt/homebrew && eval "$(/opt/homebrew/bin/brew shellenv)"
test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

for file in ~/.{aliases,functions,path,exports,extra}; do
	if [[ -r "$file" ]] && [[ -f "$file" ]]; then
		source "$file"
	fi
done
unset file

if [ ! -f /tmp/fortune-$(date +%y%m%d%p) ]; then
  rm -rf "/tmp/fortune-*" &> /dev/null || true
	touch /tmp/fortune-$(date +%y%m%d%p)
	fortune ~/.dotfiles/quotes/quotes
fi
# date "+%a %y%m%d" | tr '[:lower:]' '[:upper:]'
