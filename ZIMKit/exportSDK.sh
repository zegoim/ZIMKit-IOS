#!/bin/bash

# 获取当前脚本所在目录
script_dir="$( cd "$( dirname "$0"  )" && pwd  )"

# 工程根目录
project_dir=$script_dir

# 进入项目工程目录
cd ${project_dir}

# 进入Example目录
cd Example/

pod install
#pod cache clean --all
#pod cache clean --all ZXIMSDK

# 回到上级目录
cd ../
pod package ZIMKit.podspec --force --embedded

exit 0
