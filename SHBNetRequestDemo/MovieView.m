//
//  MovieView.m
//  SHBNetRequestDemo
//
//  Created by shenhongbang on 16/6/6.
//  Copyright © 2016年 shenhongbang. All rights reserved.
//

#import "MovieView.h"

@implementation MovieView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

//- (AVPlayer *)player {
//    AVPlayerLayer *layer = (AVPlayerLayer *)self.layer;
//    return layer.player;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
