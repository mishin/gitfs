
Utils: module
{
	PATH: con "/dis/git/utils.dis";

	QIDSZ:    con 16;
	BIGSZ:    con 8;
	INTSZ:    con 4;
	SHALEN:   con 20;
	MAXINT: con (1 << 31) - 1;

	debug: int;

	Config: adt
	{
		attr, val: string;
	};

	init:          fn(arglist: list of string, debug: int);
	
	writesha1file: fn(ch: chan of (int, array of byte));
	readsha1file:  fn(path: string): (string, int, array of byte);

	filesha1:      fn (path: string): array of byte;
	bufsha1:       fn(buf: array of byte): array of byte;
	
	int2string:    fn(num: int): string;

	save2file:     fn(path: string, buf: array of byte): int;
	sha2string:    fn(sha: array of byte): string;
	string2sha:    fn(sha1: string): array of byte;

	comparebytes:  fn(a, b: array of byte): int;
	bytes2int:     fn(buf: array of byte, offset: int): int;
	bytes2big:     fn(buf: array of byte, offset: int): big;
	big2bytes:     fn(n: big): array of byte;
	int2bytes:     fn(number: int): array of byte;
	allocnr:       fn(num: int): int;
	readint:       fn(fd: ref Sys->FD): int;
	readshort:     fn(fd: ref Sys->FD): int;

	packqid:       fn(qid: ref Sys->Qid): array of byte;
	unpackqid:     fn(buf: array of byte, offset: int): Sys->Qid;

	copyarray:     fn(dst: array of byte, doffset: int, src: array of byte, soffset, count : int);
	cutprefix:     fn(prefix, s: string): string;

	equalqids:     fn(q1,q2: Sys->Qid): int;
	extractfile:   fn(shafilename: string): string;
	equalshas:     fn(sha1, sha2: array of byte): int;

	ltrim:         fn(s: string): string;
	chomp:         fn(s: string): string;
	splitl:        fn(s: string, sep: string, count: int): (string, string);

	readline:      fn(ibuf: ref Iobuf): string;

	isunixdir:         fn(mode: int): int;
	bytepos:       fn(a: array of byte, offset: int, delim: byte): int; 

	error:	       fn(msg: string);
	debugmsg:      fn(msg: string);
};


