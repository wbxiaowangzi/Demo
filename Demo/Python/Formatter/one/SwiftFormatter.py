#!/usr/bin/python
# -*- coding: UTF-8 -*-

import os
import re
# import os.path

# 1，遍历当前文件夹下的.swift文件
from builtins import list


def get_swift_file_names(file_dir):
    paths = []
    for root, dirs, files in os.walk(file_dir):
        for file in files:
            if os.path.splitext(file)[1] == ".swift":
                paths.append(os.path.join(root, file))
        for di in dirs:
            paths += get_swift_file_names(di)
    return paths


def change(matched):
    value = matched.group()
    arr = list(value)
    result = " ".join(arr)
    return result


def join_space_one(matched):
    value = matched.group()
    arr = list(value)
    arr.insert(1, " ")
    result = "".join(arr)
    return result


def join_space_two(matched):
    value = matched.group()
    arr = list(value)
    arr.insert(2, " ")
    result = "".join(arr)
    return result


# 2，逐行处理.swift中的代码
def formatter_the_file(file_path):
    file = open(file_path, "r")
    file2 = open(file_path + ".bak", "w")
    line = file.readline()
    while line:
        # 添加空格
        va = re.sub(r'\S\{', change, line, re.I)
        va = re.sub(r'\}e', change, va, re.I)
        va = re.sub(r':\S', change, va, re.I)
        va = re.sub(r',\S', change, va, re.I)
        va = re.sub(r'->\S', join_space_two, va, re.I)
        va = re.sub(r'\S->', join_space_one, va, re.I)
        file2.write(va)
        line = file.readline()
        # 添加换行
        if is_var_or_class(va) and is_var_or_class(line):
            file2.write("\n")
        if is_var_or_class(va) and is_func(line):
            file2.write("\n")
        # 多行空行只保留一个空行
        if va.isspace() and line.isspace():
            line = file.readline()
            while line.isspace():
                line = file.readline()
                pass

    file2.close()
    os.remove(file_path)
    os.rename("%s.bak" % file_path, file_path)


def formatter_current_folder():
    names = get_swift_file_names(os.getcwd())
    for name in names:
        formatter_the_file(name)


def formatter_the_folder(p):
    p = os.path.abspath(p)
    names = get_swift_file_names(p)
    for name in names:
        formatter_the_file(name)


# 判断一个字符串是否是定义的属性或类
def is_var_or_class(line):
    is_v = re.match(r'.*var.*:.*', line, flags=0)\
           or re.match(r'.*var.*=.*', line, flags=0)\
           or re.match(r'.*class.*{.*', line, flags=0)
    return is_v is not None


# 判断一个字符串是否是方法
def is_func(line):
    is_f = re.match(r'.*func.*\(.*\).*{.*', line, flags=0)
    return is_f is not None
