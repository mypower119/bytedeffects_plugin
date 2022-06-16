//
//  BEHairParserAlgorithmTask.h
//  BytedEffects
//
//  Created by QunZhang on 2020/8/7.
//  Copyright © 2020 ailab. All rights reserved.
//

#import "BEAlgorithmTask.h"

@protocol BEHairParserResourceProvider <BEAlgorithmResourceProvider>

- (const char *)hairParserModelPath;

@end

@interface BEHairParserAlgorithmResult : NSObject

@property (nonatomic, assign) unsigned char *mask;
@property (nonatomic, assign) int *size;

@end

@interface BEHairParserAlgorithmTask : BEAlgorithmTask

+ (BEAlgorithmKey *)HAIR_PARSER;

@end
