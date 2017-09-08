all:
	./x.sh
build_docker:
	sudo docker build --rm -t mssun/mesalock-linux docker
run_docker:
	sudo docker run --rm -it mssun/mesalock-linux
clean:
	rm -rf rootfs rootfs.tar.xz
	rm -rf build
