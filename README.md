# object-c-projects

## 仿百思不得姐

### 第二天 我的关注模块
- 推荐关注界面

	- 小知识点:
		- xib 中对label的内容进行换行, 可以使用 option + 回车
		- 在有导航控制器的环境下,如果在viewController中的子控件中有scrollview及其子类的时候,需要注意系统可能默认会修改它的contentInsert, 可以在viewDidLoad中打印看看, 如果不需要系统进行修改,可以修改VC的属性:
		
			```objc
			self.automaticallyAdjustsScrollViewInsets = NO;
			```
			
		- tableviewcell在选中时会调用方法`- (void)setSelected:(BOOL)selected animated:(BOOL)animated`
		
		-  默认tableviewcell在选中时其内部的子控件进入heighlight的状态,但是如果cell的selectionStyle为none的时候,子控件在选中的时候不会进入heighlight状态
	- 

### 第一天 基本界面骨架搭建
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
		
- 设置全局的navigationItem的返回样式

	需求: 如果导航控制器push进去了一个控制器, 其左上角的返回样式要统一
	
	解决方式:
	  - 第一种: 每个控制器的viewDidLoad进行设置(太繁琐)
	  - 第二种: 导航控制器对子控制器的管理通过以下2个方法进行(navigationController的API中还提供了其他的方法供我们使用,但他们的底层都会调用以下方法)
	     - 进栈
	     `- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;`
	     - 出栈
	     `- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated;`
	     
	    因此,我们可以拦截push方法,在有新的控制器压入导航控制器的栈中的时候来对其返回按钮进行统一的设定, 实现这个思路就需要我们自定义导航控制器,重写其push方法进行拦截
	
	参考代码:
	
	```objc
	- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
	{
	    // 根控制器的左边返回按钮不用设定
	    if (self.viewControllers.count > 0) {
	        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	        // 设置图片
	        [backButton setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
	        [backButton setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
	        // 设置文字
	        [backButton setTitle:@"返回" forState:UIControlStateNormal];
	        [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	        [backButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
	        // 点击事件
	        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
	        // 尺寸设置(随意设置的,如果要完全紧贴,可以使用sizeToFit方法)
	        backButton.size = CGSizeMake(70, 30);
	        // 整体内容左对齐
	        backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	        // 由于系统布局,左边看起来还是有很多间隙,可以用contentEdgeInsets左移
	        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
	        
	        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
	        
	        // 隐藏tabbar
        	viewController.hidesBottomBarWhenPushed = YES;
	    }
	    
	    // 将super的代码放在后面,是为了如果viewController有自己的独特的返回按钮样式的时候,不会被覆盖掉
	    [super pushViewController:viewController animated:animated];
	}
	```