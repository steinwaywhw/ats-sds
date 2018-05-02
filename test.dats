#include "share/atspre_staload.hats"
staload "./sds.sats"

assume sds = [l:addr|l>null] strptr l

%{

#include <stdio.h>
#include "./sds/testhelp.h"
#include <limits.h>

%}

extern fun test_cond (string, bool): void = "mac#"
extern fun test_report (): void = "mac#"
extern fun memcmp(!sds, string, int): int = "mac#"
extern fun printf {ts:types} (string, ts): void = "mac#"
macdef LLONG_MIN  = $extval(llint, "LLONG_MIN")
macdef LLONG_MAX  = $extval(llint, "LLONG_MAX")
macdef UINT_MAX   = $extval(uint, "UINT_MAX")
macdef ULLONG_MAX = $extval(uint, "ULLONG_MAX")


extern fun sdsTest(): int
implement sdsTest() = 0 where {

    val x = sdsnew("foo")

    val _ = test_cond("Create a string and obtain the length", sdslen(x) = 3 && memcmp(x,"foo\0",4) = 0)

    val _ = sdsfree(x)
    val x = sdsnewlen("foo",2)
    val _ = test_cond("Create a string with specified length", sdslen(x) = 2 && memcmp(x,"fo\0",3) = 0)

    val x = sdscat(x,"bar")
    val _ = test_cond("Strings concatenation", sdslen(x) = 5 && memcmp(x,"fobar\0",6) = 0)

    val x = sdscpy(x,"a")
    val _ = test_cond("sdscpy() against an originally longer string", sdslen(x) = 1 && memcmp(x,"a\0",2) = 0)

    val x = sdscpy(x,"xyzxxxxxxxxxxyyyyyyyyyykkkkkkkkkk")
    val _ = test_cond("sdscpy() against an originally shorter string", sdslen(x) = 33 && memcmp(x,"xyzxxxxxxxxxxyyyyyyyyyykkkkkkkkkk\0",33) = 0)

    val _ = sdsfree(x)
    val x = sdscatprintf(sdsempty(),"%d",$vararg(123))
    val _ = test_cond("sdscatprintf() seems working in the base case", sdslen(x) = 3 && memcmp(x,"123\0",4) = 0)

    val _ = sdsfree(x)
    val x = sdsnew("--")
    val x = sdscatfmt(x, "Hello %s World %I,%I--", $vararg("Hi!", LLONG_MIN,LLONG_MAX))
    val _ = test_cond("sdscatfmt() seems working in the base case", sdslen(x) = 60 && memcmp(x,"--Hello Hi! World -9223372036854775808,9223372036854775807--",60) = 0)
    val _ = printf("[%s]\n",$vararg(sds2str(x)))

    val _ = sdsfree(x)
    val x = sdsnew("--")
    val x = sdscatfmt(x, "%u,%U--", $vararg(UINT_MAX, ULLONG_MAX))
    val _ = test_cond("sdscatfmt() seems working with unsigned numbers", sdslen(x) = 35 && memcmp(x,"--4294967295,18446744073709551615--",35) = 0)

    val _ = sdsfree(x)
    val x = sdsnew(" x ")
    val x = sdstrim(x," x")
    val _ = test_cond("sdstrim() works when all chars match", sdslen(x) = 0)

    val _ = sdsfree(x)
    val x = sdsnew(" x ")
    val x = sdstrim(x," ")
//    val _ = test_cond("sdstrim() works when a single char remains", sdslen(x) = 1 && x[0] = 'x')
    val _ = test_cond("sdstrim() works when a single char remains", sdslen(x) = 1)

    val _ = sdsfree(x)
    val x = sdsnew("xxciaoyyy")
    val x = sdstrim(x,"xy")
    val _ = test_cond("sdstrim() correctly trims characters", sdslen(x) = 4 && memcmp(x,"ciao\0",5) = 0)

    val y = sdsdup(x)
    val _ = sdsrange(y,1,1)
    val _ = test_cond("sdsrange(...,1,1)", sdslen(y) = 1 && memcmp(y,"i\0",2) = 0)

    val _ = sdsfree(y)
    val y = sdsdup(x)
    val _ = sdsrange(y,1,~1)
    val _ = test_cond("sdsrange(...,1,-1)", sdslen(y) = 3 && memcmp(y,"iao\0",4) = 0)

    val _ = sdsfree(y)
    val y = sdsdup(x)
    val _ = sdsrange(y,~2,~1)
    val _ = test_cond("sdsrange(...,-2,-1)", sdslen(y) = 2 && memcmp(y,"ao\0",3) = 0)

    val _ = sdsfree(y)
    val y = sdsdup(x)
    val _ = sdsrange(y,2,1)
    val _ = test_cond("sdsrange(...,2,1)", sdslen(y) = 0 && memcmp(y,"\0",1) = 0)

    val _ = sdsfree(y)
    val y = sdsdup(x)
    val _ = sdsrange(y,1,100)
    val _ = test_cond("sdsrange(...,1,100)", sdslen(y) = 3 && memcmp(y,"iao\0",4) = 0)

    val _ = sdsfree(y)
    val y = sdsdup(x)
    val _ = sdsrange(y,100,100)
    val _ = test_cond("sdsrange(...,100,100)", sdslen(y) = 0 && memcmp(y,"\0",1) = 0)

    val _ = sdsfree(y)
    val _ = sdsfree(x)
    val x = sdsnew("foo")
    val y = sdsnew("foa")
    val _ = test_cond("sdscmp(foo,foa)", sdscmp(x,y) > 0)

    val _ = sdsfree(y)
    val _ = sdsfree(x)
    val x = sdsnew("bar")
    val y = sdsnew("bar")
    val _ = test_cond("sdscmp(bar,bar)", sdscmp(x,y) = 0)

    val _ = sdsfree(y)
    val _ = sdsfree(x)
    val x = sdsnew("aar")
    val y = sdsnew("bar")
    val _ = test_cond("sdscmp(bar,bar)", sdscmp(x,y) < 0)

    val _ = sdsfree(y)
    val _ = sdsfree(x)
    val x = sdsnewlen("\a\n\0foo\r",7)
    val y = sdscatrepr(sdsempty(),sds2str(x),sdslen(x))
    val _ = test_cond("sdscatrepr(...data...)", memcmp(y,"\"\\a\\n\\x00foo\\r\"",15) = 0)
    val _ = printf("[%s] %d %d\n",$vararg(sds2str(y), sdslen(y), sdslen(x)))

    val _ = sdsfree x
    val _ = sdsfree y 
    val x = sdsnew("0")
    val _ = test_cond("sdsnew() free/len buffers", sdslen(x) = 1 && sdsavail(x) = 0)

    val _ = sdsfree(x)
    val _ = test_report()
}

implement main0 () = let 
    val _ = sdsTest()
in 
end