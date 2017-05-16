for i in $(find `pwd` -name "*.asm"); 
do
    mv "$i" "${i%.asm}.s" 
done
