//
//  SurveyCollectionViewCell.h
//  Survey
//
//  Created by Jason Liang on 9/15/14.
//  Copyright (c) 2014 FirstExps Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Survey;
@interface SurveyCollectionViewCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (void)configWithSurvey:(Survey *)survey done:(BOOL)done;

@end
