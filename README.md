# FYSwift
一个swift基础搭建

网络请求类:FYNetApi,基于MOYA的网络请求,根据自己的需求,修改FYNetAPI内容.
例如:
FYNetApi.shared.post(target: .login(account: account, code: code)) { (response) in
            let mode:FYLoginModel = try! response.map(FYLoginModel.self, atKeyPath: "data")
            print(mode.mobile as Any)
            }
基础设置:Config
   1,判断是否为iphonex 系列
   isPhoneX()
   2,//屏幕宽度:kScreenWidth
       屏幕高度:kScreenHeight
       tabBar高度:kTabBarHeight
       nav高度:   kNavBarHeight
       底部手势框的高度:kBottomLineHeight
   3,颜色:
         设置随机颜色:UIColorRandom()
         init(hexString: "")
   4,偏好设置存储
     FYUserInfo
   
       
