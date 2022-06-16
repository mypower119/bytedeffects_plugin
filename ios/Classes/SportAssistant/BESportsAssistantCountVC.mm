//
//  BESportsAssistantCountVC.m
//  BEAlgorithm
//
//  Created by liqing on 2021/7/13.
//

#import "BESportsAssistantCountVC.h"
#import "BEImageUtils.h"
#import "BEBaseBarView.h"
#import "BEAlgorithmView.h"
#import "BEAlgorithmUIFactory.h"
#import "BEAlgorithmTaskFactory.h"
#import "BEAlgorithmResourceHelper.h"
#import "UIViewController+BEAdd.h"
#import "BEDeviceInfoHelper.h"
#import "BEPreviewSizeManager.h"
#import "BEAlgorithmRender.h"
#import "BEBubbleTipManager.h"
#import "BEPopoverManager.h"
#import "BEVideoCapture.h"
#import "Masonry.h"
#import "UIView+Toast.h"
#import "BECommonUtils.h"
#include <chrono>
#import "BESportsAssistantOverVC.h"
#import "BESportsAssistantVM.h"
#import <AudioToolbox/AudioToolbox.h>
#import "BDBalanceBar.h"

#define iPhoneX [BEDeviceInfoHelper isIPhoneXSeries]
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define angle2Rad(angle) ((angle) / 180.0 * M_PI)

@interface BESportsAssistantCountVC ()<BDBalanceBarDelegate>

@property (nonatomic, strong) BEAlgorithmTask *algorithmTask;
@property (nonatomic, strong) BEAlgorithmRender *algorithmRender;

@end

@implementation BESportsAssistantCountVC
{
    int _cur_count;
    BOOL _isReadyPoseDetectMode;
    BOOL _isCountDown;
    BOOL _startShowFeedback;
    
    UIView* _countDownView;
    UIView* _topBar;
    UILabel* _tipLabel;
    UILabel* _countLabel;
    UILabel* _timeLabel;
    UILabel* _countDownLabel;
    
    NSTimer* _countDownTimer;
    NSTimer* _readyTimer;
    NSTimer* _sportCountDownTimer;
    int _countDown;
    int _sportCountDown;
    
    int _minute;
    int _second;
    bef_ai_action_recognition_start_pose_type _readyPoseType;
    NSString* _sportName;
    NSString* _tutor_image;
    NSString* _tutor_right_image;
    NSString* _finish_logo_image;
    
    UIImageView* _flag_lt;
    UIImageView* _flag_rt;
    UIImageView* _flag_lb;
    UIImageView* _flag_rb;
    UIImageView* _flag_center;
    UIView* _flag_mask;
    
    UIButton* _backBtn;
    UIButton* _shiftCamBtn;
    UIButton* _finishBtn;
    
    BOOL _isLandscape;
    
    AVPlayer* _player;
    
    BDBalanceBar* _balanceBar;
    BOOL _isBalanceMode;
}

- (void)viewDidLoad {
    //_sportName must be set first
    [self initParams];
    
    self.algorithmConfig = (BEAlgorithmConfig *)self.configDict[ALGORITHM_CONFIG_KEY];
    if (self.algorithmConfig == nil) {
        NSLog(@"invalid algorithm config");
        return;
    }
    
    [super viewDidLoad];

    if(_isLandscape)
    {
        [self buildTopBar_landscape];
        [self buildCountDownUI_landscape];
        [self buildFlagUI_landscape];
        [self buildBottomBar_landscape];
        [self buildBalanceBar_landscape];
    }
    else
    {
        [self buildTopBar];
        [self buildCountDownUI];
        [self buildFlagUI];
        [self buildBottomBar];
        [self buildBalanceBar];
    }
}
#pragma mark - demo UI 相关

-(void)initParams
{
    _minute = [BESportsAssistantVM instance].minute;
    _second = [BESportsAssistantVM instance].second;
    _sportCountDown = _minute * 60 + _second;
    
    
    BESportsAssistantClassItem* item = [BESportsAssistantVM instance].classArray[[BESportsAssistantVM instance].classIndex];
    switch (item.readyPoseType) {
        case 1:
            _readyPoseType = BEF_AI_ACTION_RECOGNITION_Stand;
            break;
        case 2:
            _readyPoseType = BEF_AI_ACTION_RECOGNITION_Lying;
            break;
        case 3:
            _readyPoseType = BEF_AI_ACTION_RECOGNITION_Sitting;
            break;
        case 4:
            _readyPoseType = BEF_AI_ACTION_RECOGNITION_SideLeft;
            break;
        case 5:
            _readyPoseType = BEF_AI_ACTION_RECOGNITION_SideRight;
            break;
        default:
            break;
    }
    
    _sportName = item.key;
    _isLandscape = item.isLandscape;
    _tutor_image = item.tutor_wrong;
    _tutor_right_image = item.tutor_right;
    _finish_logo_image = item.finish_logo;
    
    _cur_count = 0;
    _isReadyPoseDetectMode = YES;
    _isCountDown = NO;
    _countDown = 3;
    _isBalanceMode = YES;
}

-(void)buildBottomBar
{
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 58, 34)];
    btn.backgroundColor = [UIColor clearColor];
    UIImage* icon = [UIImage imageNamed:@"ic_sa_count_back"];
    [btn setBackgroundImage:icon forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(20);
        make.bottom.equalTo(self.view).mas_offset((iPhoneX ? -34 : 0) - 16);
    }];
    _backBtn = btn;
    
    {
        UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 58, 34)];
        btn.backgroundColor = [UIColor clearColor];
        UIImage* icon = [UIImage imageNamed:@"ic_sa_shiftcamera"];
        [btn setBackgroundImage:icon forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(shiftCamClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view).mas_offset(-20);
            make.bottom.equalTo(self.view).mas_offset((iPhoneX ? -34 : 0) - 16);
        }];
        _shiftCamBtn = btn;
    }
    
    {
        UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 58, 34)];
        btn.backgroundColor = [UIColor clearColor];
        UIImage* icon = [UIImage imageNamed:@"ic_sa_finish"];
        [btn setBackgroundImage:icon forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(finishClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view).mas_offset(-20);
            make.bottom.equalTo(self.view).mas_offset((iPhoneX ? -34 : 0) - 16);
        }];
        btn.hidden = YES;
        _finishBtn = btn;
    }
}

-(void)buildFlagUI
{
    _flag_mask = [UIView new];
    [self.view addSubview:_flag_mask];
    [_flag_mask mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topBar.mas_bottom);
        make.bottom.equalTo(self.view);
        make.right.equalTo(self.view);
        make.left.equalTo(self.view);
    }];
    
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
    UIImage* img = [UIImage imageNamed:_tutor_image];
    imgView.image = img;
    _flag_center = imgView;
    [_flag_mask addSubview:imgView];
    if(iPhoneX)
    {
        [_flag_center mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_flag_mask);
            make.height.mas_equalTo(_flag_center.mas_width).multipliedBy(img.size.height/img.size.width);
            make.right.equalTo(_flag_mask);
            make.left.equalTo(_flag_mask);
        }];
    }
    else
    {
        [_flag_center mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_flag_mask);
            make.width.mas_equalTo(_flag_center.mas_height).multipliedBy(img.size.width/img.size.height);
            make.centerX.equalTo(_flag_mask);
            make.bottom.equalTo(_flag_mask);
        }];
        
        UIView* padview1 = [UIView new];
        padview1.backgroundColor = UIColor.blackColor;
        padview1.alpha = 0.3;
        [_flag_mask addSubview:padview1];
        [padview1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_flag_mask);
            make.bottom.equalTo(_flag_mask);
            make.right.equalTo(_flag_center.mas_left);
            make.left.equalTo(_flag_mask);
        }];
        
        UIView* padview2 = [UIView new];
        padview2.backgroundColor = UIColor.blackColor;
        padview2.alpha = 0.3;
        [_flag_mask addSubview:padview2];
        [padview2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_flag_mask);
            make.bottom.equalTo(_flag_mask);
            make.right.equalTo(_flag_mask);
            make.left.equalTo(_flag_center.mas_right);
        }];
    }
}

-(void)buildCountDownUI
{
    _countDownView = [UIView new];
    _countDownView.backgroundColor = [BECommonUtils colorWithHexString:@"#1664FF"];
    [self.view addSubview:_countDownView];
    [_countDownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 145, 300)];
    label.layer.masksToBounds=YES;
    label.layer.backgroundColor = [UIColor clearColor].CGColor;
    label.layer.borderWidth =1.0f;
    label.layer.borderColor = [UIColor clearColor].CGColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"DINAlternate-Bold" size:300];
    label.textColor = [UIColor whiteColor];
    label.text = @"3";
    _countDownLabel = label;
    [_countDownView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    [self hideCountDownUI];
}

-(void)buildTopBar
{
    _topBar = [UIView new];
    _topBar.backgroundColor = UIColor.blackColor;
    [self.view addSubview:_topBar];
    
    [_topBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo((iPhoneX ? 44 : 20) + 80);
    }];
    
    _tipLabel = [self createTopBarLabel];
    [_topBar addSubview:_tipLabel];
    
    _tipLabel.backgroundColor = [BECommonUtils colorWithHexString:@"#FA9600"];
    _tipLabel.text = NSLocalizedString(@"sport_assistance_fit_outline", nil);
    _tipLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:36];
    
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topBar);
        make.right.equalTo(_topBar);
        make.bottom.equalTo(_topBar);
        make.height.mas_equalTo(_tipLabel.bounds.size.height);
    }];
    
    
    _countLabel = [self createTopBarLabel];
    [_topBar addSubview:_countLabel];
    _countLabel.backgroundColor = [BECommonUtils colorWithHexString:@"#1664FF"];
    _countLabel.text = @"0";
    _countLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:60];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topBar);
        make.bottom.equalTo(_topBar);
        make.height.mas_equalTo(_countLabel.bounds.size.height);
        make.width.mas_equalTo(self.view.bounds.size.width/2);
    }];
    _countLabel.hidden = YES;
    
    
    _timeLabel = [self createTopBarLabel];
    _timeLabel.backgroundColor = [UIColor whiteColor];
    _timeLabel.textColor = [BECommonUtils colorWithHexString:@"#4E5969"];
    _timeLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:40];
    [_topBar addSubview:_timeLabel];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_topBar);
        make.bottom.equalTo(_topBar);
        make.height.mas_equalTo(_timeLabel.bounds.size.height);
        make.width.mas_equalTo(self.view.bounds.size.width/2);
    }];
    _timeLabel.hidden = YES;
    
}

-(void)buildBalanceBar
{
    CGFloat width = 76;
    CGFloat x = (self.view.bounds.size.width - width)/2.0;
    CGFloat y = (self.view.bounds.size.height - _topBar.bounds.size.height - width * 268/76.0)/2.0;
    _balanceBar =  [[BDBalanceBar alloc]initWithFrame:CGRectMake(x , y, width, width)];
    
    [self.view addSubview:_balanceBar];
    _balanceBar.delegate = self;
}

-(void)buildBalanceBar_landscape
{
    CGFloat width = 76;
    _balanceBar =  [[BDBalanceBar alloc]initWithFrame:CGRectMake(0 , 0, width, width)];
    _balanceBar.transform = CGAffineTransformMakeRotation((angle2Rad(90)));
    [self.view addSubview:_balanceBar];
    _balanceBar.delegate = self;
    
    CGFloat x = (self.view.bounds.size.width - 96)/2.0;
    [_balanceBar setCenter:CGPointMake(x, self.view.center.y)];
}

- (void)balanceCompleted
{
    _isBalanceMode = NO;
    _tipLabel.text = NSLocalizedString(@"sport_assistance_fit_outline", nil);
    _tipLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:36];
    [self showTipUI];
    [self resumFlagUIAfterBalance];
    [self hideBalanceUI];
}

-(void)buildFlagUI_landscape
{
    _flag_mask = [UIView new];
    [self.view addSubview:_flag_mask];
    [_flag_mask mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.right.equalTo(self.view).mas_offset(-96);
        make.left.equalTo(self.view);
    }];
    
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
    UIImage* img = [UIImage imageNamed:_tutor_image];
    imgView.image = img;
    _flag_center = imgView;
    [_flag_mask addSubview:imgView];
    
    float s_r = (SCREEN_WIDTH - 96)/SCREEN_HEIGHT;
    float i_r = img.size.width / img.size.height;
    float alpha = 0.4;
    
    if(i_r >= s_r)
    {
        [_flag_center mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_flag_mask);
            make.height.mas_equalTo(_flag_center.mas_width).multipliedBy(img.size.height / img.size.width);
            make.right.equalTo(_flag_mask);
            make.left.equalTo(_flag_mask);
        }];
        
        UIView* padview1 = [UIView new];
        padview1.backgroundColor = UIColor.blackColor;
        padview1.alpha = alpha;
        [_flag_mask addSubview:padview1];
        [padview1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_flag_mask);
            make.bottom.equalTo(_flag_center.mas_top);
            make.right.equalTo(_flag_mask);
            make.left.equalTo(_flag_mask);
        }];
        
        UIView* padview2= [UIView new];
        padview2.backgroundColor = UIColor.blackColor;
        padview2.alpha = alpha;
        [_flag_mask addSubview:padview2];
        [padview2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_flag_center.mas_bottom);
            make.bottom.equalTo(_flag_mask);
            make.right.equalTo(_flag_mask);
            make.left.equalTo(_flag_mask);
        }];
    }
    else
    {
        [_flag_center mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_flag_mask);
            make.width.mas_equalTo(_flag_center.mas_height).multipliedBy(img.size.width / img.size.height);
            make.top.equalTo(_flag_mask);
            make.bottom.equalTo(_flag_mask);
        }];
        
        UIView* padview1 = [UIView new];
        padview1.backgroundColor = UIColor.blackColor;
        padview1.alpha = alpha;
        [_flag_mask addSubview:padview1];
        [padview1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_flag_mask);
            make.bottom.equalTo(_flag_mask);
            make.right.equalTo(_flag_center.mas_left);
            make.left.equalTo(_flag_mask);
        }];
        
        UIView* padview2= [UIView new];
        padview2.backgroundColor = UIColor.blackColor;
        padview2.alpha = alpha;
        [_flag_mask addSubview:padview2];
        [padview2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_flag_mask);
            make.bottom.equalTo(_flag_mask);
            make.right.equalTo(_flag_mask);
            make.left.equalTo(_flag_center.mas_right);
        }];
    }
}

-(void)buildBottomBar_landscape
{
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 58, 34)];
    btn.backgroundColor = [UIColor clearColor];
    UIImage* icon = [UIImage imageNamed:@"ic_sa_count_back"];
    [btn setBackgroundImage:icon forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn.frame = CGRectMake(btn.bounds.size.height/2 + 6, btn.bounds.size.width/2 + 64,btn.bounds.size.width,btn.bounds.size.height);
    btn.transform = CGAffineTransformMakeRotation(M_PI_2);
    _backBtn = btn;
    
    {
        UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 58, 34)];
        btn.backgroundColor = [UIColor clearColor];
        UIImage* icon = [UIImage imageNamed:@"ic_sa_shiftcamera"];
        [btn setBackgroundImage:icon forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(shiftCamClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];

        btn.frame = CGRectMake(btn.bounds.size.height/2 + 6, (self.view.bounds.size.height - (btn.bounds.size.width/2 + 98)),btn.bounds.size.width,btn.bounds.size.height);
        btn.transform = CGAffineTransformMakeRotation(M_PI_2);
        _shiftCamBtn = btn;
    }

    {
        UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 58, 34)];
        btn.backgroundColor = [UIColor clearColor];
        UIImage* icon = [UIImage imageNamed:@"ic_sa_finish"];
        [btn setBackgroundImage:icon forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(finishClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];

        btn.frame = CGRectMake(btn.bounds.size.height/2 + 6, (self.view.bounds.size.height - (btn.bounds.size.width/2 + 98)),btn.bounds.size.width,btn.bounds.size.height);
        btn.transform = CGAffineTransformMakeRotation(M_PI_2);
        btn.hidden = YES;
        _finishBtn = btn;
    }
}

-(void)buildCountDownUI_landscape
{
    _countDownView = [UIView new];
    _countDownView.backgroundColor = [BECommonUtils colorWithHexString:@"#1664FF"];
    [self.view addSubview:_countDownView];
    [_countDownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 145, 300)];
    label.layer.masksToBounds=YES;
    label.layer.backgroundColor = [UIColor clearColor].CGColor;
    label.layer.borderWidth =1.0f;
    label.layer.borderColor = [UIColor clearColor].CGColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"DINAlternate-Bold" size:300];
    label.textColor = [UIColor whiteColor];
    label.text = @"3";
    _countDownLabel = label;
    [_countDownView addSubview:label];
    _countDownLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    [self hideCountDownUI];
}

-(void)buildTopBar_landscape
{
    _topBar = [UIView new];
    _topBar.backgroundColor = UIColor.blackColor;
    [self.view addSubview:_topBar];
    
    [_topBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.width.mas_equalTo(96);
    }];
    
    _tipLabel = [self createTopBarLabel];
    [_topBar addSubview:_tipLabel];
    
    _tipLabel.backgroundColor = [BECommonUtils colorWithHexString:@"#FA9600"];
    _tipLabel.text = NSLocalizedString(@"sport_assistance_fit_outline", nil);
    _tipLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:36];
    _tipLabel.frame = CGRectMake(-(self.view.bounds.size.height - 96)/2, (self.view.bounds.size.height - 96)/2, self.view.bounds.size.height, 96);
    _tipLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
    
    
    _countLabel = [self createTopBarLabel];
    [_topBar addSubview:_countLabel];
    _countLabel.backgroundColor = [BECommonUtils colorWithHexString:@"#1664FF"];
    _countLabel.text = @"0";
    _countLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:60];
    _countLabel.frame = CGRectMake(-(self.view.bounds.size.height/2 - 96)/2, (self.view.bounds.size.height/2 - 96)/2, self.view.bounds.size.height/2, 96);
    _countLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
    _countLabel.hidden = YES;


    _timeLabel = [self createTopBarLabel];
    _timeLabel.backgroundColor = [UIColor whiteColor];
    _timeLabel.textColor = [BECommonUtils colorWithHexString:@"#4E5969"];
    _timeLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:40];
    [_topBar addSubview:_timeLabel];
    _timeLabel.frame = CGRectMake(-(self.view.bounds.size.height/2 - 96)/2, self.view.bounds.size.height*3/4 - 48, self.view.bounds.size.height/2, 96);
    _timeLabel.transform = CGAffineTransformMakeRotation(M_PI_2);

    _timeLabel.hidden = YES;
}

-(UILabel*)createTopBarLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 80)];
    label.layer.masksToBounds=YES;
    label.layer.backgroundColor = [UIColor redColor].CGColor;
    label.layer.borderWidth =1.0f;
    label.layer.borderColor = [UIColor clearColor].CGColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"00:52";
    return label;
}

-(UIImageView*)createFlagImageView:(NSString*)iconPath
{
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
    UIImage* img = [UIImage imageNamed:iconPath];
    imgView.image = img;
    [self.view addSubview:imgView];
    return imgView;
}


-(void)backClick
{
    [self stopReadyTimer];
    [self stopCountDownTimer];
    [self stopSportCountDownTimer];
    [_balanceBar destroy];    
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
}

-(void)shiftCamClick
{
    [(BEVideoCapture *)self.videoSource switchCamera];
}

-(void)finishClick
{
    [self stopSportCountDownTimer];
    [self gotoFinishVC];
}

-(void)showFeedbackUI:(BEActionRecognitionAlgorithmResult*)result
{
    _tipLabel.backgroundColor = [BECommonUtils colorWithHexString:@"#FA9600"];
    [_topBar bringSubviewToFront:_tipLabel];
    NSString* str = @"";
    if(result && result.actionRecognitionInfo)
    {
        switch (result.actionRecognitionInfo->feed_body_part) {
            case BEF_AI_ACTION_RECOGNITION_FeedbackLeftArm:
                str = @"请注意左臂";
                break;
            case BEF_AI_ACTION_RECOGNITION_FeedbackRightArm:
                str = @"请注意右臂";
                break;
            case BEF_AI_ACTION_RECOGNITION_FeedbackLeftLeg:
                str = @"请注意左腿";
                break;
            case BEF_AI_ACTION_RECOGNITION_FeedbackRightLeg:
                str = @"请注意右腿";
                break;
            default:
                break;
        }
        _tipLabel.text = str;
        _tipLabel.hidden = NO;
        if(result.actionRecognitionInfo->feed_body_part == BEF_AI_ACTION_RECOGNITION_FeedbackNone)
        {
            _tipLabel.hidden = YES;
        }
    }
}

-(void)showCountTipUI
{
    _countLabel.hidden = NO;
    _timeLabel.hidden = NO;
}

-(void)HideCountTipUI
{
    _countLabel.hidden = YES;
    _timeLabel.hidden = YES;
}

-(void)showReadyUI
{
    _tipLabel.backgroundColor = [BECommonUtils colorWithHexString:@"#1664FF"];
    _tipLabel.text = NSLocalizedString(@"sport_assistance_recognize_success", nil);
    
    UIImage* img = [UIImage imageNamed:_tutor_right_image];
    _flag_center.image = img;
}

-(void)showTipUI
{
    _tipLabel.hidden = NO;
}

-(void)hideTipUI
{
    _tipLabel.hidden = YES;
}

-(void)hideBalanceUI
{
    _balanceBar.hidden = YES;
    [_balanceBar removeFromSuperview];
    _balanceBar = nil;
}

-(void)showCountDownUI
{
    _countDownView.hidden = NO;
    [self.view bringSubviewToFront:_countDownView];
}

-(void)hideCountDownUI
{
    _countDownView.hidden = YES;
}

-(void)resumFlagUIAfterBalance
{
    _shiftCamBtn.hidden = NO;
    _finishBtn.hidden = YES;
    _flag_mask.hidden = NO;
}

-(void)hideFlagUIDuringBalance
{
    _shiftCamBtn.hidden = YES;
    _finishBtn.hidden = YES;
    _flag_mask.hidden = YES;
}

-(void)hideFlagUI
{
    _flag_lt.hidden = YES;
    _flag_rt.hidden = YES;
    _flag_lb.hidden = YES;
    _flag_rb.hidden = YES;
    _shiftCamBtn.hidden = YES;
    _finishBtn.hidden = NO;
    _flag_mask.hidden = YES;
}

-(void)updateCountDownView
{
    NSString* str = [NSString stringWithFormat:@"%d",_countDown];
    _countDownLabel.text = str;
}

-(void)updateCountLabel
{
    NSString* str = [NSString stringWithFormat:@"%d",_cur_count];
    _countLabel.text = str;
}

-(NSString*)generateTimeStr:(int)countDown
{
    int m = countDown/60;
    int s = countDown % 60;
    
    NSString* mStr;
    if(m < 10)
    {
        mStr = [NSString stringWithFormat:@"0%d",m];
    }
    else
    {
        mStr = [NSString stringWithFormat:@"%d",m];
    }
    
    NSString* sStr;
    if(s < 10)
    {
        sStr = [NSString stringWithFormat:@"0%d",s];
    }
    else
    {
        sStr = [NSString stringWithFormat:@"%d",s];
    }
    
    NSString* str = [NSString stringWithFormat:@"%@:%@",mStr,sStr];
    return str;
}

-(void)updateTimeLabel
{
    NSString* str = [self generateTimeStr:_sportCountDown];
    _timeLabel.text = str;
    if(_sportCountDown <= 5)
    {
        _timeLabel.textColor = [BECommonUtils colorWithHexString:@"#EB635E"];
    }
    else
    {
        _timeLabel.textColor = [BECommonUtils colorWithHexString:@"#4E5969"];
    }
}

-(void)startReadyTimer
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showReadyUI];
        _readyTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(doReadyTimer:) userInfo:nil repeats:YES];
    });
}

-(void)stopReadyTimer
{
    [_readyTimer invalidate];
    _readyTimer = nil;
}

-(void)doReadyTimer:(NSTimer *)timer
{
    [self stopReadyTimer];
    [self hideTipUI];
    [self showCountDownUI];
    [self startCountDownTimer];
}

-(void)startCountDownTimer
{
    _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(doCountDownTimer:) userInfo:nil repeats:YES];
}

-(void)stopCountDownTimer
{
    [_countDownTimer invalidate];
    _countDownTimer = nil;
}

-(void)doCountDownTimer:(NSTimer *)timer
{
    _countDown--;
    [self updateCountDownView];
    
    if(_countDown < 1)
    {
        [self stopCountDownTimer];
        [self showCountTipUI];
        [self hideCountDownUI];
        [self hideFlagUI];
        [self startSportCountDownTimer];
        _isCountDown = NO;
        _startShowFeedback = YES;
    }
}

-(void)startSportCountDownTimer
{
    [self updateTimeLabel];
    _sportCountDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(doSportCountDownTimer:) userInfo:nil repeats:YES];
}

-(void)stopSportCountDownTimer
{
    [_sportCountDownTimer invalidate];
    _sportCountDownTimer = nil;
}

-(void)doSportCountDownTimer:(NSTimer *)timer
{
    _sportCountDown--;
    if(_sportCountDown >= 0)
    {
        [self updateTimeLabel];
    }
    
    if(_sportCountDown < 0)
    {
        _sportCountDown++;
        [self stopSportCountDownTimer];
        [self gotoFinishVC];
    }
}

-(void)gotoFinishVC
{
    BESportsAssistantOverVC* vc = [BESportsAssistantOverVC new];
    vc.count = _countLabel.text;
    vc.finishLogo = _finish_logo_image;
    int timeCount = [BESportsAssistantVM instance].minute * 60 + [BESportsAssistantVM instance].second - _sportCountDown;
    vc.timeStr = [NSString stringWithFormat:@"%d",timeCount];
                  //[self generateTimeStr:([BESportsAssistantVM instance].minute * 60 + [BESportsAssistantVM instance].second)];
    [self.navigationController pushViewController:vc animated:YES];
}

- (bef_ai_rotate_type)rotateTypeWithRotation:(int)rotation {
    rotation = rotation % 360;
    switch (rotation) {
        case 0:
            return BEF_AI_CLOCKWISE_ROTATE_0;
        case 90:
            return BEF_AI_CLOCKWISE_ROTATE_90;
        case 180:
            return BEF_AI_CLOCKWISE_ROTATE_180;
        case 270:
            return BEF_AI_CLOCKWISE_ROTATE_270;
    }
    return BEF_AI_CLOCKWISE_ROTATE_0;
}

- (bef_ai_pixel_format)pixelFormatWithFormat:(BEFormatType)format {
    switch (format) {
        case BE_RGBA:
            return BEF_AI_PIX_FMT_RGBA8888;
        case BE_BGRA:
            return BEF_AI_PIX_FMT_BGRA8888;
        default:
            break;
    }
    return BEF_AI_PIX_FMT_RGBA8888;
}

- (int)getDeviceOrientation {
    if (self.videoSourceConfig.type != BEVideoSourceCamera) {
        return 0;
    }
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            return 0;
            
        case UIDeviceOrientationPortraitUpsideDown:
            return 180;
            
        case UIDeviceOrientationLandscapeLeft:
            return 270;
            
        case UIDeviceOrientationLandscapeRight:
            return 90;
            
        default:
            return 0;
    }
}

-(void)playTipAudio:(NSString*)name length:(float)length
{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    NSURL* pathUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:name ofType:@"wav"]];
    AVPlayerItem*videoItem = [[AVPlayerItem alloc] initWithURL:pathUrl];
    _player = [AVPlayer playerWithPlayerItem:videoItem];
    _player.volume = 1;
    [_player play];
}


#pragma mark - SDK，SDK 函数调用相关，重点代码
- (int)initSDK {
    self.algorithmTask = [BEAlgorithmTaskFactory create:self.algorithmConfig.algorithmKey provider:[BEAlgorithmResourceHelper new] licenseProvider:[BELicenseHelper shareInstance]];
    int ret = [((BEActionRecognitionAlgorithmTask*)self.algorithmTask) initTaskWithSportName:_sportName];
    if(ret == BEF_RESULT_LICENSE_STATUS_EXPIRED)
    {
        [self.view makeToast:NSLocalizedString(@"license_expired", nil)
                    duration:[CSToastManager defaultDuration]
                    position:[CSToastManager defaultPosition]];
    }
    self.algorithmRender = [[BEAlgorithmRender alloc] init];
    return ret;
}

- (void)processWithCVPixelBuffer:(CVPixelBufferRef)pixelBuffer rotation:(int)rotation timeStamp:(double)timeStamp {
    
    BEPixelBufferInfo *pixelBufferInfo = [self.imageUtils getCVPixelBufferInfo:pixelBuffer];
    if (pixelBufferInfo.format != BE_BGRA) {
        pixelBuffer = [self.imageUtils transforCVPixelBufferToCVPixelBuffer:pixelBuffer outputFormat:BE_BGRA];
    }
    
    //  {zh} 如果传入图片有旋转，先进行旋转  {en} If the incoming picture has a rotation, rotate it first
    if (rotation != 0) {
        pixelBuffer = [self.imageUtils rotateCVPixelBuffer:pixelBuffer rotation:rotation];
    }
    
    //  {zh} 将输入的 CVPixelBuffer 转换成纹理  {en} Convert input CVPixelBuffer to texture
    BEPixelBufferGLTexture *texture = [self.imageUtils transforCVPixelBufferToTexture:pixelBuffer];
    
    //  {zh} 将输入的 CVPixelBuffer 转换成 buffer  {en} Converts the input CVPixelBuffer into a buffer
    BEBuffer *buffer = [self.imageUtils transforCVPixelBufferToBuffer:pixelBuffer outputFormat:BE_BGRA];
    
    //  {zh} 设置通用参数  {en} Set general parameters
    if (self.videoSourceConfig.type == BEVideoSourceCamera) {
        [self.algorithmTask setConfig:BEAlgorithmTask.ALGORITHM_FOV p:[NSNumber numberWithFloat:[(BEVideoCapture *)self.videoSource currentFOV]]];
    }
    
    // {zh} 摆放设备准备 {en} device layout preparation
    if(_isBalanceMode)
    {
        dispatch_sync(dispatch_get_main_queue(), ^{
            _tipLabel.text = NSLocalizedString(@"sport_assistance_adjust_device", nil);
            if(!_isLandscape)
            {
                _tipLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:20];
            }
            [self hideFlagUIDuringBalance];
        });
    }
    else
    {
        // {zh} 检测准备 {en} Test preparation
        if(_isReadyPoseDetectMode)
        {
            BOOL result =  [((BEActionRecognitionAlgorithmTask*)self.algorithmTask) readyPostDetect:buffer.buffer width:buffer.width height:buffer.height stride:buffer.bytesPerRow format:[self pixelFormatWithFormat:buffer.format] rotation:BEF_AI_CLOCKWISE_ROTATE_0 readyPoseType:_readyPoseType];
            
            _isReadyPoseDetectMode = !result;
            
            if(!_isReadyPoseDetectMode)
            {
                // {zh} 识别成功后，停留一秒显示识别成功 {en} After successful recognition, stay for one second to show successful recognition
                _isCountDown = YES;
                [self startReadyTimer];
            }
        }
        else
        {
            //  {zh} 执行算法检测  {en} Execute algorithm detection
            BEActionRecognitionAlgorithmResult* result = [self.algorithmTask process:buffer.buffer width:buffer.width height:buffer.height stride:buffer.bytesPerRow format:[self pixelFormatWithFormat:buffer.format] rotation:(bef_ai_rotate_type)[self getDeviceOrientation]];
            
            //  {zh} 绘制算法检测结果到目标纹理  {en} Drawing algorithm detects result to target texture
            if (result != nil) {
                if(!_isCountDown)
                {
                    if(result.actionRecognitionInfo == nil)
                    {
                        return;
                    }
                    // {zh} 计数成功 {en} Count success
                    if (result.actionRecognitionInfo->recognize_succeed)
                    {
                        _cur_count++;
                        [self playTipAudio:@"beep" length:1.5];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self updateCountLabel];
                        });
                    }
                }

                [self.algorithmRender setRenderTargetTexture:texture.texture width:texture.width height:texture.height resizeRatio:1];
                if(!_startShowFeedback)
                {
                    if(result && result.actionRecognitionInfo)
                    {
                        result.actionRecognitionInfo->is_feedback_valid = false;
                    }
                }
                
                [self.algorithmRender drawAlgorithmResult:result];
            }
        }
    }
    
   
    
    //  {zh} 将最终纹理绘制到屏幕上  {en} Draw the final texture to the screen
    [self drawGLTextureOnScreen:texture rotation:0];
    
    if (rotation != 0) {
        CVPixelBufferRelease(pixelBuffer);
    }
}

- (void)destroySDK {
    [self.algorithmRender destroy];
    [self.algorithmTask destroyTask];
}


@end
