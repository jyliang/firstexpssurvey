//
//  Survey.h
//  Survey
//
//  Created by Jason Liang on 9/15/14.
//  Copyright (c) 2014 FirstExps Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Survey : NSObject

@property (nonatomic, strong) NSString *activityName;
@property (nonatomic, strong) NSString *activityPicFileName;

- (UIImage *)getImage;

@end
