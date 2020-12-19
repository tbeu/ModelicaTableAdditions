AR = ar -ru
RM = rm -f

CFLAGS = -O3 -Wno-attributes
CPPFLAGS = -DNDEBUG -DHAVE_UNISTD_H -DHAVE_STDARG_H -DHAVE_HIDDEN -DHAVE_MEMCPY
INC = -I"../../C-Sources/zlib"

TARGETDIR = linux64

TABLES_OBJS = \
	ModelicaTableAdditions.o \
	ModelicaTableAdditionsUsertab.o 

IO_OBJS = \
	ModelicaIOAdditions.o

ALL_OBJS = $(TABLES_OBJS) $(IO_OBJS)

all: clean libModelicaTableAdditions.a libModelicaIOAdditions.a

libModelicaTableAdditions.a: $(TABLES_OBJS)
	$(AR) $@ $(TABLES_OBJS)
	cp $@ ../../Library/$(TARGETDIR)/$@

libModelicaIOAdditions.a: $(IO_OBJS)
	$(AR) $@ $(IO_OBJS)
	cp $@ ../../Library/$(TARGETDIR)/$@

ModelicaTableAdditions.o: ../../C-Sources/ModelicaTableAdditions.c
	$(CC) $(CPPFLAGS) -DTABLE_SHARE=1 $(CFLAGS) $(INC) -c -o $@ $<

ModelicaTableAdditionsUsertab.o: ../../C-Sources/ModelicaTableAdditionsUsertab.c
	$(CC) $(CPPFLAGS) -DDUMMY_FUNCTION_USERTAB $(CFLAGS) $(INC) -c -o $@ $<

ModelicaIOAdditions.o: ../../C-Sources/ModelicaIOAdditions.c
	$(CC) $(CPPFLAGS) $(CFLAGS) $(INC) -c -o $@ $<

clean:
	$(RM) $(ALL_OBJS)
	$(RM) *.a
	$(RM) ../../Library/$(TARGETDIR)/*.a
