all: x iso rootfs
x: x.sh
	./x.sh
iso: mesalockiso
	./mesalockiso
rootfs: mesalockrootfs
	./mesalockrootfs
docker: rootfs
	sudo docker build --rm -t mssun/mesalock-linux docker
	sudo docker run --rm -it mssun/mesalock-linux
clean:
	@rm -rf build
	@rm -rf rootfs rootfs.tar.xz
	@rm -rf iso mesalock-linux.iso
