//
//  SurveyResult.h
//  Survey
//
//  Created by Jason Liang on 9/15/14.
//  Copyright (c) 2014 FirstExps Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Survey;
@interface SurveyResult : NSObject

@property (nonatomic, strong) Survey *survey;
@property (nonatomic) BOOL hasDoneBefore;

@end
