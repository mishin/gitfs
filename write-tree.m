Writetree: module
{
	PATH: con "/dis/git/write-tree.dis";

	init: fn(args: list of string, debug: int);
	writetree: fn(index: ref Gitindex->Index): string;
};

