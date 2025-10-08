for file in /etc/bash_completion /usr/local/etc/bash_completion /opt/homebrew/etc/bash_completion /opt/homebrew/etc/profile.d/bash_completion.sh; do
  if [ -f $file ]; then
    . $file
  fi
done
