NAME=auto-brightness

SRC=./src
BUILD=./build
BUILD_SBIN=${BUILD}/sbin
BUILD_SERVICE=${BUILD}/service
BUILD_CONF=${BUILD}/etc

SBINDIR=/usr/local/sbin
SERVICE_DIR=/usr/lib/systemd/system
CONFDIR=/etc

all:
	cp -ar src build
	sed -i 's|%SBINDIR%|${SBINDIR}|g' ${BUILD_SERVICE}/${NAME}.service
	sed -i 's|%NAME%|${NAME}|g' ${BUILD_SERVICE}/${NAME}.service
	
install:
	mkdir -p "${SBINDIR}"
	mkdir -p "${SERVICE_DIR}"
	mkdir -p "${CONFDIR}"

	cp "$(BUILD_SBIN)/${NAME}d" "${SBINDIR}/"
	cp "${BUILD_SERVICE}/${NAME}.service" "${SERVICE_DIR}/"
	cp "${BUILD_CONF}/${NAME}.conf" "${CONFDIR}/"
	chmod 555 "${SBINDIR}/${NAME}d"
	chmod 444 "${SERVICE_DIR}/${NAME}.service"
	chmod 644 "${CONFDIR}/${NAME}.conf"
	systemctl daemon-reload || true

uninstall:
	rm -f "${SBINDIR}/${NAME}d"
	rm -f "${SERVICE_DIR}/${NAME}.service"
	rm -f "${CONFDIR}/${NAME}.conf"
	systemctl daemon-reload || true

clean: 
	rm -rf "${BUILD}"

