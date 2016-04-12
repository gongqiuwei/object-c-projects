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
		
		- 文字属性设定(单一设定)
		
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
		
		- 文字属性设定（appearance对象设定）
		
		使用appearance对象设定，是一次性的设定，之后所有UITabBarItem对象都拥有相同的属性，哪些属性能够设定的前提条件是，在头文件中能够找到`UI_APPEARANCE_SELECTOR`宏，其他可以以此类推
		
		```objc
		// 示例
		- (void)setTitleTextAttributes:(nullable NSDictionary<NSString *,id> *)attributes forState:(UIControlState)state NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
		```
		
		appearance设定
		
		```objc
		// 获取当前对象的appearance
		UITabBarItem *item = [UITabBarItem appearance];
		// 设定普通状态
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attr[NSForegroundColorAttributeName] = [UIColor grayColor];
    [item setTitleTextAttributes:attr forState:UIControlStateNormal];
    // 设定选中状态
    NSMutableDictionary *selectAttr = [NSMutableDictionary dictionary];
    selectAttr[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    selectAttr[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    [item setTitleTextAttributes:selectAttr forState:UIControlStateSelected];
		```
		
	- 重构之方法抽取
	
	每个子控制器的创建代码都差不多,因此我们需要抽取一个公共方法,方法的设定有以下2种可供选择
	
	```objc
	// 方法一
	- (void)setupChildVcWithClass:(Class)childVcClass title:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage
{
    UIViewController *childVc = [[childVcClass alloc] init];
    childVc.view.backgroundColor = [self randomColor];
    childVc.tabBarItem.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [UIImage imageNamed:selectImage];
    
    [self addChildViewController:childVc];
}
	// 方法二
	- (void)setupChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage
{
    childVc.view.backgroundColor = [self randomColor];
    childVc.tabBarItem.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [UIImage imageNamed:selectImage];
    
    [self addChildViewController:childVc];
}
	```
	
	对比2个方法, 方法一种提供viewController的类型,使用alloc init创建子控制器,在当前的环境下有一定的局限性,因为外部子控制器的创建方式多样,进行限定的话,那么外面子控制器只能通过重写init方法进行个性化定制(如tableviewController的样式等),因此,可以由外面创建好了再传入进行公共的设定,所以选择方法二