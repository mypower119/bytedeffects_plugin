//
//  AlgorithmItem.h
//  BytedEffects
//
//  Created by qun on 2020/8/21.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEAlgorithmKey.h"
#import "BEButtonItem.h"

//   {zh} / 算法功能项     {en} /Algorithm function item 
@interface BEAlgorithmItem : BEButtonItem

- (instancetype)initWithKey:(BEAlgorithmKey *)key;

@property (nonatomic, strong) BEAlgorithmKey *key;
@property (nonatomic, strong) NSArray<BEAlgorithmKey *> *dependency;
@property (nonatomic, strong) NSString *dependencyToast;

@end

@interface BEAlgorithmItemGroup : BEAlgorithmItem

@property (nonatomic, strong) NSArray<BEAlgorithmItem *> *items;
@property (nonatomic, assign) BOOL scrollable;

@end
