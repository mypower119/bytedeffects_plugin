//
//  BESportsAssistantOverVC.m
//  BEAlgorithm
//
//  Created by liqing on 2021/7/15.
//

#import "BESportsAssistantOverVC.h"
#import "BECommonUtils.h"
#import "Masonry.h"
#import "BEDeviceInfoHelper.h"
#import "UIView+Toast.h"
#import "Toast.h"
@interface BESportsAssistantOverVC ()
@end

#define iPhoneX [BEDeviceInfoHelper isIPhoneXSeries]

@implementation BESportsAssistantOverVC
{
    UIButton* _backBtn;
    UIView* mainPanel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [BECommonUtils colorWithHexString:@"#F7F8FA"];
    
    [self buildTopUI];
    [self buildMiddleUI];
    [self buildBottomUI];
}

-(void)buildTopUI
{
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 16, 16)];
    btn.backgroundColor = [UIColor clearColor];
    UIImage* icon = [UIImage imageNamed:@"ic_sa_back"];
    [btn setBackgroundImage:icon forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(16);
        make.top.equalTo(self.view).mas_offset((iPhoneX ? 44 : 20) + 14);
        make.width.mas_equalTo(btn.bounds.size.width);
        make.height.mas_equalTo(btn.bounds.size.height);
    }];
    
    _backBtn = btn;
}

-(void)buildMiddleUI
{
    mainPanel = [UIView new];
    [self.view addSubview:mainPanel];
    mainPanel.backgroundColor = [UIColor whiteColor];
    [mainPanel.layer setMasksToBounds:YES];
    [mainPanel.layer setCornerRadius:8];
    mainPanel.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    mainPanel.layer.shadowRadius = 8;
    
    
    [mainPanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(16);
        make.right.equalTo(self.view).mas_offset(-16);
        make.top.equalTo(_backBtn.mas_bottom).mas_offset(64);
        make.height.mas_equalTo(mainPanel.mas_width).multipliedBy(1.32);
    }];
    
    UIImageView* imgView = [UIImageView new];
    UIImage* img = [UIImage imageNamed:_finishLogo];
    imgView.image = img;
    [mainPanel addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainPanel);
        make.right.equalTo(mainPanel);
        make.top.equalTo(mainPanel);
        make.height.mas_equalTo(imgView.mas_width).multipliedBy(1);
    }];
    
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 64, 40)];
        label.layer.masksToBounds=YES;
        label.layer.backgroundColor = [UIColor clearColor].CGColor;
        label.layer.borderWidth =1.0f;
        label.layer.borderColor = [UIColor clearColor].CGColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"DINAlternate-Bold" size:24];
        label.textColor = [BECommonUtils colorWithHexString:@"#1D2129"];
        label.text = _count;
        [mainPanel addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgView.mas_bottom).mas_offset(24);
            make.left.equalTo(mainPanel).mas_offset(71);
            make.height.mas_equalTo(label.bounds.size.height);
            make.width.mas_equalTo(label.bounds.size.width);
        }];
        {
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 48, 20)];
            label1.layer.masksToBounds=YES;
            label1.layer.backgroundColor = [UIColor clearColor].CGColor;
            label1.layer.borderWidth =1.0f;
            label1.layer.borderColor = [UIColor clearColor].CGColor;
            label1.textAlignment = NSTextAlignmentCenter;
            label1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
            label1.textColor = [BECommonUtils colorWithHexString:@"#86909C"];
            label1.text = NSLocalizedString(@"sport_assistance_count_suffix", nil);
            [mainPanel addSubview:label1];
            [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(label.mas_bottom);
                make.centerX.equalTo(label);
            }];
        }
    }
    
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 64, 40)];
        label.layer.masksToBounds=YES;
        label.layer.backgroundColor = [UIColor clearColor].CGColor;
        label.layer.borderWidth =1.0f;
        label.layer.borderColor = [UIColor clearColor].CGColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"DINAlternate-Bold" size:24];
        label.textColor = [BECommonUtils colorWithHexString:@"#1D2129"];
        label.text = _timeStr;
        [mainPanel addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgView.mas_bottom).mas_offset(24);
            make.right.equalTo(mainPanel).mas_offset(-71);
            make.height.mas_equalTo(label.bounds.size.height);
            make.width.mas_equalTo(label.bounds.size.width);
        }];
        {
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 48, 20)];
            label1.layer.masksToBounds=YES;
            label1.layer.backgroundColor = [UIColor clearColor].CGColor;
            label1.layer.borderWidth =1.0f;
            label1.layer.borderColor = [UIColor clearColor].CGColor;
            label1.textAlignment = NSTextAlignmentCenter;
            label1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
            label1.textColor = [BECommonUtils colorWithHexString:@"#86909C"];
            label1.text = NSLocalizedString(@"sport_assistance_time_suffix", nil);
            [mainPanel addSubview:label1];
            [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(label.mas_bottom);
                make.centerX.equalTo(label);
            }];
        }
    }
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 32)];
    line.backgroundColor = [BECommonUtils colorWithHexString:@"#E5E8EF"];
    [mainPanel addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mainPanel).mas_offset(381);
        make.centerX.equalTo(mainPanel);
    }];
    
}

-(void)buildBottomUI
{
    UIView* bottomPanel = [[UIView alloc]initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, 100)];
    bottomPanel.backgroundColor = [BECommonUtils colorWithHexString:@"#F7F8FA"];
    [self.view addSubview:bottomPanel];
    [bottomPanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mainPanel.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).mas_offset(iPhoneX ? -34 : 0);
    }];
    
    {
        UIView* panel = [[UIView alloc]initWithFrame:CGRectMake(0,0, 52, 78)];
        panel.backgroundColor = [BECommonUtils colorWithHexString:@"#F7F8FA"];
        [bottomPanel addSubview:panel];
        [panel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bottomPanel);
            make.left.equalTo(bottomPanel).mas_offset(87.5);
            make.width.mas_equalTo(panel.bounds.size.width);
            make.height.mas_equalTo(panel.bounds.size.height);
        }];
        
        UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 52, 52)];
        btn.backgroundColor = [UIColor clearColor];
        UIImage* icon = [UIImage imageNamed:@"ic_sa_over_back"];
        [btn setBackgroundImage:icon forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        [panel addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(panel);
            make.top.equalTo(panel);
        }];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 24, 20)];
        label.layer.masksToBounds=YES;
        label.layer.backgroundColor = [UIColor clearColor].CGColor;
        label.layer.borderWidth =1.0f;
        label.layer.borderColor = [UIColor clearColor].CGColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        label.textColor = [BECommonUtils colorWithHexString:@"#86909C"];
        label.text = NSLocalizedString(@"sport_assistance_exit", nil);
        [panel addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(btn.mas_bottom).mas_offset(6);
            make.centerX.equalTo(btn);
        }];
    }
    
    {
        UIView* panel = [[UIView alloc]initWithFrame:CGRectMake(0,0, 52, 78)];
        panel.backgroundColor = [BECommonUtils colorWithHexString:@"#F7F8FA"];
        [bottomPanel addSubview:panel];
        [panel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bottomPanel);
            make.right.equalTo(bottomPanel).mas_offset(-87.5);
            make.width.mas_equalTo(panel.bounds.size.width);
            make.height.mas_equalTo(panel.bounds.size.height);
        }];
        
        UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 52, 52)];
        btn.backgroundColor = [UIColor clearColor];
        UIImage* icon = [UIImage imageNamed:@"ic_sa_save"];
        [btn setBackgroundImage:icon forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
        [panel addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(panel);
            make.top.equalTo(panel);
        }];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 24, 20)];
        label.layer.masksToBounds=YES;
        label.layer.backgroundColor = [UIColor clearColor].CGColor;
        label.layer.borderWidth =1.0f;
        label.layer.borderColor = [UIColor clearColor].CGColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        label.textColor = [BECommonUtils colorWithHexString:@"#86909C"];
        label.text = NSLocalizedString(@"sport_assistance_save", nil);
        [panel addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(btn.mas_bottom).mas_offset(6);
            make.centerX.equalTo(btn);
        }];
    }
}

-(void)backClick
{
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
}

-(void)saveClick
{
    CGSize sz;
    sz.width = mainPanel.bounds.size.width * 3;
    sz.height = mainPanel.bounds.size.height * 3;
    
    UIGraphicsBeginImageContext(CGSizeMake(sz.width, sz.height));
    [mainPanel drawViewHierarchyInRect:CGRectMake(0, 0, sz.width, sz.height) afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData* imageData =  UIImagePNGRepresentation(image);
    UIImage* pngImage = [UIImage imageWithData:imageData];
    UIImageWriteToSavedPhotosAlbum(pngImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"saved to album!");
    [self.view makeToast:NSLocalizedString(@"sport_assistance_save_album", nil)];
}


@end
