# weibo_backup

weibo backup  自身微博备份

## install

curl, firefox, sqlite3

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
    
