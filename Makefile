
VOLUMES=-v `pwd`:/src -v crates:/root/.cargo -v node_modules:/src/client/node_modules -v fitnesstrax_rust:/src/server/target -v /src/client/dist

.PHONY: build-ubuntu server server-release client package-ubuntu

build-ubuntu:
	docker run ${VOLUMES} -w /src fitnesstrax-ubuntu-build make build-ubuntu-

package-ubuntu:
	docker run ${VOLUMES} -w /src fitnesstrax-ubuntu-build make package-ubuntu-

shell-ubuntu:
	docker run -it ${VOLUMES} -w /src fitnesstrax-ubuntu-build

build-ubuntu-: server client

package-ubuntu-: server-release client
	mkdir -p dist/opt/fitnesstrax/bin
	mkdir -p dist/opt/fitnesstrax/client
	cp server/target/release/fitnesstrax-server dist/opt/fitnesstrax/bin/fitnesstrax-server
	cp client/dist/* dist/opt/fitnesstrax/client
	cd dist && fpm -f -s dir -t deb -n fitnesstrax -v `git describe --abbrev=4 HEAD` opt

server:
	cd server && cargo test

server-release:
	cd server && cargo build --release && cargo test

client:
	cd client && npm install && npm run build && npm run test
