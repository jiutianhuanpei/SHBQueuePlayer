//
//  SHBNetManager.m
//  SHBNetRequestDemo
//
//  Created by shenhongbang on 16/6/6.
//  Copyright © 2016年 shenhongbang. All rights reserved.
//

#import "SHBNetManager.h"

@interface SHBNetManager ()<NSURLSessionDelegate>

@end

@implementation SHBNetManager {
    NSURLSession    *_session;
    
    NSOperationQueue    *queue;
}

+ (SHBNetManager *)defaultManager {
    static SHBNetManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SHBNetManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            queue = [[NSOperationQueue alloc] init];
        });
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:queue];
        
    }
    return self;
}

- (void)POST:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:path] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    request.HTTPMethod = @"POST";
    
    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    if ([NSJSONSerialization isValidJSONObject:parameters]) {
        
        NSError *error = nil;
        NSData *body = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&error];
        if (error != nil) {
            if (failure) {
                failure(error);
            }
            return;
        }
        
        request.HTTPBody = body;
        
        NSURLSessionDataTask *dataTask = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                if (failure) {
                    failure(error);
                }
            } else {
                
                NSError *ee = nil;
                NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&ee];
                if (ee != nil) {
                    if (failure) {
                        failure(ee);
                    }
                } else {
                    if (success) {
                        success(obj);
                    }
                }
            }
        }];
        [dataTask resume];
        
    }
}

- (void)GET:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (NSString *key in parameters) {
        [array addObject:[NSString stringWithFormat:@"%@=%@", key, parameters[key]]];
    }
    NSString *parString = [array componentsJoinedByString:@"&"];
    NSString *url = [NSString stringWithFormat:@"%@?%@", path, parString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    request.HTTPMethod = @"GET";
    
    NSURLSessionDataTask *dataTask = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            if (failure) {
                failure(error);
            }
            return ;
        } else {
            NSError *ee = nil;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&ee];
            if (ee != nil) {
                if (failure) {
                    failure(ee);
                }
            } else {
                if (success) {
                    success(dic);
                }
            }
        }
    }];
    [dataTask resume];
    
    
}

- (void)baisi:(BaiSiType)type page:(NSInteger)page success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    NSString *path = @"http://route.showapi.com/255-1";
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithCapacity:0];
    if (type != BaiSiTypeAll) {
        tempDic[@"type"] = [NSString stringWithFormat:@"%ld", (long)type];
    }
    
    tempDic[@"page"] = [NSString stringWithFormat:@"%ld", (long)page == 0 ? 1 : page];
    
    NSMutableDictionary *dddic = [self authDic:tempDic];
    
    [self GET:path parameters:dddic success:^(id object) {
        if (success) {
            success(object);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)QQWithType:(NSInteger)type success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSDictionary *dic = @{@"topid" : [NSString stringWithFormat:@"%ld", (long)type]};
    NSDictionary *param = [self authDic:dic];
    
    [self GET:@"http://route.showapi.com/213-4" parameters:param success:^(id object) {
        if (success) {
            success(object);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (NSMutableDictionary *)authDic:(NSDictionary *)dic {
    NSDictionary *par = @{ @"showapi_sign" : @"d8979964f228405884796713256b7a46", @"showapi_appid" : @"20112"};
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:par];
    [tempDic setValuesForKeysWithDictionary:dic];
    return tempDic;
}


#pragma mark - NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error {
    
}

@end
