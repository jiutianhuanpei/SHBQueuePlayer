//
//  MusicViewController.m
//  SHBNetRequestDemo
//
//  Created by shenhongbang on 16/6/6.
//  Copyright © 2016年 shenhongbang. All rights reserved.
//

#import "MusicViewController.h"
#import "SHBQueuePlayer.h"

const CGFloat imgW = 260;

@interface MusicViewController ()<SHBQueuePlayerDelegate>

@property (nonatomic, strong) UILabel       *musicName;
@property (nonatomic, strong) UILabel       *singerName;

@property (nonatomic, strong) UIImageView   *imgView;

@property (nonatomic, strong) UISlider      *progress;

@property (nonatomic, strong) UILabel       *currentLabel;
@property (nonatomic, strong) UILabel       *totalLabel;

@property (nonatomic, strong) UIButton      *lastBtn;
@property (nonatomic, strong) UIButton      *playBtn;
@property (nonatomic, strong) UIButton      *nextBtn;


@end

@implementation MusicViewController


+ (MusicViewController *)defaultController {
    static MusicViewController *music = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        music = [[MusicViewController alloc] init];
    });
    return music;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self.navigationController.navigationBar.subviews firstObject] setAlpha:0];
    [self reloadUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"< Back" style:UIBarButtonItemStylePlain target:self action:@selector(disMiss)];
    
    //UI
    
    [self.view addSubview:self.musicName];
    [self.view addSubview:self.singerName];
    [self.view addSubview:self.imgView];
    [self.view addSubview:self.progress];
    [self.view addSubview:self.currentLabel];
    [self.view addSubview:self.totalLabel];
    [self.view addSubview:self.lastBtn];
    [self.view addSubview:self.playBtn];
    [self.view addSubview:self.nextBtn];
    
    
    id top = self.topLayoutGuide;
    NSDictionary *views = NSDictionaryOfVariableBindings(top, _musicName, _singerName, _imgView, _progress, _currentLabel, _totalLabel, _lastBtn, _playBtn, _nextBtn);
    NSDictionary *metrics = @{@"imgW" : @(imgW)};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_musicName]-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_singerName]-|" options:0 metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_imgView(imgW)]" options:NSLayoutFormatAlignAllCenterX metrics:metrics views:views]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_imgView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_currentLabel]-[_progress]-[_totalLabel]-|" options:0 metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-30-[_lastBtn]-(>=0)-[_playBtn]-(>=0)-[_nextBtn]-30-|" options:0 metrics:nil views:views]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_playBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    
    //V
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[top]-40-[_musicName]-15-[_singerName]-30-[_imgView(imgW)]-(>=0)-[_progress]-50-[_lastBtn]-40-|" options:0 metrics:metrics views:views]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_currentLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_progress attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_totalLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_progress attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_playBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lastBtn attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_nextBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lastBtn attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"mm:ss"];
    
    
    SHBQueuePlayer *player = [SHBQueuePlayer defaultManager];
    player.delegate = self;
    player.progress = ^(NSTimeInterval current, NSTimeInterval total) {
        if (total > 0) {
            [_progress setValue:current / total animated:true];
            _currentLabel.text = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:current]];
            _totalLabel.text = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:total]];
            
            _imgView.transform = CGAffineTransformRotate(_imgView.transform, 0.02);
            
        } else {
            _progress.value = 0;
            _currentLabel.text = @"00:00";
            _totalLabel.text = @"00:00";
        }
        
    };
    
    NSMutableArray *urls = [_musics valueForKeyPath:@"@unionOfObjects.URL"];
    [player setUrls:urls index:_index];
    [player play];
    
}

- (void)reloadUI {
    
    if (_index < _musics.count && _index >= 0) {
        QQModel *qq = _musics[_index];
        _musicName.text = qq.songname;
        _singerName.text = qq.singername;
        
        NSURL *url = [NSURL URLWithString:qq.albumpic_big];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        _imgView.image = image;
        
    }
    SHBQueuePlayer *player = [SHBQueuePlayer defaultManager];
    _playBtn.selected = player.isPlaying;
    
}

- (IBAction)chooseLastSong:(id)sender {
    SHBQueuePlayer *player = [SHBQueuePlayer defaultManager];
    [player lastItem];
    _index--;
    [self reloadUI];
}


- (IBAction)clickedPlayBtn:(UIButton *)sender {
    
    SHBQueuePlayer *player = [SHBQueuePlayer defaultManager];
    
    if (!sender.selected) {
        [player play];
    } else {
        [player pause];
    }
    sender.selected = !sender.selected;
}

- (IBAction)chooseNextSong:(id)sender {
    SHBQueuePlayer *player = [SHBQueuePlayer defaultManager];
    [player nextItem];
    
    _index++;
    [self reloadUI];
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

#pragma mark - SHBQueuePlayerDelegate
- (void)queuePlayerEndPlayed:(AVPlayerItem *)item {
    [self chooseNextSong:nil];
}


#pragma mark - getter & setter
- (void)setIndex:(NSInteger)index {
    _index = index;
    SHBQueuePlayer *player = [SHBQueuePlayer defaultManager];
    [player setUrls:[_musics valueForKeyPath:@"@unionOfObjects.URL"] index:_index];
    [player play];
    [self reloadUI];
}

- (UILabel *)musicName {
    if (_musicName == nil) {
        _musicName = [[UILabel alloc] initWithFrame:CGRectZero];
        _musicName.translatesAutoresizingMaskIntoConstraints = false;
        _musicName.textAlignment = NSTextAlignmentCenter;
        _musicName.adjustsFontSizeToFitWidth = true;
    }
    return _musicName;
}

- (UILabel *)singerName {
    if (_singerName == nil) {
        _singerName = [[UILabel alloc] initWithFrame:CGRectZero];
        _singerName.translatesAutoresizingMaskIntoConstraints = false;
        _singerName.textAlignment = NSTextAlignmentCenter;

    }
    return _singerName;
}

- (UIImageView *)imgView {
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imgView.translatesAutoresizingMaskIntoConstraints = false;
        _imgView.layer.cornerRadius = imgW / 2.;
        _imgView.layer.masksToBounds = true;
    }
    return _imgView;
}

- (UISlider *)progress {
    if (_progress == nil) {
        _progress = [[UISlider alloc] initWithFrame:CGRectZero];
        _progress.translatesAutoresizingMaskIntoConstraints = false;
    }
    return _progress;
}

- (UILabel *)currentLabel {
    if (_currentLabel == nil) {
        _currentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _currentLabel.translatesAutoresizingMaskIntoConstraints = false;
        _currentLabel.font = [UIFont systemFontOfSize:11];
        _currentLabel.textColor = [UIColor redColor];
    }
    return _currentLabel;
}

- (UILabel *)totalLabel {
    if (_totalLabel == nil) {
        _totalLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _totalLabel.translatesAutoresizingMaskIntoConstraints = false;
        _totalLabel.font = [UIFont systemFontOfSize:11];
        _totalLabel.textColor = [UIColor redColor];
    }
    return _totalLabel;
}

- (UIButton *)lastBtn {
    if (_lastBtn == nil) {
        _lastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _lastBtn.translatesAutoresizingMaskIntoConstraints = false;
        [_lastBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_lastBtn setTitle:@"上一首" forState:UIControlStateNormal];
        [_lastBtn addTarget:self action:@selector(chooseLastSong:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lastBtn;
}

- (UIButton *)playBtn {
    if (_playBtn == nil) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playBtn.translatesAutoresizingMaskIntoConstraints = false;
        [_playBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_playBtn setTitle:@"播放" forState:UIControlStateNormal];
        [_playBtn setTitle:@"暂停" forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(clickedPlayBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UIButton *)nextBtn {
    if (_nextBtn == nil) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBtn.translatesAutoresizingMaskIntoConstraints = false;
        [_nextBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_nextBtn setTitle:@"下一首" forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(chooseNextSong:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}



@end
