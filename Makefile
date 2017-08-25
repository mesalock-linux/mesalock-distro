all:
	./run.sh
build_docker:
	sudo docker build --rm -t mssun/mesalock-linux .
run_docker:
	sudo docker run --rm -it mssun/mesalock-linux
clean:
	rm -rf rootfs rootfs.tar.xz
	rm -rf src
