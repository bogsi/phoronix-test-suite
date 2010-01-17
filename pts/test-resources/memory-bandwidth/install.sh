#!/bin/sh

rm -rf bandwidth-0.15/

tar -zxvf bandwidth-0.15.tar.gz
tar -zxvf bandwidth-patch-1.tar.gz

patch -p0 < bandwidth-015-add-options.patch
cd bandwidth-0.15/
make -j $NUM_CPU_JOBS
echo $? > ~/install-exit-status
ln bandwidth ../
cd ..

echo "#!/bin/sh

case \"\$1\" in
\"TEST_L2READ\")
	./bandwidth -l2read | grep \"L2 cache sequential read\" > \$LOG_FILE
	;;
\"TEST_L2WRITE\")
	./bandwidth -l2write | grep \"L2 cache sequential write\" > \$LOG_FILE
	;;
\"TEST_READ\")
	./bandwidth -read | grep \"Main memory sequential read\" > \$LOG_FILE
	;;
\"TEST_WRITE\")
	./bandwidth -write | grep \"Main memory sequential write\" > \$LOG_FILE
	;;
esac
" > memory-bandwidth
chmod +x memory-bandwidth
