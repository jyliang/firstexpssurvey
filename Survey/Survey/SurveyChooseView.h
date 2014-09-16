//
//  SurveyView.h
//  Survey
//
//  Created by Jason Liang on 9/15/14.
//  Copyright (c) 2014 FirstExps Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDCSwipeToChoose.h"

@class Survey;

@interface SurveyChooseView : MDCSwipeToChooseView

@property (nonatomic, strong, readonly) Survey *survey;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *activityLabel;

- (instancetype)initWithFrame:(CGRect)frame
                       survey:(Survey *)survey
                      options:(MDCSwipeToChooseViewOptions *)options;

@end
