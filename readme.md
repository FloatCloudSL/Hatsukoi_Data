###### Hatsukoi使用文档
#### 感谢
[GitHub](https://github.com/mamoe/mirai "Mirai")
[GitHub](https://github.com/Dice-Developer-Team/Dice "Dice!")
#### 快速上手
[Dice!](https://forum.kokona.tech/ "Dice!官方论坛")
[Dice!](https://v2docs.kokona.tech/zh/latest/ "Dice!官方文档")
#### 跳过这些，你还可以看这个...
### Hatsukoi常用指令（包括插件指令）
## Dice! 指令 
.help    //查看基本信息
.jrrp    //查看你今天的人品数值
.r       //roll点数,Hatsukoi目前是百面骰
.dnd     //随机生成你的Dungeons & Dragons英雄作成
.coc     //随机生成你的Call of Cthulhu调查员作成
.send [反馈给Master的信息] //将消息发送给Master
.welcome [欢迎词] //每有新人入群时将发送欢迎词
.draw [牌堆名称] ([抽牌数量]) //不放回地抽牌；抽牌数量不能超过牌堆数量（牌堆列表后面会写）
## 插件指令
# 搜歌
[GitHub](https://github.com/khjxiaogu/MiraiSongPlugin "用mirai机器人搜索音乐并以卡片的形式分享")
#音乐 关键词  //自动搜索所有源以找出来找最佳音频来源
#语音 关键词  //自动搜索所有源，以语音信息的形式发出
#外链 关键词  //自动搜索所有源，以外链信息的形式发出
#QQ 关键词    //搜索QQ音乐
#网易 关键词  //搜索网易云音乐
#酷狗 关键词  //搜索酷狗音乐
#千千 关键词  //搜索千千音乐（百度音乐）
#点歌 来源 外观 关键词

# 蛇图
[GitHub](https://github.com/Samarium150/mirai-console-lolicon "基于mirai-console的涩图机器人")
/lolicon help
获取帮助信息

/lolicon get [keyword]
根据关键字发送涩图, 不提供关键字则随机发送一张
默认的冷却时间和撤回时间由配置文件决定

/lolicon set <property> <value>
设置属性和对应的值
群聊模式仅限群主和管理员使用
可设置的属性和值:

apikey
对应值: default/正确的apikey
效果: 重置apikey或设置apikey的值，私聊模式也可以更改
私聊限制: 无, 所有用户都可以设置, 但本插件不会检查apikey的可用性
r18
对应值: 0/1/2
效果: 将模式设置为non-R18/R18/mixed
私聊限制: 仅限由所有者添加的受信任用户使用
recall
对应值: 以秒为单位的小于120的非负整数
效果: 设置自动撤回的时间, 0则不撤回
私聊限制: 仅限由所有者添加的受信任用户使用
cooldown
对应值: 以秒为单位的小于120的非负整数
效果: 设置get命令的冷却时间, 0则无冷却
私聊限制: 仅限由所有者添加的受信任用户使用
/lolicon trust <id>
将对应的用户添加到受信任清单
仅限Bot所有者使用

/lolicon distrust <id>
将对应的用户从受信任清单中移除
仅限Bot所有者使用
