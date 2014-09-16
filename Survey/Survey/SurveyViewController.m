//
//  SurveyViewController.m
//  Survey
//
//  Created by Jason Liang on 9/15/14.
//  Copyright (c) 2014 FirstExps Inc. All rights reserved.
//

#import "SurveyViewController.h"
#import "Survey.h"
#import "SurveyChooseView.h"
#import "SurveyCollectionViewCell.h"
#import "SurveyResult.h"

@interface SurveyViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *surveys;
@property (nonatomic, strong) NSMutableArray *surveysResult;

@end

@implementation SurveyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.surveys = [[self defaultSurvey] mutableCopy];
    self.surveysResult = [NSMutableArray array];

    self.bottomLabel.hidden = YES;

    self.frontCardView = [self popSurveyViewWithFrame:[self frontCardViewFrame]];
    [self.view addSubview:self.frontCardView];

    self.backCardView = [self popSurveyViewWithFrame:[self backCardViewFrame]];
    [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
}

#pragma mark - MDCSwipeToChooseDelegate Protocol Methods

// This is called when a user didn't fully swipe left or right.
- (void)viewDidCancelSwipe:(UIView *)view {
    NSLog(@"You couldn't decide on %@.", self.currentSurvey.activityName);
}

// This is called then a user swipes the view fully left or right.
- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    // MDCSwipeToChooseView shows "NOPE" on swipes to the left,
    // and "LIKED" on swipes to the right.
    SurveyResult *surveyResult = [[SurveyResult alloc] init];
    surveyResult.survey = self.currentSurvey;
    if (direction == MDCSwipeDirectionLeft) {
        surveyResult.hasDoneBefore = NO;
        NSLog(@"You noped %@.", self.currentSurvey.activityName);
    } else {
        surveyResult.hasDoneBefore = YES;
        NSLog(@"You liked %@.", self.currentSurvey.activityName);
    }

    // MDCSwipeToChooseView removes the view from the view hierarchy
    // after it is swiped (this behavior can be customized via the
    // MDCSwipeOptions class). Since the front card view is gone, we
    // move the back card to the front, and create a new back card.
    self.frontCardView = self.backCardView;
    if ((self.backCardView = [self popSurveyViewWithFrame:[self backCardViewFrame]])) {
        // Fade the back card into view.
        self.backCardView.alpha = 0.f;
        [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.backCardView.alpha = 1.f;
                         } completion:nil];
    }

    [self.collectionView performBatchUpdates:^{
        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.surveysResult.count inSection:0]]];
        [self.surveysResult addObject:surveyResult];
    } completion:^(BOOL finished) {

    }];

    if (!self.frontCardView) {
//        NSLog(@"the end");
        [self showResult];
    }
}

- (void)showResult {
//    self.collectionView.hidden = NO;
//    self.surveys = [[self defaultSurvey] mutableCopy];
//    [self.collectionView reloadData];
    self.topLabel.text = @"Good job!";

    NSString *allText = @"Amazing! You've done all of them! How did you do that!?";
    NSString *noneText = @"There's so much more for you to explore!";

    NSInteger explored = 0;
    for (SurveyResult *surveyResult in self.surveysResult) {
        if (surveyResult.hasDoneBefore) {
            explored ++;
        }
    }

    NSString *text;
    if (explored == 0) {
        text = noneText;
    } else if (explored == self.surveysResult.count) {
        text = allText;
    } else {
        NSMutableString *base = [[NSMutableString alloc] init];
        [base appendFormat:@"You have done %ld of them! %ld of them you haven't tried yet!", explored, self.surveysResult.count - explored];
        text = base;
    }
    self.bottomLabel.text = text;
    self.bottomLabel.hidden = NO;
}

#pragma mark - Internal Methods

- (void)setFrontCardView:(SurveyChooseView *)frontCardView {
    // Keep track of the person currently being chosen.
    // Quick and dirty, just for the purposes of this sample app.
    _frontCardView = frontCardView;
    self.currentSurvey = frontCardView.survey;
}

- (NSArray *)getSurveys:(NSArray *)surveyInfos {
    NSMutableArray *surveys = [NSMutableArray array];
    for (NSArray *surveyInfo in surveyInfos) {
        Survey *survey = [[Survey alloc] init];
        survey.activityName = surveyInfo[1];
        survey.activityPicFileName = surveyInfo[0];
        [surveys addObject:survey];
    }
    return surveys;
}

- (NSArray *)defaultSurvey {
    // It would be trivial to download these from a web service
    // as needed, but for the purposes of this sample app we'll
    // simply store them in memory.
    NSArray *info = @[@[@"acting", @"Acting on a movie set"],
                      @[@"archery", @"Archery"],
                      @[@"dance",@"Dance class"],
                      @[@"guitar",@"Learn to play guitar"],
                      @[@"karate",@"Karate"],
                      @[@"paintnite",@"Paint Nite"],
                      @[@"rockclimbing",@"Rcok Climbing"],
                      @[@"sailing",@"Sailing"],
                      @[@"sushi",@"Sushi Cooking Class"]
                      ];


    return [self getSurveys:info];
}

- (SurveyChooseView *)popSurveyViewWithFrame:(CGRect)frame {
    if ([self.surveys count] == 0) {
        return nil;
    }

    // UIView+MDCSwipeToChoose and MDCSwipeToChooseView are heavily customizable.
    // Each take an "options" argument. Here, we specify the view controller as
    // a delegate, and provide a custom callback that moves the back card view
    // based on how far the user has panned the front card view.
    MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
    options.delegate = self;
    options.threshold = 160.f;
    options.onPan = ^(MDCPanState *state){
        CGRect frame = [self backCardViewFrame];
        self.backCardView.frame = CGRectMake(frame.origin.x,
                                             frame.origin.y - (state.thresholdRatio * 10.f),
                                             CGRectGetWidth(frame),
                                             CGRectGetHeight(frame));
    };

    // Create a personView with the top person in the people array, then pop
    // that person off the stack.
    SurveyChooseView *personView = [[SurveyChooseView alloc] initWithFrame:frame survey:self.surveys[0] options:options];
    [self.surveys removeObjectAtIndex:0];
    return personView;
}

#pragma mark View Contruction

- (CGRect)frontCardViewFrame {
    CGFloat horizontalPadding = 10.f;
    CGFloat topPadding = 80.f;
//    CGFloat bottomPadding = 20.f;
    CGFloat width = CGRectGetWidth(self.view.frame) - (horizontalPadding * 2);
    return CGRectMake(horizontalPadding,
                      topPadding,
                      width,
                      width+60);
}

- (CGRect)backCardViewFrame {
    CGRect frontFrame = [self frontCardViewFrame];
    return CGRectMake(frontFrame.origin.x,
                      frontFrame.origin.y + 10.f,
                      CGRectGetWidth(frontFrame),
                      CGRectGetHeight(frontFrame));
}
#pragma mark Control Events

// Programmatically "nopes" the front card view.
- (void)nopeFrontCardView {
    [self.frontCardView mdc_swipe:MDCSwipeDirectionLeft];
}

// Programmatically "likes" the front card view.
- (void)likeFrontCardView {
    [self.frontCardView mdc_swipe:MDCSwipeDirectionRight];
}

#pragma mark - CollectionView Data Source and Delegates
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.surveysResult.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SurveyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SurveyCollectionViewCell class]) forIndexPath:indexPath];
    SurveyResult *surveyResult = self.surveysResult[indexPath.row];
    [cell configWithSurvey:surveyResult.survey done:surveyResult.hasDoneBefore];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 100);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

@end
