include(CheckSymbolExists)
check_symbol_exists(memcpy "string.h" HAVE_MEMCPY)

include(CheckIncludeFile)
check_include_file("dirent.h" HAVE_DIRENT_H)
check_include_file("locale.h" HAVE_LOCALE_H)
check_include_file("pthread.h" HAVE_PTHREAD_H)
check_include_file("stdarg.h" HAVE_STDARG_H)
check_include_file("unistd.h" HAVE_UNISTD_H)
