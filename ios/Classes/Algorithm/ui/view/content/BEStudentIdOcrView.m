//
//  BEStudentIdOcrView.m
//  BytedEffects
//
//  Created by Bytedance on 2020/9/3.
//  Copyright © 2020 ailab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BEStudentIdOcrView.h"
#import <UIKit/UIKit.h>
#import "Masonry.h"

@interface BEStudentIdOcrView ()

@property (nonatomic, strong) UIImageView *ocrImageView;
@property (nonatomic, strong) UIButton    *ocrCloseButton;
@property (nonatomic, strong) UILabel     *ocrResultLabel;

@end

@implementation BEStudentIdOcrView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.ocrImageView];
        [self addSubview:self.ocrCloseButton];
        [self addSubview:self.ocrResultLabel];
        
        [self.ocrCloseButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.leading.mas_equalTo(self.mas_leading).with.offset(40);
            make.top.mas_equalTo(self.mas_top).with.offset(50);
        }];
        
        [self.ocrImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self);
        }];
        
        [self.ocrResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(300, 60));
            make.leading.mas_equalTo(self).offset(40);
            make.bottom.mas_equalTo(self).offset(-100);
        }];
        
        self.backgroundColor = [UIColor grayColor];
    
    }
    return self;
}
        
- (void) studentIdOcrSetImage:(UIImage *)image{
    if (image == nil)
        return ;
    
    self.ocrImageView.hidden = NO;
    [self.ocrImageView setImage:image];
}
        
- (void)setOcrResultImage:(UIImage *)image  numbers:(NSString*)numbers{
    [self.ocrImageView setImage:image];
    self.ocrResultLabel.hidden = NO;
    self.ocrCloseButton.hidden = NO;
    [self.ocrResultLabel setText:numbers];
}

#pragma mark - gettter
// image view to show the result
- (UIImageView *) ocrImageView{
    if (!_ocrImageView){
        _ocrImageView = [[UIImageView alloc] init];
        _ocrImageView.contentMode = UIViewContentModeScaleAspectFit;
        _ocrImageView.hidden = YES;
    }
    return _ocrImageView;
}

// button to close the result
- (UIButton *) ocrCloseButton{
    if (!_ocrCloseButton){
        _ocrCloseButton = [[UIButton alloc] init];
        _ocrCloseButton.hidden = YES;
        _ocrCloseButton.enabled = YES;
        [_ocrCloseButton setImage:[UIImage imageNamed:@"ic_close"] forState:UIControlStateNormal ];
        
        [_ocrCloseButton setImage:[UIImage imageNamed:@"ic_close"] forState:UIControlStateSelected | UIControlStateHighlighted];
        [_ocrCloseButton addTarget:self action:@selector(onCloseButtonClosed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ocrCloseButton;
}

// label to show the result
- (UILabel *) ocrResultLabel{
    if (!_ocrResultLabel){
        _ocrResultLabel = [[UILabel alloc] init];
        _ocrResultLabel.hidden = YES;
    }
    return _ocrResultLabel;
}

# pragma mark - selector
- (void)onCloseButtonClosed{
    [self.ocrImageView setImage:nil];
    self.ocrCloseButton.hidden = YES;
    self.ocrResultLabel.hidden = YES;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(studentIdOcrClose)]){
        [self.delegate studentIdOcrClose];
    }
}
@end
