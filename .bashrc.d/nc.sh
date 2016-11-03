# Use openbsd's nc if it's available and the system nc isn't the openbsd nc

unalias nc 2>/dev/null
case "$(type -t nc.openbsd),$(readlink -f $(which nc))" in
    ,*|*,*openbsd*)
        ;;
    file,*)
        alias nc=nc.openbsd
        ;;
esac
