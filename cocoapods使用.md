# cocoapods

## 更换下载源
- Gem是一个管理ruby库和程序的标准包，它通过Ruby Gem（如：http://rubygems.org/）源来查找、安装、升级和卸载软件包
- gem sources --remove https://rubygems.org/ 
- gem sources -a https://ruby.taobao.org/
- gem sources -l

## 更新升级gem（以后出现问题，尝试这个）
- gem update --system
- 没登录的情况下需要 sudo gem update --system

## 安装
- gem install cocoapods
- 安装错误：
	- ERROR:  While executing gem ... (Errno::EPERM)
    Operation not permitted - /usr/bin/fuzzy_match
    - sudo gem install -n /usr/local/bin cocoapods
    

## 更换repo镜像为国内服务器
- pod repo remove master
- pod repo add master http://git.oschina.net/akuandev/Specs.git 
- pod repo add master https://gitcafe.com/akuandev/Specs.git   

## 初始化第三方库信息（以后出现问题，尝试这个）
- pod setup(第一次安装pod repo需要初始化)
- 如果时间比较长的话，可以考虑更换repo

## 以后更新第三方库信息
- pod repo update

## 搜索第三方库
- pod search 库名

## 新建podfile
- 打开工程项目所在目录
- vim Podfile
- 编辑文件：(格式固定)

	```
	platform :ios, '7.0'	
	pod 'SDWebImage','~> 3.7.2'
	```
	vim编辑常用命令： 
## 解析Podfile
- pod install (第一次解析podfile的时候可以使用这个命令安装第三方框架)
- pod update (升级第三方框架)

## 以后出现莫名其妙的问题可以尝试
- gem update --system  升级gem 
- gem install cocoapods 重新安装cocoapods
- pod setup 初始化pod的repo
