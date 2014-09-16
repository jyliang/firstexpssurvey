//
//  SurveyViewController.h
//  Survey
//
//  Created by Jason Liang on 9/15/14.
//  Copyright (c) 2014 FirstExps Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SurveyChooseView.h"

@interface SurveyViewController : UIViewController <MDCSwipeToChooseDelegate>

@property (nonatomic, strong) Survey *currentSurvey;
@property (nonatomic, strong) SurveyChooseView *frontCardView;
@property (nonatomic, strong) SurveyChooseView *backCardView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@end
