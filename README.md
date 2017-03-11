# weibo_backup

weibo backup  自身微博备份

## install

curl

## usage

login weibo.cn, get own uid and cookie 登录weibo.cn，获取自身uid及cookie

perl weibo_backup.pl [UID] [COOKIE]

## backup dir

    .
    ├── at @
    │   ├── comment 评论@
    │   └── weibo 微博@
    ├── attitude 点赞
    ├── comment  评论
    │   ├── receive 发出
    │   └── send 收到
    ├── fav 收藏
    ├── profile 微博
