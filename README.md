Web337Example SDK.1.0.7
==============

1.使用web337 sdk 请将 web337.bundle和 web337.framework 拖入项目中

2.```#import <web337/web337.h>```

3.打开Facebook登录，请使用最新的Facebook sdk，根据fb文档完成plist中的设置，在AppDelegate中覆盖相应的方法。以上配置和代码可以参考Example代码

4.api请参考 web337/web337.h中引用的头文件

5.自动生成文档在web337.doc 下

6.TalkingData接入请参考TalkingGame+iOS+接入指南+2.1.0,完成设置框架依赖。
	(1)统计的ID请运营人员索要；
	(2)在application：didFinishLaunchingWithOptions中执行
	[ElxWeb337 onStart:appid];
	(3)如果游戏分服，在用户信息返回之后执行[elx337 setGameServer:server];设置服信息
	

更新历史：

2014.4.16
将facebook 取loginkey的流程统一

2014.4.14
接入talkingData

2014.01.03
在logout方法执行之后 也清空Facebook的session缓存，实现流程统一

2013.12.18
更新了login和openRegister方法，修正了flash开发时屏幕方向问题。

2013.12.11
ios5下，模拟器在未设置过语言的情况下调用取语言函数会返回空数组，形成数组越界导致崩溃。真机未测试

2013.12.09
增加了行云统计功能

2013.11.27
解决了依赖库有可能冲突的问题
包括
MBProgressHUD
OHURLLoader
SZJsonParser

2013.11.20

1.保存上一次成功登陆的username（仅337用户），并在打开login的时候自动填入

2.修改控制关闭按钮逻辑

2013.11.01

1.增加关闭按钮触摸面积

2.界面优化

3.增加 debug 属性，可以打开或关闭 控制台日志


2013.10.29

1.facebook登陆回调方法间歇冻屏


2013.10.28

1.用户名输出入框中限定键盘类型，防止选中手写输入而挡住注册按钮。

2.注册按钮的UI调整，字体颜色和图片位置


2013.10.28

1.iphone横屏时，键盘弹出后会上移注册登录按钮。

2.重命名register方法为openRegister.

3.注册登录方法中增加withCloseButton参数，用来指定是否包含关闭按钮


Facebook接入问题
=======

1.参考文档 https://developers.facebook.com/docs/ios/getting-started/

2.FacebookSDK 在本文件所在同目录下 

3.plist中需要填写 FacebookAppID，FacebookDisplayName和URL Schemes。请参考SDK的示例项目

4.在UIApplicationDelegate中写下[FBSession.activeSession handleOpenURL:url];

5.Facebook用户登陆返回的用户信息中type字段值为ElxUser_FACEBOOK。并且字段中不包含username.如果需要显示可使用nickname，如果需要建立唯一索引请基于uid。

6.Facebook用户登陆之后elx337.loginkey并不会赋值。可以通过调用[[FBSession activeSession]accessTokenData]来获得Facebook平台的AccessToken。根据AccessToken来向facebook查询用户属性。请求地址为：https://graph.facebook.com/me?access_token=$access_token

