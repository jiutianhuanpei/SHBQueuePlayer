//
//  RootViewController.m
//  SHBNetRequestDemo
//
//  Created by shenhongbang on 16/6/6.
//  Copyright © 2016年 shenhongbang. All rights reserved.
//

#import "RootViewController.h"
#import "BaiSiViewController.h"
#import "QQViewController.h"
#import "MovieViewController.h"


@interface RootViewController ()


@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    BaiSiViewController *baisi = [[BaiSiViewController alloc] init];
    baisi.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"BaiSi" image:nil tag:100];
    
    QQViewController *qq = [[QQViewController alloc] init];
    UINavigationController *qqNa = [[UINavigationController alloc] initWithRootViewController:qq];
    qqNa.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"音乐" image:nil tag:101];
    
    MovieViewController *movice = [[MovieViewController alloc] init];
    movice.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"视频" image:nil tag:102];
    
    
    self.viewControllers = @[qqNa, baisi, movice];
    
    
    
}

@end
