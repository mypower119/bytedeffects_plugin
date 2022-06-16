//
//  BDBalanceBar.m
//  NewComponent
//
//  Created by liqing on 2021/12/2.
//

#import "BDBalanceBar.h"
#import "BDCircleView.h"
#import <CoreMotion/CoreMotion.h>
#import "Masonry.h"
#import <AudioToolbox/AudioToolbox.h>
#import "BECommonUtils.h"

const double threshold = 75.0;
const double threshold_gap = 5.0;

@implementation BDBalanceBar
{
    UIButton* _longBgBar;
    UIButton* _sliderHandle;
    BDCircleView* _circleView;
    CMMotionManager* _motionManager;
    BOOL _willPlayFeedback;
    NSTimer* _countDownTimer;
    BOOL _setAngleReady;
    
    UIColor* _notBalancedCircleBgColor;
    UIColor* _balancedCircleBgColor;
    UIImage* _notBalancedLongBarIcon;
    UIImage* _balancedLongBarIcon;
    UIImage* _notBalancedHandleIcon;
    UIImage* _balancedHandleIcon;
    UIImage* _finishHandleIcon;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    CGFloat height = frame.size.width * 268/76.0;
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height)];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _notBalancedCircleBgColor = [BECommonUtils colorWithHexString:@"#FA9600"];
    _balancedCircleBgColor = [BECommonUtils colorWithHexString:@"#1664FF"];
    _notBalancedLongBarIcon = [UIImage imageNamed:@"ic_sa_not_balance_longbar"];
    _balancedLongBarIcon = [UIImage imageNamed:@"ic_sa_balance_longbar"];
    _notBalancedHandleIcon = [UIImage imageNamed:@"ic_sa_not_balance_handle"];
    _balancedHandleIcon = [UIImage imageNamed:@"ic_sa_balance_handle"];
    _finishHandleIcon = [UIImage imageNamed:@"ic_sa_finish_balance_handle"];
    
    _longBgBar = [[UIButton alloc]initWithFrame:self.bounds];
    _longBgBar.userInteractionEnabled = NO;
    [_longBgBar setBackgroundImage:_notBalancedLongBarIcon forState:UIControlStateNormal];
    [self addSubview:_longBgBar];
    [_longBgBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).mas_offset(24);
        make.bottom.equalTo(self).mas_offset(-24);
        make.width.mas_equalTo(_longBgBar.mas_height).multipliedBy(36/220.0);
        make.centerX.equalTo(self);
    }];
    
    CGFloat cWidth = self.bounds.size.width;
    BDCircleViewConfigure *configure = [[BDCircleViewConfigure alloc]init];
    configure.lineColor = _notBalancedCircleBgColor;
    configure.circleLineWidth = 2;
    configure.isClockwise = YES;
    //渐变色分布方向
    configure.startPoint = CGPointMake(cWidth / 2, 0);
    configure.endPoint   = CGPointMake(cWidth / 2 , cWidth);
    //渐变色的颜色
    configure.colorArr = @[
        (id) _balancedCircleBgColor.CGColor,
    ];
    //颜色数组中,每个颜色在"渐变色方向"上[0,1]中的起始位置
    configure.colorSize = @[@0];
    _circleView = [[BDCircleView alloc]initWithFrame:CGRectMake(0 , (self.bounds.size.height - cWidth)/2, cWidth, cWidth) configure:configure];
    [self addSubview:_circleView];
    
    CGFloat handleWidth = self.bounds.size.width * 60 / 76.0;
    _sliderHandle = [[UIButton alloc]initWithFrame:CGRectMake((self.bounds.size.width - handleWidth)/2 , 0, handleWidth, handleWidth)];
    _sliderHandle.userInteractionEnabled = NO;
    [self addSubview:_sliderHandle];
    [_sliderHandle setBackgroundImage:_notBalancedHandleIcon forState:UIControlStateNormal];
    
    _motionManager = [[CMMotionManager alloc]init];
    NSOperationQueue*queue = [[NSOperationQueue alloc]init];
    //加速计
    if(_motionManager.accelerometerAvailable)
    {
        _motionManager.accelerometerUpdateInterval=0.01;
        [_motionManager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData*accelerometerData,NSError*error){
            if(error) {
                [_motionManager stopAccelerometerUpdates];
                NSLog(@"error");
            }else{
                double zTheta =atan2(accelerometerData.acceleration.z,sqrtf(accelerometerData.acceleration.x*accelerometerData.acceleration.x+accelerometerData.acceleration.y*accelerometerData.acceleration.y))/M_PI*(-90.0)*2-90;
                double xyTheta =atan2(accelerometerData.acceleration.x,accelerometerData.acceleration.y)/M_PI*180.0;
//                NSLog(@"手机与水平面的夹角是%.2f,手机绕自身旋转的角度是%.2f",-zTheta,xyTheta);
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self processTheta:-zTheta];
                });
                
            }
        }];
    }else{
        NSLog(@"This device has no accelerometer");
    }
}

-(void)processTheta:(double)theta
{
    double s_c_y = _sliderHandle.bounds.size.width/2;
    double e_c_y = self.bounds.size.height - _sliderHandle.bounds.size.width/2;
    double new_y = s_c_y + (self.bounds.size.height-_sliderHandle.bounds.size.width)/(threshold*2) * theta;
    if(new_y <= s_c_y)new_y = s_c_y;
    else if(new_y >= e_c_y)new_y = e_c_y;
    [UIView animateWithDuration:0.2 animations:^{
        [_sliderHandle setCenter:CGPointMake(_sliderHandle.center.x, new_y)];
    }];
    
    if(fabs(theta - threshold) <= threshold_gap)
    {
        if(!_willPlayFeedback)
        {
            [self startFeedback];
            [_circleView setBgCircleColor:_balancedCircleBgColor];
            [_sliderHandle setBackgroundImage:_balancedHandleIcon forState:UIControlStateNormal];
            [_longBgBar setBackgroundImage:_balancedLongBarIcon forState:UIControlStateNormal];
            _circleView.progress = 0.0;
            [self startTimer];
            _willPlayFeedback = YES;
        }
    }
    else
    {
        [self stopTimer];
        _willPlayFeedback = NO;
        _circleView.progress = 0.0;
        [_circleView setBgCircleColor:_notBalancedCircleBgColor];
        [_sliderHandle setBackgroundImage:_notBalancedHandleIcon forState:UIControlStateNormal];
        [_longBgBar setBackgroundImage:_notBalancedLongBarIcon forState:UIControlStateNormal];
    }
    
}

-(void)startFeedback
{
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleHeavy];
        [generator prepare];
        [generator impactOccurred];
    } else {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}

-(void)startTimer
{
    _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(doCountDownTimer:) userInfo:nil repeats:YES];
}

-(void)stopTimer
{
    [_countDownTimer invalidate];
    _countDownTimer = nil;
}
- (void)destroy{
    [self stopTimer];
    [_motionManager stopAccelerometerUpdates];
}
-(void)doCountDownTimer:(NSTimer *)timer
{
    _circleView.progress += 0.01;
    
    if(_circleView.progress > 1.0)
    {
        [_motionManager stopAccelerometerUpdates];
        [self stopTimer];
        
        [_sliderHandle setBackgroundImage:_finishHandleIcon forState:UIControlStateNormal];
        _circleView.progress = 0.0;
        
        if(_delegate && [_delegate respondsToSelector:@selector(balanceCompleted)])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate balanceCompleted];
            });
            
        }
    }
}

- (void)dealloc
{
    [self stopTimer];
    [_motionManager stopAccelerometerUpdates];
}
@end
