//
//  MovieViewController.m
//  SHBNetRequestDemo
//
//  Created by shenhongbang on 16/6/6.
//  Copyright © 2016年 shenhongbang. All rights reserved.
//

#import "MovieViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "MovieView.h"
#import "SHBQueuePlayer.h"

@interface MovieViewController ()

@end

@implementation MovieViewController {
    MovieView       *_videoView;
    
    NSArray         *_items;
    NSInteger       _index;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    SHBQueuePlayer *player = [SHBQueuePlayer defaultManager];
    [player setUrls:_items index:_index];

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    SHBQueuePlayer *player = [SHBQueuePlayer defaultManager];
    [player pause];
    [player setUrls:@[] index:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"< Back" style:UIBarButtonItemStylePlain target:self action:@selector(disMiss)];

    
    
    _videoView = [[MovieView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 300)];
    _videoView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_videoView];
    
    [self create:@"play" action:@selector(play:) y:350];
    [self create:@"next" action:@selector(next:) y:400];
    
    
    NSString *chidaohebeiji = @"http://main.gslb.ku6.com/s1/wPdFbrJ7V578E2bx/1228953319193/7d9963cd96e0fb1eda9623ec3a504c89/1459923636272/v517/30/27/GIZTEuhSQZOsfPJ1j2Lntg.mp4";
    
    _items = @[[NSURL URLWithString:chidaohebeiji], [NSURL URLWithString:chidaohebeiji], [NSURL URLWithString:chidaohebeiji]];
    _index = 0;
    
    SHBQueuePlayer *player = [SHBQueuePlayer defaultManager];
    [player setUrls:_items index:_index];

    
    AVPlayerLayer *layer = (AVPlayerLayer *)_videoView.layer;
    layer.player = player.queuePlayer;
    
}

- (void)play:(UIButton *)btn {
    SHBQueuePlayer *player = [SHBQueuePlayer defaultManager];

    
    if (!btn.selected) {
        [player play];
    } else {
        [player pause];
    }
    btn.selected = !btn.selected;
}

- (void)next:(UIButton *)btn {
    
    SHBQueuePlayer *player = [SHBQueuePlayer defaultManager];
    [player nextItem];
    _index++;
    if (_index == _items.count) {
        _index = 0;
    }
}


- (UIButton *)create:(NSString *)title action:(SEL)action y:(CGFloat)y {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    btn.center = CGPointMake(CGRectGetWidth(self.view.frame) / 2., y);
    [self.view addSubview:btn];
    return btn;
}


- (void)disMiss {
    if (self.presentingViewController == nil) {
        [self.navigationController popViewControllerAnimated:true];
    } else {
        [self dismissViewControllerAnimated:true completion:nil];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
