//
//  ViewController.m
//  微博个人详情页
//
//  Created by yz on 15/7/29.
//  Copyright (c) 2015年 yz. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+Utils.h"
// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

#define headH 200
#define headMinH 64
#define tabBarH 44

#import "UIImage+Image.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    CGFloat _navalpha;
}
@property (nonatomic, weak) UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headHCons;

@property (nonatomic, assign) CGFloat lastOffsetY;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    _lastOffsetY = -(headH + tabBarH);
    
    self.tableView.contentInset = UIEdgeInsetsMake(headH + tabBarH, 0, 0, 0);
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"hahahahaha";
    [nameLabel sizeToFit];
    self.navigationItem.titleView = nameLabel;
    _nameLabel = nameLabel;
    nameLabel.alpha = 0;

}

-(void)customGoBack{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID
                ];
        cell.backgroundColor = [UIColor redColor];
    }
    
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    CGFloat delta = offsetY - _lastOffsetY;
    
    // 往上拖动，高度减少。
    CGFloat height = headH - delta;
    
    if (height < headMinH) {
        height = headMinH;
    }
    
    _headHCons.constant = height;
    
    // 设置导航条的背景图片
    CGFloat alpha = delta / (headH - headMinH);
    
    // 当alpha大于1，导航条半透明，因此做处理，大于1，就直接=0.99
    if (alpha >= 1) {
        alpha = 0.99;
    }
    _nameLabel.alpha = alpha;
    _navalpha = alpha;
    NSLog(@"_nameLabel.alpha===%f",_nameLabel.alpha);
    // 设置导航条的背景图片
    UIImage *image = [UIImage imageWithColor:[UIColor colorWithRed:1.0 green:0.5 blue:0 alpha:alpha]];
    
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIImage *image = [UIImage imageWithColor:[UIColor colorWithRed:1.0 green:0.5 blue:0 alpha:_navalpha]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    // 隐藏底部阴影条，传递一个空图片的UIImage对象
//    [self.navigationController.navigationBar setShadowImage:image];
}


@end
