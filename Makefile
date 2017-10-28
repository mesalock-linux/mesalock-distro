all: pkg iso rootfs
pkg:
	fakeroot ./x.sh
iso:
	fakeroot ./mesalockiso
rootfs:
	fakeroot ./mesalockrootfs
docker: rootfs
	sudo docker build --rm -t mssun/mesalock-linux docker
	sudo docker run --rm -it mssun/mesalock-linux
clean:
	rm -rf build
	rm -rf rootfs rootfs.tar.xz
	rm -rf iso mesalock-linux.iso
