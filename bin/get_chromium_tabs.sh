#!/bin/sh
# Get list of open tabs from chromium browser

strings ~/.config/chromium/Default/Current\ Session | grep -Eo '(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]' | grep -v '/$' | grep -v '=$' | sort -u
