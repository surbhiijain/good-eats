//
//  LoginViewController.m
//  GoodEats
//
//  Created by Surbhi Jain on 7/12/21.
//

#import "LoginViewController.h"
#import "Parse/Parse.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)didTapLogin:(id)sender {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            [self performSegueWithIdentifier:@"loginSegue" sender:self];
        }
    }];
}

- (IBAction)didTapSignUp:(id)sender {
    
    PFUser *newUser = [PFUser user];
    
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    newUser[@"savedDishes"] = [[NSMutableArray alloc] init];
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            [self performSegueWithIdentifier:@"loginSegue" sender:self];
        }
    }];}

@end
