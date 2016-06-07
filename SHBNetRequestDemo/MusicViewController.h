//
//  MusicViewController.h
//  SHBNetRequestDemo
//
//  Created by shenhongbang on 16/6/6.
//  Copyright © 2016年 shenhongbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBModel.h"

@interface MusicViewController : UIViewController

//- (instancetype)initWithMusics:(NSArray <QQModel *>*)musics index:(NSInteger)index;

@property (nonatomic, strong) NSArray <QQModel *>     *musics;
@property (nonatomic, assign) NSInteger               index;

+ (MusicViewController *)defaultController;

@end
