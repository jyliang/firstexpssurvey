//
//  SurveyCollectionViewCell.m
//  Survey
//
//  Created by Jason Liang on 9/15/14.
//  Copyright (c) 2014 FirstExps Inc. All rights reserved.
//

#import "SurveyCollectionViewCell.h"
#import "Survey.h"

@implementation SurveyCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)configWithSurvey:(Survey *)survey done:(BOOL)done {
    self.imageView.image = survey.getImage;
    self.imageView.alpha = done ? 1 : 0.5f;
}

@end
