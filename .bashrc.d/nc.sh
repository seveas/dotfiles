# Use openbsd's nc if it's available and the system nc isn't the openbsd nc

case "$(type -t nc.openbsd),$(readlink -f $(/bin/which nc))" in
    ,*|*,*openbsd*)
        ;;
    file,*)
        alias nc=nc.openbsd
        ;;
esac
