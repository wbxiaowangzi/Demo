#!/usr/bin/python
# -*- coding: UTF-8 -*-

import os
import shutil
import json
import sys

class Basic:
	repo = "Podspec"
	repo_git = "git@git.haomaiyi.com:Apple/Framework/Podspec.git"
	begin_token = "# HMY Begin"
	end_token = "# HMY End"
	podfile = 'Podfile'
	localfile = 'Podfile.local'

def update_repo():
	paths = os.getcwd().split("/")
	podspecPath = "/%s/%s/.cocoapods/repos/%s" % (paths[1], paths[2], Basic.repo)
	if os.path.exists(podspecPath) == False:
		os.system('pod repo add %s %s' % (repo, repo_git))

	os.system('/usr/bin/git -C %s pull --ff-only' % podspecPath)

def prepare():
	workspacePath = os.getcwd()
	derivedData = workspacePath + "/DerivedData"
	if os.path.exists(derivedData):
		shutil.rmtree(derivedData)

	lockfile = workspacePath + "/Podfile.lock"
	if os.path.exists(lockfile):
		os.remove(lockfile)

	if os.path.exists(workspacePath + '/' + Basic.localfile):
		pass
	else:
		os.system(r'touch %s' % Basic.localfile)
		fopen = open(Basic.localfile,'w')
		fopen.write("# pod 'Origami' ,:path => '../Origami/Origami.podspec'")
		fopen.close()
	temp = 'Podfile.temp'
	shutil.copy(Basic.podfile, temp)
	return temp

def parse_podfile():
	begin = False
	pod_version = {}
	localpod_path = {}

	custom_replace = lambda a : a.replace(',','').replace("\"","").replace("'","")
	fopen = open(Basic.podfile)
	for line in fopen:
		if not begin:
			if Basic.begin_token in line:
				begin = True
		else:
			if Basic.end_token in line:
				begin = False
			else:
				pod_vars = line.split()
				name = custom_replace(pod_vars[1])
				version = custom_replace(pod_vars[2])
				pod_version[name] = version
	fopen.close()

	fopen = open(Basic.localfile)
	for line in fopen:
		pod_vars = line.split(",")
		if len(pod_vars) == 2:
			if "#" in pod_vars[0]:
				continue
			name = pod_vars[0].split()[1].replace("\"","").replace("'","")
			path = pod_vars[1]
			localpod_path[name] = path
	fopen.close()

	return (pod_version, localpod_path)

def new_version(pod_version, ignore_pods):
	newpod_version = {}
	for key, value in pod_version.items():
		if key in ignore_pods:
			continue
		paths = os.getcwd().split("/")
		podspecPath = "/%s/%s/.cocoapods/repos/%s" % (paths[1], paths[2], Basic.repo)
		podPath = podspecPath + "/" + key
		if os.path.exists(podPath):
			dirs = os.listdir(podPath)
			dirs.sort()
			idx = dirs.index(value)
			for i in range(idx+1, len(dirs)):
				version = dirs[i]
				if version == ".DS_Store":
					continue
				else:
					if str(version) > value:
						newVersion = raw_input("🍎  %s 发现新版本:%s, 是否使用？(按任意键使用，n不使用）：" % (str(key), str(version)))
						if newVersion != "n":
							newpod_version[key] = str(version)
	return newpod_version

def rewrite(localpod_path, newpod_version, source = Basic.podfile):
	begin = False
	w_str = ""
	fopen = open(source, 'r')
	for line in fopen:
		if not begin:
			if Basic.begin_token in line:
				begin = True
		else:
			if Basic.end_token in line:
				begin = False
			else:
				pod_vars = line.split()
				name =  pod_vars[1].replace(',','').replace("\"","").replace("'","")
				version = pod_vars[2].replace(',','')
				if newpod_version.has_key(name):
					new_version = "'%s'" % newpod_version[name]
					line = line.replace(version, new_version)
				if localpod_path.has_key(name):
					line = "pod '%s' , " % name + localpod_path[name]
		w_str += line

	fopen.close()
	fopen = open(Basic.podfile, 'w')
	fopen.write(w_str)
	fopen.close()

def restore(newpod_version, temp_file):
	rewrite({}, newpod_version, temp_file)
	os.remove(temp_file)

def compress(pods):
	dirs = map(lambda x : os.getcwd() + "/Pods/" + x, pods)
	pngquantPath = os.getcwd() + "/.pngquant"
	cmdPath = pngquantPath + "/pngquant"
	if os.path.exists(cmdPath) == False:
		os.chdir(pngquantPath)
		os.system("git clone git://github.com/pornel/pngquant.git")
		os.chdir(cmdPath)
		os.system("make")
	os.chdir(pngquantPath)
	os.system("python compressPNG.py " + "#".join(dirs))

def main(argv):
	update_repo()
	temp_file = prepare()
	(pod_version, localpod_path) = parse_podfile()
	newpod_version = new_version(pod_version, localpod_path.keys())
	rewrite(localpod_path, newpod_version)
	os.system('pod install')
	restore(newpod_version, temp_file)

	if len(argv) > 1 and argv[1] == "--compress":
		compress(filter(lambda x :  x not in localpod_path.keys(), pod_version.keys()))
		
if __name__ == "__main__":
	main(sys.argv)

