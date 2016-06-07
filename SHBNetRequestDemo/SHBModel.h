//
//  BaiSiModel.h
//  SHBNetRequestDemo
//
//  Created by shenhongbang on 16/6/6.
//  Copyright © 2016年 shenhongbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SHBNetManager.h"

@interface SHBModel : NSObject

@end

@interface BaiSiModel : NSObject

@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, assign) NSInteger hate;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) NSInteger iid;
@property (nonatomic, copy) NSString *image0;
@property (nonatomic, copy) NSString *image1;
@property (nonatomic, copy) NSString *image2;
@property (nonatomic, copy) NSString *image3;
@property (nonatomic, assign) NSInteger love;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *profile_image;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) BaiSiType type;
@property (nonatomic, copy) NSString *video_uri;
@property (nonatomic, assign) NSTimeInterval videotime;
@property (nonatomic, copy) NSString *voice_uri;
@property (nonatomic, assign) NSTimeInterval voicetime;
@property (nonatomic, copy) NSString *voiceuri;
@property (nonatomic, copy) NSString *voicelength;
@property (nonatomic, copy) NSString *weixin_url;
@property (nonatomic, assign) CGFloat width;


@end


@interface QQModel : NSObject

@property (nonatomic, copy) NSString *albumid;
@property (nonatomic, copy) NSString *albummid;
@property (nonatomic, copy) NSString *albumpic_big;
@property (nonatomic, copy) NSString *albumpic_small;
@property (nonatomic, copy) NSString *downUrl;
@property (nonatomic, strong, readonly) NSURL *downURL;
@property (nonatomic, copy) NSString *seconds;
@property (nonatomic, copy) NSString *singername;
@property (nonatomic, copy) NSString *singerid;

@property (nonatomic, copy) NSString *songid;
@property (nonatomic, copy) NSString *songname;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong, readonly) NSURL *URL;

@end




