# ~/.bash_logout

history -a # Append the ``new'' history lines
history -c # Clear History

if [ "$SHLVL" = 1 ]; then
     [ -x /usr/bin/clear_console ] \
       && /usr/bin/clear_console -q
fi
