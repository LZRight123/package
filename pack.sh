#!/bin/sh

script_dir=$(cd $(dirname $0);pwd)
projectDirectory=$(dirname $script_dir)
echo "脚本目录=${script_dir}"
echo "工程目录=${projectDirectory}"

# 修改scheme 
scheme="Deer"
BundleIdentifier="com.xx.houseDeer"
#["app-store", "ad-hoc", "development", "developer-id", "package", "enterprise"]
# method="ad-hoc"
method="development"
# method="app-store"

version_number=""
new_build_number=""
ipaPath=""
ipaName=${scheme}

# 苹果账号 需要上传appstore 才写
AppleId="350442340@qq.com"
AppleId_password=""

# 💊👌🐒🐂👏🏿🌹⬆️㊙️🐱🎩🐂🐲✈️👀🚀🔥🎮💕🏆🎁 💯 🌹
#生成build号
function generateBuildNumber(){
    # usr/libexec/PlistBuddy 用来获取info.plist 信息
    # agvtool 用来全局设置build号 也可以用 usr/libexec/PlistBuddy  agvtool必需在.xcodeproj目录下
    # cd ~/Documents/GitHub/jzt_supplier_ios/JZT_SUPPLIER 
    cd ${projectDirectory}
    version_number=$(agvtool what-marketing-version -terse1)
    old_build_number=$(agvtool what-version -terse)

    # info_plist_file=./${scheme}/Other/Info.plist
    # version_number=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" ${info_plist_file})
    # old_build_number=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" ${info_plist_file})
    
    echo "修改 ${version_number} 环 境 至 ${method} 👀 👀 👀 👀 👀 💊 💊 💊 💊 💊 💊" 
    if [ ${method} = "development" ]
    then
        new_build_number=`date +%m%d%H%M`
    else
        new_build_number=`date +%y%m%d%H%M`
    fi

    echo "修改build号 ㊙️ ㊙️ ㊙️ ㊙️ ㊙️ ㊙️ ㊙️ ㊙️ ✈️ ✈️ ✈️ ✈️ ✈️ ✈️ ✈️"
    echo 旧的build号是 ${old_build_number} 新的build号是 ${new_build_number}
    if [ $old_build_number = $new_build_number ] 
    then
        echo 两个build号是一样的 不修改
    else
        agvtool new-version -all ${new_build_number} 
    fi
}
#提交修改到git
function pushToGit(){
    #need? git config --global credential.helper store 
    # git add .
    # git commit -m "打测试包" #测试
    # git commit -m "打正式包" #正式
    # git push
    git add --all; git commit -m "打包提交。。。"; git pull; git push;
}

#打包
function archive(){
    # which xxx  查看命令安装路径
    cd ${projectDirectory}
    ipaPath=${projectDirectory}/Targets/${version_number}/${new_build_number}
    echo "ipaPath = " + ${ipaPath} + "开始打包🎁 🎁 🎁 🎁 🎁 🎁 🎁 🎁 🚀 🚀 🚀 🚀 🚀 🚀"

    # fastlane build \
    # ipaPath:"${ipaPath}" \
    # ipaName:"${ipaName}" \
    # method:"${method}"

    # 不需要用 Fastfile
    #app-store, ad-hoc, enterprise, development
    fastlane run build_ios_app scheme:${scheme}  export_method:${method} \
      export_xcargs:"-allowProvisioningUpdates" \
      output_directory:${ipaPath} output_name:${ipaName} \
      buildlog_path:"./Targets" silent:"true" clean:false
    
    echo "打包完成 🎉 🎉 🎉"
}


#上传
function uploadDsym() {
    echo "🚀上🚀传🚀dsym -> https://bugly.qq.com/v2/crash-reporting/preferences/dsyms/ffb92630a6?pid=2"
    # cd到 build目录 一般这个目录会有 appsup.ipa 和 appsup.app.DSYM.zip 文件
    cd ${ipaPath}

    curl -k "https://api.bugly.qq.com/openapi/file/upload/symbol?app_key=f19da498-e39f-40d2-bdb8-6de3c062ef95&app_id=f55b0e3405" \
     --form "api_version=1" \
     --form "app_id=f55b0e3405" \
     --form "app_key=f19da498-e39f-40d2-bdb8-6de3c062ef95" \
     --form "symbolType=2"  \
     --form "bundleId=${BundleIdentifier}" \
     --form "productVersion=${version_number}" \
     --form "fileName=${ipaName}.app.dSYM.zip" \
     --form "file=@${ipaName}.app.dSYM.zip" \
     --verbose
}


function uploadIpa(){
    echo "开始上传ipa⬆️ ⬆️ ⬆️ ⬆️ ⬆️ ⬆️ ⬆️ ⬆️ ⬆️ ⬆️ ⬆️"
    if [ ${method} = "development" ]
    then
        # uploadAdhocPgy
        uploadSelfServer
    elif [ ${method} = "ad-hoc" ]
    then
        # uploadAdhocPgy
        uploadSelfServer
    elif [ ${method} = "app-store" ]
    then
        uploadAppstore
    else
        echo "区分不了method"
    fi
}


function uploadAdhocPgy(){
    echo "adhoc 版本 上传蒲公英 ⬆️  ⬆️  ⬆️  ⬆️  ⬆️  ⬆️  ⬆️  ⬆️  ⬆️  ⬆️  ⬆️  ⬆️"
    cd ${ipaPath}
    
    curl -F "file=@${ipaName}.ipa" \
     -F "uKey=4160b56a739d06a6e84a68ecf69c0a3b" \
     -F "_api_key=8db1d53efc98afbed7b9566698df95f1" \
      https://upload.pgyer.com/apiv1/app/upload
    
    # deleteIpa
}


function uploadSelfServer() {
    echo "adhoc 版本 上传到 自己服务器http://dev.oms.luguanjia.com/appManage/list.html ⬆️  ⬆️  ⬆️  ⬆️  ⬆️  ⬆️  ⬆️  ⬆️  ⬆️  ⬆️  ⬆️  ⬆️"
    cd ${ipaPath}

    curl -F "file=@${ipaName}.ipa" \
     -F "id=17" \
     -F "clientType=ios" \
     -F "title=鹿管家" \
     -F "appCode=person" \
     -F "version=2.6.1" \
     -F "versionMust=2.5.0" \
     -F "content=更新" \
     http://dev.bsi.luguanjia.com/server/appUpdate/save
    #  http://dev.api.luguanjia.com/appUpdate/save
}


function uploadAppstore()
{
    echo "appstore 版本 上传appstore⬆️  ⬆️  ⬆️  ⬆️  ⬆️  ⬆️  ⬆️  ⬆️  ⬆️  ⬆️  ⬆️  ⬆️"
    cd ${ipaPath}

    alias altool='/Applications/Xcode.app/Contents/Applications/Application\ Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Versions/A/Support/altool'
    xcrun altool -v -f ${scheme}.ipa -u ${350442340@qq.com} -p ${AppleId_password} -t ios
    altool --upload-app -f ${scheme}.ipa -t ios -u ${350442340@qq.com} -p ${AppleId_password}
}

#删除ipa
function deleteIpa()
{
    # cd ${projectDirectory}
    # rm -rf ipa
    echo "没有删"
}

function start()
{
    starttime=`date +'%Y-%m-%d %H:%M:%S'`

    generateBuildNumber

    # 提交代码 可选
    # pushToGit
    archive
    if [ ${method} = "app-store" ]
    then
        echo "自己上传appstore吧...."
    else
        echo "上传蒲公英和自己服务器.... 可选"
        # uploadSelfServer
        # uploadAdhocPgy
    fi
    
    # 上传dsym 如bugly  可选
    # uploadDsym

    endtime=`date +'%Y-%m-%d %H:%M:%S'`

    echo "开始时间 : " ${starttime}
    echo "结束时间 : " ${endtime}
    echo "build = " ${new_build_number}
    echo "您有一个新的App版本，请及时更新👌 🔥 👌 🔥 💯 🔥 💯 🔥 💯 🔥 💯 👌 🔥 👌 🔥 💯 🔥 💯 🔥 💯 🔥 💯 🔥 💯 🔥 💯 🔥"
}

start












