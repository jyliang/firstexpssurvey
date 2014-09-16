//
//  Survey.m
//  Survey
//
//  Created by Jason Liang on 9/15/14.
//  Copyright (c) 2014 FirstExps Inc. All rights reserved.
//

#import "Survey.h"

@implementation Survey


- (UIImage *)getImage {
    return [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", self.activityPicFileName]];
}

@end
