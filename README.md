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

- 自定义TabBar
	- 更换tabBarController的tabBar

		```objc
		// readonly无法通过set方法设定,只能使用kvc
	// self.tabBar = [[GWTabBar alloc] init];
	    [self setValue:[[GWTabBar alloc] init] forKeyPath:@"tabBar"];
		```
		
	- 自定义tabBar(继承自UITabBar)
		- 重写`- (instancetype)initWithFrame:(CGRect)frame`以便添加其他的子控件
		
		- 重写`- (void)layoutSubviews`进行子控件的布局
			
			注意: tabBar中使用根据tabbarItem生产的系统控件的类型是UITabBarButton(可以使用View调试器查看,也可以NSLog调试)
			
			```objc
			- (void)layoutSubViews
			{
				[super layoutSubviews];
				
				// 发布按钮的尺寸(或者自己添加的其他子控件的布局)
			    self.publishButton.bounds = CGRectMake(0, 0, self.publishButton.currentBackgroundImage.size.width, self.publishButton.currentBackgroundImage.size.height);
			    self.publishButton.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height*0.5);
			    
			    // 其他UITabBarButton的尺寸(系统生成的子控件的布局)
			    CGFloat buttonY = 0;
			    CGFloat buttonW = self.frame.size.width / 5;
			    CGFloat buttonH = self.frame.size.height;
			    NSInteger index = 0;
			    for (UIView *button in self.subviews) {
			        if (![button isKindOfClass:NSClassFromString(@"UITabBarButton")]) continue;
			        
			        CGFloat buttonX = buttonW * (index > 1 ? (index + 1) : index);
			        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
			        
			        index ++;
			    }
			}
			```
	

- 项目pch文件集成
	- targets -> build settings -> 搜索prefix header -> 设定pch文件的路径(在当前项目的总目录下的相对路径,不是整个文件的绝对路径)
	
	- 对于一些常用的宏和分类,可以在pch文件中导入
	

- navigationItem的设定
	- title的不同设定
	
		给viewController设定title相当于同时给当前控制器的tabbarItem和navigationItem设定了title, 如果要2个地方的title不同,得分开设定
		
		```objc
		self.navigationItem.title = @"我的关注";
    	self.tabBarItem.title = @"我的";
    
    	// 相当于同时设定以上两项
    	// self.title = @"我的";
		```
		
	- navigationBar上的model之间的层级关系
		
		- UINavigationController -> viewControllers -> 子控制器的堆栈
		- UINavigationbar -> items -> 子控制器对应的UINavigationItem的堆栈 -> 每个navigationItem 有leftBarButtonItems, rightBarButtonItems, backBarButtonItem(对应的model是UIBarButtonItem)
		- 如果要想当前控制器所在的navigationItem添加控件,应该添加UIBarButtonItem (titleView除外)
	
	- UIBarButtonItem创建代码的封装

		2种方式: 分类; 继承
		
		分析:
		 - 对原有类的方法进行扩展,可以使用分类
		 - 对原有类的方法进行重写,可以使用继承
		
		当前的需求是原来所有的类的方法不够使用,需要多增加一个方法来快速创建UIBarButtonItem, 以减少重复的代码, 考虑使用分类
		