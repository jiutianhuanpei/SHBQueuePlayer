//
//  BaiSiModel.m
//  SHBNetRequestDemo
//
//  Created by shenhongbang on 16/6/6.
//  Copyright © 2016年 shenhongbang. All rights reserved.
//

#import "SHBModel.h"

@implementation SHBModel



@end

@implementation BaiSiModel

- (NSString *)text {
    
    _text = [_text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    _text = [NSString stringWithFormat:@"\n%@\n", _text];
    return _text;
}

@end

@implementation QQModel

- (NSURL *)downURL {
    return [NSURL URLWithString:_downUrl];
}

- (NSURL *)URL {
    return [NSURL URLWithString:_url];
}

@end