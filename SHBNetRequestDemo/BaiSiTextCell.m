//
//  BaiSiTextCell.m
//  SHBNetRequestDemo
//
//  Created by shenhongbang on 16/6/6.
//  Copyright © 2016年 shenhongbang. All rights reserved.
//

#import "BaiSiTextCell.h"

@implementation BaiSiTextCell {
    UILabel     *_label;
    UIView      *_line;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        _label.translatesAutoresizingMaskIntoConstraints = false;
        _label.textColor = [UIColor grayColor];
        _label.font = [UIFont systemFontOfSize:15];
        _label.numberOfLines = 0;
        [self addSubview:_label];
        
        _line = [[UIView alloc] initWithFrame:CGRectZero];
        _line.translatesAutoresizingMaskIntoConstraints = false;
        _line.backgroundColor = [UIColor purpleColor];
        [self addSubview:_line];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_label, _line);
        NSDictionary *me = @{@"one" : @(1 / [UIScreen mainScreen].scale)};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_label]-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_line]|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_label][_line(one)]|" options:0 metrics:me views:views]];
        
    }
    return self;
}

- (void)configModel:(BaiSiModel *)model {
    _label.text = model.text;
}

@end
