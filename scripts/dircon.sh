#!/bin/bash

#Used to convert linux directory paths into windows compatible for specific networks drives on /mnt/

linux_path="$1"

if [[ -z "$linux_path" ]]; then
  echo "Usage: $0 /path/to/linux/directory"
  exit 1
fi

# Clean any trailing slash just in case
linux_path="${linux_path%/}"

# Handle /mnt/Customers → Z:\
if [[ "$linux_path" == /mnt/Customers/* ]]; then
    subpath="${linux_path#/mnt/Customers/}"
    windows_path="Z:\\$(echo "$subpath" | sed 's|/|\\|g')"

# Handle /mnt/Shared → Y:\
elif [[ "$linux_path" == /mnt/Customers/* ]]; then
    subpath="${linux_path#/mnt/Customers/}"
    windows_path="Y:\\$(echo "$subpath" | sed 's|/|\\|g')"

# Handle /home/username → C:\Users\username
elif [[ "$linux_path" == /home/* ]]; then
    username=$(echo "$linux_path" | cut -d'/' -f3)
    subpath="${linux_path#/home/$username/}"
    if [[ "$subpath" == "$linux_path" ]]; then
        # if path is exactly /home/username
        windows_path="C:\\Users\\$username"
    else
        windows_path="C:\\Users\\$username\\$(echo "$subpath" | sed 's|/|\\|g')"
    fi

# Fallback: generic conversion (C:\...)
else
    trimmed="${linux_path#/}"
    windows_path="C:\\$(echo "$trimmed" | sed 's|/|\\|g')"
fi

echo "$windows_path"

printf "%s\n" "$windows_path" | xclip -selection clipboard

