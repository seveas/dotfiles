for f in $(cd ~ ; find -maxdepth 1 -name '.muttrc*'); do
    s=${f/.*-/}
    alias mutt-$s="mutt -F ~/$f"
done
