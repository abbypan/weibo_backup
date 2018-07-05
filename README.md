# weibo_backup

weibo backup  自身微博备份

## install

perl, curl, firefox, sqlite3

## usage

login weibo.cn, get own uid and cookie 登录weibo.cn

法一：指定自身uid及firefox的cookie文件路径

perl weibo_backup.pl [UID] [Firefox-COOKIE-File]

    $ perl weibo_backup.pl 1111111111 ~/.mozilla/firefox/*.default/cookies.sqlite


法二：指定自身uid及cookie

perl weibo_backup.pl [UID] [COOKIE]

    $ perl weibo_backup.pl 1111111111 '_T_WM=11111111111111111111111111111111; ALF=1111111111; SCF=1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111; SUB=11111111111111111111111111111111111111111111111111111111111111111111111111111111111111; SUBP=1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111; SUHB=11111111111111'

## backup dir

    .
    ├── at @
    │   ├── comment 评论@
    │   └── weibo 微博@
    ├── attitude 点赞
    ├── comment  评论
    │   ├── receive 发出
    │   └── send 收到
    ├── fans 粉丝
    ├── fav 收藏
    ├── follow 关注
    ├── profile 微博
    

## windows环境说明

### 安装strawberryperl-portable

在 [strawberryperl](http://strawberryperl.com/releases.html) 下载Portable版本的perl，例如

http://strawberryperl.com/download/5.26.2.1/strawberry-perl-5.26.2.1-64bit-portable.zip

http://strawberryperl.com/download/5.26.2.1/strawberry-perl-5.26.2.1-32bit-portable.zip

解压缩到本地，假设目录为 D:\software\strawberry-perl

### 安装firefox-portable

在 [firefox-portable](https://portableapps.com/apps/internet/firefox_portable) 下载Portable版的Firefox

解压缩到本地，假设目录为 D:\software\FirefoxPortable

### 配置weibo_backup_windows.bat

运行FirefoxPortable目录下的FirefoxPortable.exe，打开weibo.cn，登录自身账号

点击 ＠我的　，可以看到地址栏 https://weibo.cn/at/weibo?uid=1111111

uid= 后面的一串数字即为自身账号的UID值

打开weibo_backup_windows.bat，修改前三行，分别为上述的perl-portable目录、firefox-portable目录、UID值，保存。

### 备份微博

运行FirefoxPortable目录下的FirefoxPortable.exe，打开weibo.cn，登录自身账号

双击 weibo_backup_windows.bat，即可自动备份，或增量备份
