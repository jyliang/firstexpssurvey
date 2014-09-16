//
//  SurveyView.m
//  Survey
//
//  Created by Jason Liang on 9/15/14.
//  Copyright (c) 2014 FirstExps Inc. All rights reserved.
//

#import "SurveyChooseView.h"
#import "Survey.h"
#import <QuartzCore/QuartzCore.h>

@implementation SurveyChooseView

- (instancetype)initWithFrame:(CGRect)frame
                       survey:(Survey *)survey
                      options:(MDCSwipeToChooseViewOptions *)options
{
    self = [super initWithFrame:frame options:options];
    if (self) {
        [self initBaseViews];
        _survey = survey;
        [self loadInfo];
    }
    return self;
}


- (void)initBaseViews {
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetWidth(self.bounds))];
    self.imageView.layer.cornerRadius = 5;
    self.imageView.clipsToBounds = YES;

    [self addSubview:self.imageView];
    [self sendSubviewToBack:self.imageView];
    self.activityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.imageView.frame), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)-CGRectGetHeight(self.imageView.frame))];
    self.activityLabel.backgroundColor = [UIColor whiteColor];
    self.activityLabel.textAlignment = NSTextAlignmentCenter;
    self.activityLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:15.0];
    [self addSubview:self.activityLabel];
    [self sendSubviewToBack:self.activityLabel];
}

- (void)loadInfo {
    self.activityLabel.text = self.survey.activityName;
    self.imageView.image = self.survey.getImage;

}

@end
