//
//  BaiSiViewController.m
//  SHBNetRequestDemo
//
//  Created by shenhongbang on 16/6/6.
//  Copyright © 2016年 shenhongbang. All rights reserved.
//

#import "BaiSiViewController.h"
#import "SHBNetManager.h"
#import "SHBModel.h"
#import "BaiSiTextCell.h"
#import <MJExtension/MJExtension.h>


@interface BaiSiViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView   *tableView;


@end

@implementation BaiSiViewController {
    NSMutableArray      *_dataArray;
    
    NSInteger           _page;
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    _page = 1;
    
    //百思
    //http://route.showapi.com/255-1
    //showapi_appid : 20102
    //showapi_sign : 99ed012af986487a999f336fff6e5e09
    
    [self.view addSubview:self.tableView];
    
    [self getMoreData:false success:^{
        [_tableView reloadData];
    }];
}

- (void)getMoreData:(BOOL)more success:(void(^)())success {
    if (more) {
        _page++;
    } else {
        _page = 1;
    }
    
    
    SHBNetManager *manager = [SHBNetManager defaultManager];
    [manager baisi:BaiSiTypeText page:_page success:^(id object) {
        
        NSDictionary *body = object[@"showapi_res_body"];
        if (body == nil) {
            return ;
        }
        
        NSDictionary *pageBean = body[@"pagebean"];
        if (pageBean == nil) {
            return;
        }
        
        //        NSInteger allNum = [pageBean[@"allNum"] integerValue];
        //        NSInteger allPages = [pageBean[@"allPages"] integerValue];
        //        NSInteger currentPage = [pageBean[@"currentPage"] integerValue];
        //        NSInteger maxResult = [pageBean[@"maxResult"] integerValue];
        NSArray *contentList = pageBean[@"contentlist"];
        
        if (!more) {
            [_dataArray removeAllObjects];
        }
        
        //        NSArray *texts = [contentList valueForKeyPath:@"@unionOfObjects.text"];
        //        NSLog(@"\n*****************第%ld页*********************\n%@",(long) currentPage, texts);
        
        for (NSDictionary *dic in contentList) {
            NSString *create_time = dic[@"create_time"];
            NSInteger hate = [dic[@"hate"] integerValue];
            CGFloat height = [dic[@"height"] floatValue];
            NSInteger iid = [dic[@"id"] integerValue];
            NSString *image0 = dic[@"image0"];
            NSString *image1 = dic[@"image1"];
            NSString *image2 = dic[@"image2"];
            NSString *image3 = dic[@"image3"];
            NSInteger love = [dic[@"love"] integerValue];
            NSString *name = dic[@"name"];
            NSString *profile_image = dic[@"profile_image"];
            NSString *text = dic[@"text"];
            BaiSiType type = [dic[@"type"] integerValue];
            NSString *video_uri = dic[@"video_uri"];
            NSTimeInterval videotime = [dic[@"videotime"] doubleValue];
            NSString *voice_uri = dic[@"voice_uri"];
            NSTimeInterval voicetime = [dic[@"voicetime"] doubleValue];
            NSString *voiceuri = dic[@"voiceuri"];
            NSString *voicelength = dic[@"voicelength"];
            NSString *weixin_url = dic[@"weixin_url"];
            CGFloat width = [dic[@"width"] floatValue];
            
            BaiSiModel *model = [[BaiSiModel alloc] init];
            model.createTime = create_time;
            model.hate = hate;
            model.height = height;
            model.iid = iid;
            model.image0 = image0;
            model.image1 = image1;
            model.image2 = image2;
            model.image3 = image3;
            model.love = love;
            model.name = name;
            model.profile_image = profile_image;
            model.text = text;
            model.type = type;
            model.video_uri = video_uri;
            model.videotime = videotime;
            model.voiceuri = voiceuri;
            model.voice_uri = voice_uri;
            model.voicetime = voicetime;
            model.voicelength = voicelength;
            model.weixin_url = weixin_url;
            model.width = width;
            
            [_dataArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                success();
            }
        });
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaiSiTextCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BaiSiTextCell class]) forIndexPath:indexPath];
    [cell configModel:_dataArray[indexPath.row]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _dataArray.count - 4) {
        [self getMoreData:true success:^{
            [_tableView reloadData];
        }];
    }
}


#pragma mark - getter
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 44;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[BaiSiTextCell class] forCellReuseIdentifier:NSStringFromClass([BaiSiTextCell class])];
    }
    return _tableView;
}


@end
