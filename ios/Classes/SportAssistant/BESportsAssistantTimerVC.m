//
//  BESportsAssistantTimerVC.m
//  BEAlgorithm
//
//  Created by liqing on 2021/7/7.
//

#import "BESportsAssistantTimerVC.h"
#import "BEDeviceInfoHelper.h"
#import "Masonry.h"
#import <AVFoundation/AVFoundation.h>
#import "BEAlgorithmConfig.h"
#import "BEVideoSourceConfig.h"
#import "BEActionRecognitionAlgorithmTask.h"
#import "BESportsAssistantCountVC.h"
#import "BECommonUtils.h"
#import "BESportsAssistantVM.h"

#define iPhoneX [BEDeviceInfoHelper isIPhoneXSeries]

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface BESportsAssistantTimerVC ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, weak) id<UIGestureRecognizerDelegate> savedGestureDelegate;
@end

@implementation BESportsAssistantTimerVC
{
    UIView* _homepage;
    AVPlayer* _player;
    AVPlayerLayer* _playerLayer;
    UIPickerView * _timeView;
    NSMutableArray* _minutes;
    NSMutableArray* _seconds;
    UILabel *_myTimerLabel;
    UIButton* _playBtn;
    CGSize _videoSize;
    UIButton* _startBtn;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [BESportsAssistantVM instance].minute = 2;
    [BESportsAssistantVM instance].second = 0;
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)
    name:UIApplicationWillResignActiveNotification object:nil];

    
    _homepage = self.view;
    _homepage.backgroundColor = UIColor.whiteColor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.layer.masksToBounds=YES;
    label.layer.backgroundColor = [UIColor clearColor].CGColor;
    label.layer.borderWidth =1.0f;
    label.layer.borderColor = [UIColor clearColor].CGColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    label.textColor = [BECommonUtils colorWithHexString:@"#1D2129"];
    label.text = _classItem.name;
    [_homepage addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_homepage).mas_offset(iPhoneX ? 44 : 20);
        make.left.equalTo(_homepage);
        make.width.mas_equalTo(_homepage.bounds.size.width);
        make.height.mas_equalTo(label.bounds.size.height);
    }];
    
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 16, 16)];
    btn.backgroundColor = [UIColor clearColor];
    UIImage* icon = [UIImage imageNamed:@"ic_sa_back"];
    [btn setBackgroundImage:icon forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [_homepage addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_homepage).mas_offset(16);
        make.centerY.equalTo(label);
        make.width.mas_equalTo(btn.bounds.size.width);
        make.height.mas_equalTo(btn.bounds.size.height);
    }];
    
    UIButton* videoBg = [UIButton new];
    videoBg.backgroundColor = [UIColor blackColor];
    [videoBg addTarget:self action:@selector(videoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_homepage addSubview:videoBg];
    [videoBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_homepage);
        make.right.equalTo(_homepage);
        make.top.equalTo(label.mas_bottom);
        make.height.mas_equalTo(_homepage.bounds.size.width);
    }];
    
    {
        UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 56, 56)];
        btn.backgroundColor = [UIColor clearColor];
        UIImage* icon = [UIImage imageNamed:@"ic_sa_play"];
        [btn setBackgroundImage:icon forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(videoBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [videoBg addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(videoBg);
        }];
        _playBtn = btn;
        _playBtn.hidden = YES;
    }
    
    NSURL* pathUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:_classItem.video_path ofType:@"mp4"]];
    AVPlayerItem*videoItem = [[AVPlayerItem alloc] initWithURL:pathUrl];
    
    _videoSize = [[[videoItem.asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] naturalSize];
    
    AVPlayer*player = [AVPlayer playerWithPlayerItem:videoItem];
    player.volume = 1;
    AVPlayerLayer*playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.backgroundColor = [UIColor blackColor].CGColor;
    playerLayer.videoGravity =AVLayerVideoGravityResizeAspectFill;
    playerLayer.frame = videoBg.bounds;
    [videoBg.layer insertSublayer:playerLayer atIndex:0];
    [player play];
    _player = player;
    _playerLayer = playerLayer;

    
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
        label.layer.masksToBounds=YES;
        label.layer.backgroundColor = [UIColor clearColor].CGColor;
        label.layer.borderWidth =1.0f;
        label.layer.borderColor = [UIColor clearColor].CGColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"DINAlternate-Bold" size:40];
        label.textColor = [BECommonUtils colorWithHexString:@"#1D2129"];
        label.text = @"02:00";
        [_homepage addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(videoBg.mas_bottom).mas_offset(12);
            make.centerX.equalTo(_homepage);
            make.width.mas_equalTo(_homepage.bounds.size.width);
            make.height.mas_equalTo(label.bounds.size.height);
        }];
        _myTimerLabel = label;
    }
    
    UILabel *myLabel;
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 22)];
        label.layer.masksToBounds=YES;
        label.layer.backgroundColor = [UIColor clearColor].CGColor;
        label.layer.borderWidth =1.0f;
        label.layer.borderColor = [UIColor clearColor].CGColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        label.textColor = [BECommonUtils colorWithHexString:@"#4E5969"];
        label.text = NSLocalizedString(@"sport_assistance_time_calculate", nil);
        [_homepage addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_myTimerLabel.mas_bottom).mas_offset(4);
            make.centerX.equalTo(_homepage);
            make.width.mas_equalTo(_homepage.bounds.size.width);
            make.height.mas_equalTo(label.bounds.size.height);
        }];
        myLabel = label;
    }
    
    UIButton* myBtn;
    {
        UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 120, 44)];
        btn.backgroundColor = [BECommonUtils colorWithHexString:@"#1664FF"];
        [btn setTitle:NSLocalizedString(@"sport_assistance_start_sport", nil) forState:UIControlStateNormal];
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [btn.layer setMasksToBounds:YES];
        [btn.layer setCornerRadius:22];
        [btn addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
        [_homepage addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_homepage).mas_offset((iPhoneX ? -34 : 0) - 16);
            make.left.equalTo(_homepage).mas_offset(24);
            make.right.equalTo(_homepage).mas_offset(-24);
            make.height.mas_equalTo(btn.bounds.size.height);
        }];
        myBtn = btn;
        _startBtn = btn;
    }
    
    
    UIPickerView *view = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, _homepage.bounds.size.width, 300)];
    view.delegate = self;
    view.dataSource = self;
    view.showsSelectionIndicator = YES;
    view.backgroundColor = [UIColor whiteColor];
    [_homepage addSubview:view];
    _timeView = view;
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_homepage);
        make.right.equalTo(_homepage);
        make.top.equalTo(myLabel.mas_bottom).mas_offset(12);
        make.bottom.equalTo(myBtn.mas_top).mas_offset(-8);
    }];
    
    [self loadData];

}

- (void)viewWillAppear:(BOOL)animated
{
    if (_videoSize.width / _videoSize.height >= 1.0)
    {
        float newH = _homepage.bounds.size.width * _videoSize.height / _videoSize.width;
        _playerLayer.frame = CGRectMake(0, (_homepage.bounds.size.width - newH)/2, _homepage.bounds.size.width, newH);
    }
    else
    {
        float newW = _homepage.bounds.size.width * _videoSize.width / _videoSize.height;
        _playerLayer.frame = CGRectMake((_homepage.bounds.size.width - newW)/2, 0, newW, _homepage.bounds.size.width);
    }
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.savedGestureDelegate = self.navigationController.interactivePopGestureRecognizer.delegate;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    [_player play];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self.savedGestureDelegate;
    
    [[NSNotificationCenter defaultCenter] removeObserver:AVPlayerItemDidPlayToEndTimeNotification];
    [_player pause];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)videoBtnClick
{
    if(_player.rate == 0.0)
    {
        [_player play];
        _playBtn.hidden = YES;
    }
    else
    {
        [_player pause];
        _playBtn.hidden = NO;
    }
}

-(void)startClick
{
    BEAlgorithmConfig *algorithmConfig = BEAlgorithmConfig
        .newInstance()
        .typeW(BEActionRecognitionAlgorithmTask.ACTION_RECOGNITION.algorithmKey)
        .paramsW([NSDictionary dictionaryWithObject:@(YES) forKey:BEActionRecognitionAlgorithmTask.ACTION_RECOGNITION.algorithmKey]);
    
    BEVideoSourceConfig *sourceConfig = [BEVideoSourceConfig new];
    sourceConfig.type = BEVideoSourceCamera;
    sourceConfig.devicePosition = AVCaptureDevicePositionFront;
    
    
    NSDictionary<NSString *, NSObject *> *configDict =
    [NSDictionary dictionaryWithObjectsAndKeys:
     sourceConfig, VIDEO_SOURCE_CONFIG_KEY,
     algorithmConfig, ALGORITHM_CONFIG_KEY,nil];
    
    BESportsAssistantCountVC *vc = [[BESportsAssistantCountVC alloc] init];
    if ([vc isKindOfClass:[BEBaseVC class]]) {
        [(BEBaseVC *)vc setConfigDict:configDict];
    }
    
    if([BESportsAssistantVM instance].minute == 0 && [BESportsAssistantVM instance].second == 0)
    {
        [BESportsAssistantVM instance].minute = 2;
        [BESportsAssistantVM instance].second = 0;
    }
    [_player pause];
    [self.navigationController pushViewController:vc animated:YES];
    _startBtn.enabled = NO;
}

- (void)moviePlayDidEnd:(NSNotification*)notification{
    
    AVPlayerItem*item = [notification object];
    
    [item seekToTime:kCMTimeZero];
    
    [_player play];
    
}

-(void)loadData
{
    _minutes = [NSMutableArray array];
    _seconds = [NSMutableArray array];
    for(int i=0;i<60;i++)
    {
        if(i < 10)
        {
            NSString* str = [NSString stringWithFormat:@"0%d",i];
            [_minutes addObject:str];
            [_seconds addObject:str];
        }
        else
        {
            NSString* str = [NSString stringWithFormat:@"%d",i];
            [_minutes addObject:str];
            [_seconds addObject:str];
        }
    }
    
    [_timeView selectRow:2 inComponent:0 animated:NO];
    [_timeView selectRow:0 inComponent:1 animated:NO];
    [_timeView reloadAllComponents];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 60;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 48;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if (view == nil) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _homepage.bounds.size.width/2, 44)];
        lab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        lab.textColor = [BECommonUtils colorWithHexString:@"#1D2129"];
        lab.textAlignment = NSTextAlignmentCenter;
        view = lab;
    }
    UILabel *lab = (UILabel *)view;
    if(component == 0)
    {
        NSString* tmp = [@" " stringByAppendingString:NSLocalizedString(@"sport_assistance_time_min", nil)];
        lab.text = [_minutes[row] stringByAppendingString:tmp];
    }
    else
    {
        NSString* tmp = [@" " stringByAppendingString:NSLocalizedString(@"sport_assistance_time_sec", nil)];
        lab.text = [_seconds[row] stringByAppendingString:tmp];
    }
    
    return lab;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    int mRow = [_timeView selectedRowInComponent:0];
    int sRow = [_timeView selectedRowInComponent:1];
    
    _startBtn.enabled = !(mRow == 0 && sRow == 0);
    if(_startBtn.enabled)
    {
        _startBtn.backgroundColor = [BECommonUtils colorWithHexString:@"#1664FF"];
    }
    else
    {
        _startBtn.backgroundColor = [BECommonUtils colorWithHexString:@"#BEDCFF"];
    }
    
    NSString* str = [NSString stringWithFormat:@"%@:%@",_minutes[mRow],_seconds[sRow]];
    _myTimerLabel.text = str;
    
    [BESportsAssistantVM instance].minute = mRow;
    [BESportsAssistantVM instance].second = sRow;
    
}

- (void)applicationWillResignActive:(NSNotification *)notification
{
    [_player pause];
    _playBtn.hidden = NO;
}

@end
