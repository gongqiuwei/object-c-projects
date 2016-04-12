# object-c-projects

## 仿百思不得姐

### 第一天
- 新建项目，并初始化启动图片、appIcon等
- 主框架界面搭建（自定义tabbarcontroller）
	- 子控制器的tabBarItem的设定
		- 图片（默认图片会被渲染成系统的颜色，需要手动设定）
		
		第一种方式，代码设定
		
		```objc
		UIImage *selectImage = [UIImage imageNamed:@"tabBar_essence_click_icon"];
    selectImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = selectImage;
		
		```
		第二种方式，在imageAsset中对图片进行属性设定
		
		```
		Render As 设定为 Original Image
		```
		
		- 文字属性设定
		
		```objc
		// 普通状态
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attr[NSForegroundColorAttributeName] = [UIColor grayColor];
    [vc1.tabBarItem setTitleTextAttributes:attr forState:UIControlStateNormal];
    // 选中状态
    NSMutableDictionary *selectAttr = [NSMutableDictionary dictionary];
    selectAttr[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    selectAttr[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    [vc1.tabBarItem setTitleTextAttributes:selectAttr forState:UIControlStateSelected];
    vc1.tabBarItem.title = @"精华";
		```