
#!/bin/bash
#set -xe

# Code generated by https://github.com/awalterschulze/git-anchor
# source: src/github.com/gogo/letmegrpc
# DO NOT EDIT!

function subtreerev {
	git log | grep -E "(git-subtree-dir: $1|git-subtree-split)" | grep $1 -A 1 | grep git-subtree-split | head -1 | tr -d ' ' | cut -d ":" -f2
}

function subtrees {
	git log | grep git-subtree-dir | tr -d ' ' | cut -d ":" -f2 | sort | uniq | xargs -I {} bash -c 'if [ -d $(git rev-parse --show-toplevel)/{} ] ; then echo {}; fi'
}

function clonerev {
	(cd $1 && git log -1 | head -1 | cut -d " " -f2 )
}

function checkdep {
	dir=$1
	repo=$2
	rev=$3
	echo "checking dependency $dir $repo $rev"
	if [ ! -d $dir ]; then
		if `git rev-parse --is-inside-work-tree`
		then
			echo "ERROR: This is a git repo, but $dir does not exist."
			echo "       You could add a subtree like so:"
			echo "       $ git subtree add --prefix=$dir $repo master"
			exit 1
		else
			mkdir -p $dir
			git clone $repo $dir
			(cd $dir && git checkout $rev)
		fi
	else
		if [ -e $dir/.git ]; then
			echo "found git repo at $dir"
			crev=$(clonerev $dir)
			if [ $crev == $rev ]; then
				echo "git clone $dir is the correct revision"
			else
				echo "WARNING: git clone $dir is revision $crev, but correct version is $rev"
			fi
		else
			ss=$(subtrees)
			if [[ $ss == *"$dir"* ]]; then
				echo "found subtree at $dir"
				srev=$(subtreerev $dir)
				if [ $srev == $rev ]; then
					echo "git subtree $dir is the correct revision"
				else
					echo "WARNING: git subtree (Please ignore this warning if your subtree is not squashed) $dir is revision $srev, but correct version is $rev. "
				fi
			else
				echo "WARNING: $dir exists, but is not git repo or git subtree"
			fi
		fi
	fi
}


if [ ! -d src/github.com/gogo/letmegrpc ]; then
	echo "ERROR: src/github.com/gogo/letmegrpc does not exist, maybe you are running this script from the wrong folder."
	exit 1
fi


checkdep src/github.com/gogo/protobuf https://github.com/gogo/protobuf 2093b57e5ca2ccbee4626814100bc1aada691b18


checkdep src/google.golang.org/grpc https://github.com/grpc/grpc-go 3255a5521cec5027cdd8acdefb1ac7a130ac6e2b


checkdep src/golang.org/x/net https://github.com/golang/net db8e4de5b2d6653f66aea53094624468caad15d2


checkdep src/github.com/bradfitz/http2 https://github.com/bradfitz/http2 f8202bc903bda493ebba4aa54922d78430c2c42f


checkdep src/github.com/golang/glog https://github.com/golang/glog fca8c8854093a154ff1eb580aae10276ad6b1b5f


checkdep src/github.com/golang/protobuf https://github.com/golang/protobuf 8df8a93c670173cd1d8737a507a253b94f2d0b5a


checkdep src/golang.org/x/oauth2 https://github.com/golang/oauth2 9ecad5029bb3332276edfb7b23add78b0387a9f3


checkdep src/google.golang.org/cloud https://code.googlesource.com/gocloud 2c80ef8d7f7d6d87084b2a72474a4680cabc09c4


checkdep src/github.com/gogo/pbparser https://github.com/gogo/pbparser 62f2b658128c7b6bfde4db324651cd9e5d43d142



exit 0
