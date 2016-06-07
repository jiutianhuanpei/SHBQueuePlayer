//
//  QQViewController.m
//  SHBNetRequestDemo
//
//  Created by shenhongbang on 16/6/6.
//  Copyright © 2016年 shenhongbang. All rights reserved.
//

#import "QQViewController.h"
#import "SHBNetManager.h"
#import "SHBModel.h"
#import <MJExtension.h>
#import "MusicViewController.h"
#import "MovieViewController.h"

@interface QQViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) UIRefreshControl  *refresh;


@end

@implementation QQViewController {
    NSMutableArray      *_dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Music" style:UIBarButtonItemStylePlain target:self action:@selector(gotoMusic)];
    
    [self.view addSubview:self.tableView];
    id top = self.topLayoutGuide;
    id bottom = self.bottomLayoutGuide;
    NSDictionary *views = NSDictionaryOfVariableBindings(top, _tableView, bottom);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_tableView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[top][_tableView][bottom]|" options:0 metrics:nil views:views]];
    
    
//    [self.refresh beginRefreshing];
    [self getDataWithType:5];
}

- (void)gotoMusic {
    MusicViewController *music = [MusicViewController defaultController];
    if (music.musics.count == 0) {
        return;
    }
    UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:music];
    [self presentViewController:na animated:true completion:nil];
}

- (void)getDataWithType:(NSInteger)type {
    SHBNetManager *manager = [SHBNetManager defaultManager];
    
    [manager QQWithType:type success:^(id object) {
        [_refresh endRefreshing];

        NSDictionary *body = object[@"showapi_res_body"];
        if (body == nil) {
            return ;
        }
        
        NSDictionary *pageBean = body[@"pagebean"];
        if (pageBean == nil) {
            return;
        }
        NSArray *list = pageBean[@"songlist"];
        NSLog(@"list:%@", list);
        [_dataArray removeAllObjects];
        for (NSDictionary *dic in list) {
            QQModel *qq = [QQModel mj_objectWithKeyValues:dic];
            
            [_dataArray addObject:qq];
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
        
    } failure:^(NSError *error) {
        [_refresh endRefreshing];
        NSLog(@"error:%@", error);
    }];
}

- (void)getData:(UIRefreshControl *)re {
    [self getDataWithType:5];
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    
    QQModel *qq = _dataArray[indexPath.row];
    cell.textLabel.text = qq.singername.length > 0 ? [NSString stringWithFormat:@"%@-%@", qq.songname, qq.singername] : qq.songname;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicViewController *music = [MusicViewController defaultController];
    music.musics = _dataArray;
    music.index = indexPath.row;
    
    
    UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:music];
    [self presentViewController:na animated:true completion:nil];
    
}


#pragma mark - getter
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.translatesAutoresizingMaskIntoConstraints = false;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 44;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        
        [_tableView addSubview:self.refresh];
    }
    return _tableView;
}

- (UIRefreshControl *)refresh {
    if (_refresh == nil) {
        _refresh = [[UIRefreshControl alloc] init];
        [_refresh addTarget:self action:@selector(getData:) forControlEvents:UIControlEventValueChanged];
    }
    return _refresh;
}

@end
