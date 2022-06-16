//
//  BEButtonItem.h
//  BytedEffects
//
//  Created by qun on 2020/8/21.
//  Copyright © 2020 ailab. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BEButtonItem : NSObject

- (instancetype)initWithSelectImg:(NSString *)selectImg unselectImg:(NSString *)unselectImg title:(NSString *)title desc:(NSString *)desc;

@property (nonatomic, strong) NSString *selectImg;
@property (nonatomic, strong) NSString *unselectImg;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *tipTitle;
@property (nonatomic, strong) NSString *tipDesc;

@end
