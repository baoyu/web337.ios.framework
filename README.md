web337 SDK for iOS
====================

web337SDK 用来提供iOS上的用户功能支持。

使用方法：</br>
将web337.framework 和 web337.bundle 拖入项目中即可

添加facebook登录:</br>

1.请下载最新版的facebook SDK,并添加到你的项目中</br>
2.按照[facebook官方文档](https://developers.facebook.com/docs/ios/getting-started/)的说明完成:</br>
* 2.1 正确配置FacebookAppID, FacebookDisplayName,URL Schemes
* 2.2 在初始化ElxWeb337之前 “[FBSession class];”</br>
* 2.3 

- (BOOL)application:(UIApplication *)application 
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication 
         annotation:(id)annotation 
{
    return [FBSession.activeSession handleOpenURL:url]; 
}



2013.10.21 更新内容

1.打包方式更新为 framework
2.界面布局修改
3.支持facebook登录


