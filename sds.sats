%{#
#include "./sds/sds.h"
%}

absvtype sds = ptr
#define size_t int 

fun sdslen      (!sds): size_t               = "mac#"
fun sdsavail    (!sds): size_t               = "mac#"
fun sdssetlen   (!sds, newlen: size_t): void = "mac#"
fun sdsinclen   (!sds, inc: size_t): void    = "mac#"
fun sdsalloc    (!sds): size_t               = "mac#"
fun sdssetalloc (!sds, newlen: size_t): void = "mac#"

fun sdsnewlen   (string, size_t): sds = "mac#"
fun sdsnew      (string): sds         = "mac#"
fun sdsempty    (): sds               = "mac#"
fun sdsdup      (!sds): sds           = "mac#"
fun sdsfree     (sds): void           = "mac#"
fun sdsgrowzero (sds, size_t): sds    = "mac#"

fun sdscatlen (sds, string, size_t): sds = "mac#"
fun sdscat    (sds, string): sds         = "mac#"
fun sdscatsds (sds, !sds): sds           = "mac#"
fun sdscpylen (sds, string, size_t): sds = "mac#"
fun sdscpy    (sds, string): sds         = "mac#"

fun sdscatprintf {ts:types} (sds, fmt: string, args: ts): sds = "mac#"
fun sdscatfmt    {ts:types} (sds, fmt: string, args: ts): sds = "mac#"

fun sdstrim      (sds, string): sds                     = "mac#"
fun sdsrange     (!sds, from: size_t, to: size_t): void = "mac#"
fun sdsupdatelen (!sds): void                           = "mac#"
fun sdsclear     (!sds): void                           = "mac#"
fun sdscmp       (!sds, !sds): int                      = "mac#"

fun sdssplitlen     {n:int} (s: string, slen: size_t, sep: string, seplen: size_t, count: &int? >> int(n)): arrayptr(sds,n) = "mac#"
fun sdsfreesplitres {n:int} (arrayptr(sds,n), int(n)): void = "mac#"
fun sdssplitargs    {n:int} (line: string, argc: &int? >> int(n)): arrayptr (sds,n) = "mac#"

fun sdstolower (!sds): void = "mac#"
fun sdstoupper (!sds): void = "mac#"

fun sdsfromlonglong (llint): sds                                         = "mac#"
fun sdscatrepr      (sds, string, size_t): sds                           = "mac#"
fun sdsmapchars     (sds, from: string, to: string, setlen: size_t): sds = "mac#"

fun sdsjoin            (argv: string, argc: int, sep: string): sds                  = "mac#"
fun sdsjoinsds {n:int} (!arrayptr(sds,n), int(n), sep: string, seplen: size_t): sds = "mac#"
