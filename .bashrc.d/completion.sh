for dir in / /usr/local /opt/homebrew; do
  if [ -f $dir/etc/bash_completion ]; then
    . $dir/etc/bash_completion
  fi
done
