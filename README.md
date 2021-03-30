# iOS通用打包脚本

# 依赖
- fastlane

若没有`fastlane`可安装
```sh
brew install fastlane
```

## 用法
1. 到项目目录下
```sh
mkdir script # 文件夹名字随便取
```

2. 修改脚本中的变量
```sh
scheme= #工程和scheme
BundleIdentifier= #项目的bid
```

3. 在`start`函数中，选取开启方法以满足你的需求
4. 需要上传第三方平台 请替换 `uploadAdhocPgy` 函数中的key
5. 需要上传appstore，请修改脚本中变理
```sh
AppleId="350442340@qq.com"
AppleId_password=""
```