# fwechat
flutter 高仿微信，内置gpt功能，多平台（ios，android，mac）支持

# 功能
内置十个小人陪你聊天，他们可以回答任何问题，聊天记录会保存在本地

# 环境
Flutter (Channel stable, 3.0.0, on macOS 13.4.1 22F770820d darwin-x64, locale zh-Hans-CN)

Dart SDK version: 2.17.0 (stable) (Mon May 9 10:36:47 2022 +0200) on "macos_x64"

pod version 1.12.1

ruby 3.2.2

# API KEY
API KEY 需要自己去OPENAI 注册，app 不提供

# 封面
<div style="display:flex;">
    <img src="https://github.com/hzfanfei/fwechat/assets/46393998/def61db3-14cd-4adf-ab5a-cb93375fd9f0" style="width:25%;" />
    <img src="https://github.com/hzfanfei/fwechat/assets/46393998/f7f19152-3964-48c4-ab0b-899c6d546ce3" style="width:25%;" />
    <img src="https://github.com/hzfanfei/fwechat/assets/46393998/b2b7a533-2405-4e47-9d0c-8aff3b77ffaf" style="width:25%;" />
    <img src="https://github.com/hzfanfei/fwechat/assets/46393998/532ae849-14c4-486a-b457-ca3414c3aaef" style="width:25%;" />
    <img src="https://github.com/hzfanfei/fwechat/assets/46393998/5703f7cf-8ecb-41cc-8e59-c9049e4a36de" style="width:25%;" />
    <img src="https://github.com/hzfanfei/fwechat/assets/46393998/77dd52fb-ca1d-43cf-95c3-da4ffe69b5bc" style="width:25%;" />
</div>

# 技术栈
Future 异步控制
hive: 完成聊天记录的本地存储
dio: 完成AI聊天服务的请求
shared_preferences: 完成API KEY的存储

# 后期
完成上下文相关
定制化小人
增加自定义小人
