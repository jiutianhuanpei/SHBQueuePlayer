//
//  SHBNetManager.h
//  SHBNetRequestDemo
//
//  Created by shenhongbang on 16/6/6.
//  Copyright © 2016年 shenhongbang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BaiSiType) {
    BaiSiTypeAll = 0,
    BaiSiTypeImage = 10,
    BaiSiTypeText = 29,
    BaiSiTypeVoice = 31,
    BaiSiTypeVideo = 41,
};


@interface SHBNetManager : NSObject

+ (SHBNetManager *)defaultManager;

- (void)POST:(NSString *)path parameters:(NSDictionary *)parameters success:(void(^)(id object))success failure:(void(^)(NSError *error))failure;
- (void)GET:(NSString *)path parameters:(NSDictionary *)parameters success:(void(^)(id object))success failure:(void(^)(NSError *error))failure;


- (void)baisi:(BaiSiType)type page:(NSInteger)page success:(void(^)(id object))success failure:(void(^)(NSError *error))failure;

/**
 * 
 榜行榜id
 3=欧美
 5=内地
 6=港台
 16=韩国
 17=日本
 18=民谣
 19=摇滚
 23=销量
 26=热歌
 */
- (void)QQWithType:(NSInteger)type success:(void(^)(id object))success failure:(void(^)(NSError *error))failure;


@end
