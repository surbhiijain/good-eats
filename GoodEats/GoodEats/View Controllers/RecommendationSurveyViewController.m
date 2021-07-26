//
//  RecommendationSurveyViewController.m
//  GoodEats
//
//  Created by Surbhi Jain on 7/26/21.
//

#import "RecommendationSurveyViewController.h"
#import "DishDetailsViewController.h"
#import "Dish.h"
#import "Restaurant.h"
#import "Post.h"

@interface RecommendationSurveyViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *timeSegControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tasteSegControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *adventureSegControl;

@property (nonatomic, strong) Dish *dish;

@end

@implementation RecommendationSurveyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)didTapDone:(id)sender {
    double dist = [self getSelectedDistance];
    BOOL taste = [self getTasteImportanceBool];
    BOOL new = [self getTrySomethingNewBool];
}

- (double) getSelectedDistance {
    switch (self.timeSegControl.selectedSegmentIndex) {
        case 0:
            return 1;
        case 1:
            return 5;
        case 2:
            return 15;
        case 3:
            return 30;
        default:
            break;
    }
    return 0;
}

- (BOOL) getTasteImportanceBool {
    switch (self.tasteSegControl.selectedSegmentIndex) {
        case 0:
            return TRUE;
        case 1:
            return FALSE;
        default:
            break;
    }
    return TRUE;
}

- (BOOL) getTrySomethingNewBool {
    switch (self.adventureSegControl.selectedSegmentIndex) {
        case 0:
            return FALSE;
        case 1:
            return TRUE;
        default:
            break;
    }
    return FALSE;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"dishDetailsSegue"]) {
        DishDetailsViewController *detailsVC = [segue destinationViewController];
        detailsVC.dish = self.dish;
    }
}

@end
