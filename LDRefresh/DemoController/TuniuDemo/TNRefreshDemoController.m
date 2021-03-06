//
//  TNRefreshDemoController.m
//  LDRefresh
//
//  Created by lidi on 11/12/15.
//  Copyright © 2015 lidi. All rights reserved.
//

#import "TNRefreshDemoController.h"
#import "TNRefreshFooterView.h"
#import "TNRefreshHeaderView.h"
#import "UIScrollView+LDRefresh.h"

@interface TNRefreshDemoController ()
//UI
@property (nonatomic, strong)   UITableView *tableView;

//Data
@property (nonatomic, assign) NSInteger data;
@end

@implementation TNRefreshDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)])
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.title = @"途牛旅游";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.height, [UIScreen mainScreen].bounds.size.height - 64)];
    _tableView.delegate = (id<UITableViewDelegate>)self;
    _tableView.dataSource = (id<UITableViewDataSource>) self;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_tableView];
    
    _data = 20;
    [self addRefreshView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_tableView.refreshHeader startRefresh];
}

- (void)addRefreshView {
    
    __weak __typeof(self) weakSelf = self;
    
    //下拉刷新
    _tableView.refreshHeader = [_tableView addRefreshHeader:[[TNRefreshHeaderView alloc] init]  handler:^{
        [weakSelf refreshData];
    }];
    
    //上拉加载更多
    _tableView.refreshFooter = [_tableView addRefreshFooter:[[TNRefreshFooterView alloc] init]  handler:^{
        [weakSelf loadMoreData];
    }];
//   _tableView.refreshFooter.autoLoadMore = NO;
}

- (void)refreshData {
    __weak __typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        _data = 20;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.refreshHeader endRefresh];
        
        weakSelf.tableView.refreshFooter.loadMoreEnabled = YES;
    });
}

- (void)loadMoreData {
    __weak __typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        _data += 20;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.refreshFooter endRefresh];
        
        weakSelf.tableView.refreshFooter.loadMoreEnabled = NO;
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuseIdentifier = @"reuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@-京东双11物流杠杆的！", @(indexPath.row)];
    return cell;
}
@end
