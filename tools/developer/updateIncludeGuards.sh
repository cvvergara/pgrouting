FILES=$(git ls-files include)
    for d in ${FILES}
    do
        echo $d
        val=${d^^}
        echo $val
        val=$(echo "${val/\//_}")
        val=$(echo "${val/\//_}")
        val=$(echo "${val/\//_}")
        val=$(echo "${val/\./_}_")
        echo $val
        perl -pi -e "s/INCLUDE.*/${val}/" $d
    done
