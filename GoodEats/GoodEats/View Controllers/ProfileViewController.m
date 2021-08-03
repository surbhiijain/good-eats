//
//  ProfileViewController.m
//  GoodEats
//
//  Created by Surbhi Jain on 7/12/21.
//

#import "ProfileViewController.h"
#import "Parse/Parse.h"
#import "LoginViewController.h"
#import "SceneDelegate.h"
#import "PostCollectionCell.h"
#import "Post.h"
#import "PostDetailViewController.h"
#import "APIManager.h"
#import <ChameleonFramework/Chameleon.h>

@interface ProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numCheckInsLabel;

@property (weak, nonatomic) IBOutlet UIButton *mostRecentGoodEatButton1;
@property (weak, nonatomic) IBOutlet UIButton *mostRecentGoodEatButton2;
@property (weak, nonatomic) IBOutlet UIButton *mostRecentGoodEatButton3;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic, strong) NSArray *topThreeRecentPosts;

@property (nonatomic, strong) Post *selectedPost;


@property (nonatomic, strong) PFUser *user;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = [PFUser currentUser];
    
    self.usernameLabel.text = self.user.username;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self fetchAllPosts];
    [self fetchTopThreeRecentDishes];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    
    layout.minimumLineSpacing = 15;
    layout.minimumInteritemSpacing = 15;
    
    CGFloat postsPerLine = 2;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (postsPerLine + 1)) / postsPerLine;
    CGFloat itemHeight = itemWidth * 3 / 4;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

- (void) fetchAllPosts {
    
    [[APIManager shared] fetchAllPostsWithOrderKey:@"createdAt"
                                         withLimit:nil
                                        withAuthor:self.user
                                          withKeys:@[@"image", @"author", @"dish"]
                                   withRestaurants:nil
                                          withDish:nil
                                withSecondaryOrder:nil
                                    withCompletion:^(NSMutableArray *posts, NSError *error) {
        if (error) {
            NSLog(@"Error getting posts: %@", error);
            return;
        }
        self.posts = (NSMutableArray *) posts;
        self.numCheckInsLabel.text = [NSString stringWithFormat:@"%ld check-ins", self.posts.count];
        [self.collectionView reloadData];
    }];
}

- (void) fetchTopThreeRecentDishes {
    
    [[APIManager shared] fetchAllPostsWithOrderKey:@"rating"
                                         withLimit:@3
                                        withAuthor:self.user
                                          withKeys:@[@"dish", @"author"]
                                   withRestaurants:nil
                                          withDish:nil
                                withSecondaryOrder:@"createdAt"
                                    withCompletion:^(NSMutableArray *posts, NSError *error) {
        if (error) {
            NSLog(@"Error getting posts: %@", error);
            return;
        }
        self.topThreeRecentPosts = posts;
        [self displayTopThreeRecentPosts:posts];
    }];
}

- (void) displayTopThreeRecentPosts: (NSArray *) posts {
    NSMutableArray *dishButtons = [[NSMutableArray alloc] initWithArray:@[self.mostRecentGoodEatButton1, self.mostRecentGoodEatButton2, self.mostRecentGoodEatButton3]];
    
    for (Post *post in posts) {
        UIButton *button = dishButtons[0];
        [dishButtons removeObject:button];
        
        NSString *text = [NSString stringWithFormat:@"%@ @ %@", post.dish.name, post.dish.restaurantName];
        [button setTitle:text forState:UIControlStateNormal];
        [button setBackgroundColor:nil];
        [button setTitleColor:FlatTeal forState:UIControlStateNormal];
    }
    for (UIButton *button in dishButtons) {
        [button setHidden:TRUE];
    }
}
- (IBAction)didTapRecentPostHighlightButton:(UIButton *)sender {
    self.selectedPost = self.topThreeRecentPosts[sender.tag];
    [self performSegueWithIdentifier:@"postDetailSegue" sender:self];
}



- (IBAction)didTapLogout:(id)sender {
    
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    sceneDelegate.window.rootViewController = loginViewController;
    
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
    }];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PostCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCollectionCell" forIndexPath:indexPath];
    
    Post *post = self.posts[indexPath.item];
    
    cell.post = post;
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Post *post = self.posts[indexPath.item];
    self.selectedPost = post;
    [self performSegueWithIdentifier:@"postDetailSegue" sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"postDetailSegue"]) {
        PostDetailViewController *postDetails = [segue destinationViewController];
        postDetails.post = self.selectedPost;
    }
}

@end
