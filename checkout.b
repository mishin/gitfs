implement Checkoutmod;

include "gitfs.m";
include "mods.m";
mods: Mods;
include "modules.m";

sprint: import sys;	
readcommit: import commitmod;	
Shaobject: import Gitfs;
Entry, Index: import gitindex;
readtree: import treemod;
dirname, makeabsentdirs, string2path: import pathmod;
cutprefix, error, isunixdir, objectstat, readsha1file, sha2string, string2sha: import utils;	

index: ref Index;
commit: string;

init(m: Mods)
{
	mods = m;
}

checkout(ind: ref Index, sha1: string): ref Index
{
	index = ind;
	commit := readcommit(sha1);
	index = index.removeentries();
#FIXME: determine why len repopath - 1
	checkouttree(repopath[:len repopath-1], commit.treesha1);
	
	return index;
}

checkouttree(path, treesha1: string)
{
	tree := readtree(treesha1);
	while(tree.children != nil){
		(mode, filepath, sha1) := hd tree.children;
		tree.children = tl tree.children;
		fullpath := sprint("%s/%s", path, filepath);
		if(isunixdir(mode)){
			sys->create(fullpath, Sys->OREAD, 8r755|Sys->DMDIR);
			checkouttree(fullpath, sha1);
			continue;
		}
		checkoutblob(fullpath, sha1);
	}
}

checkoutblob(path, sha1: string)
{
	fd := sys->create(path, Sys->OWRITE, 8r644);
	if(fd == nil){
		makeabsentdirs(dirname(path));
		if((fd = sys->create(path, Sys->OWRITE, 8r644)) == nil){
			error(sprint("couldn't create file(%s): %r\n", path));
			return;
		}
	}

	name := cutprefix(repopath, path);
	flags := len name & 16r0fff;
	shaobject := shatable.find(sha1);
	if(shaobject == nil){
		dirstat := objectstat(string2path(sha1)).t1;
		shaobject = ref Shaobject(ref dirstat, nil, sha1, "blob", nil);
		shatable.add(string sha1, shaobject);
	}
	e := ref Entry(shaobject.dirstat.qid, string2sha(sha1), flags, name);
	index.addentry(e);
	index.header.entriescnt++;
	(nil, nil, buf) := readsha1file(sha1);
	cnt := sys->write(fd, buf, len buf);
	if(cnt != len buf){
		error(sprint("error occured while checkout blob file(%s): %r\n", sha1));
	}
	(ret, dirstat) := sys->stat(path);
	dirstat.qid = shaobject.dirstat.qid;
	shaobject.dirstat = ref dirstat;
}
