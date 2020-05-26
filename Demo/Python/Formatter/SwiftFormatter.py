#!/usr/bin/python
# -*- coding: UTF-8 -*-

import os
import re


# 1，遍历当前文件夹下的.swift文件
def get_swift_file_names(file_dir):
    paths = []
    for root, dirs, files in os.walk(file_dir):
        for file in files:
            if os.path.splitext(file)[1] == ".swift":
                paths.append(os.path.join(root, file))
    # print(names)
    return paths


def change(matched):
    value = matched.group()
    arr = list(value)
    result = " ".join(arr)
    return result


# 2，逐行处理.swift中的代码
def formatter_the_file(path):
    file = open(path, "r")
    file2 = open(path + ".bak", "w")
    line = file.readline()
    while line:
        va = re.sub(r'\S\{', change, line, re.I)
        va = re.sub(r':\S', change, va, re.I)
        va = re.sub(r',\S', change, va, re.I)

        file2.write(va)
        line = file.readline()
    file2.close()
    os.remove(path)
    os.rename("%s.bak" % path, path)


def formatter_current_folder():
    names = get_swift_file_names(os.getcwd())
    for name in names:
        formatter_the_file(name)


def formatter_the_folder(path):
    p = os.path(path)
    names = get_swift_file_names(p)
    for name in names:
        formatter_the_file(name)

