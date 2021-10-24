NAME=auto-brightness
VERSION=0.1.0

SRC=./src
BUILD=./build
BUILD_SBIN=${BUILD}/sbin
BUILD_SERVICE=${BUILD}/service
BUILD_CONF=${BUILD}/etc

SBINDIR=/usr/local/sbin
SERVICE_DIR=/usr/lib/systemd/system
CONFDIR=/etc

all: deps clean
	cp -ar src build
	sed -i 's|%SBINDIR%|${SBINDIR}|g' ${BUILD_SERVICE}/${NAME}.service
	sed -i 's|%NAME%|${NAME}|g' ${BUILD_SERVICE}/${NAME}.service
	sed -i 's|%VERSION%|${VERSION}|g' "${BUILD_SBIN}/${NAME}d"

deps:
	bc --version > /dev/null 2>&1 || bash -c 'echo "bc must be installed!"; exit 1'
	
install:
	mkdir -p "${SBINDIR}"
	mkdir -p "${SERVICE_DIR}"
	mkdir -p "${CONFDIR}"

	cp "$(BUILD_SBIN)/${NAME}d" "${SBINDIR}/"
	cp "${BUILD_SERVICE}/${NAME}.service" "${SERVICE_DIR}/"
	cp "${BUILD_CONF}/${NAME}d.conf" "${CONFDIR}/"
	chmod 555 "${SBINDIR}/${NAME}d"
	chmod 444 "${SERVICE_DIR}/${NAME}.service"
	chmod 644 "${CONFDIR}/${NAME}d.conf"
	systemctl daemon-reload || true
	sudo systemctl enable auto-brightness
	sudo systemctl restart auto-brightness

uninstall:
	sudo systemctl disable auto-brightness
	sudo systemctl stop auto-brightness

	rm -f "${SBINDIR}/${NAME}d"
	rm -f "${SERVICE_DIR}/${NAME}.service"
	systemctl daemon-reload || true

clean: 
	rm -rf "${BUILD}"

