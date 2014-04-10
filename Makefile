# pdwm - dynamic window manager
# See LICENSE file for copyright and license details.

include config.mk

SRC = drw.c pdwm.c util.c
OBJ = ${SRC:.c=.o}

all: options pdwm

options:
	@echo pdwm build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	@echo CC $<
	@${CC} -c ${CFLAGS} $<

${OBJ}: config.h config.mk

config.h:
	@echo creating $@ from config.def.h
	@cp config.def.h $@

pdwm: ${OBJ}
	@echo CC -o $@
	@${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	@echo cleaning
	@rm -f pdwm ${OBJ} pdwm-${VERSION}.tar.gz

dist: clean
	@echo creating dist tarball
	@mkdir -p pdwm-${VERSION}
	@cp -R LICENSE Makefile README config.def.h config.mk \
		pdwm.1 ${SRC} pdwm-${VERSION}
	@tar -cf pdwm-${VERSION}.tar pdwm-${VERSION}
	@gzip pdwm-${VERSION}.tar
	@rm -rf pdwm-${VERSION}

install: all
	@echo installing executable file to ${DESTDIR}${PREFIX}/bin
	@mkdir -p ${DESTDIR}${PREFIX}/bin
	@cp -f pdwm ${DESTDIR}${PREFIX}/bin
	@chmod 755 ${DESTDIR}${PREFIX}/bin/pdwm
	@echo installing manual page to ${DESTDIR}${MANPREFIX}/man1
	@mkdir -p ${DESTDIR}${MANPREFIX}/man1
	@sed "s/VERSION/${VERSION}/g" < pdwm.1 > ${DESTDIR}${MANPREFIX}/man1/pdwm.1
	@chmod 644 ${DESTDIR}${MANPREFIX}/man1/pdwm.1

uninstall:
	@echo removing executable file from ${DESTDIR}${PREFIX}/bin
	@rm -f ${DESTDIR}${PREFIX}/bin/pdwm
	@echo removing manual page from ${DESTDIR}${MANPREFIX}/man1
	@rm -f ${DESTDIR}${MANPREFIX}/man1/pdwm.1

.PHONY: all options clean dist install uninstall
