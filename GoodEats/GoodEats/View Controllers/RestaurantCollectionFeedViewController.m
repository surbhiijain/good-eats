//
//  RestaurantCollectionFeedViewController.m
//  GoodEats
//
//  Created by Surbhi Jain on 7/21/21.
//

#import "RestaurantCollectionFeedViewController.h"
#import "PostCollectionCell.h"

@interface RestaurantCollectionFeedViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *posts;

@end

@implementation RestaurantCollectionFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self getPosts];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    
    layout.minimumLineSpacing = 15;
    layout.minimumInteritemSpacing = 15;
    
    CGFloat postsPerLine = 2;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (postsPerLine + 1)) / postsPerLine;
    CGFloat itemHeight = itemWidth * 3 / 4;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

- (void) getPosts {
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Post"];
    [postQuery orderByDescending:@"createdAt"];
    postQuery.limit = [self.restaurant.numCheckIns intValue];
    [postQuery includeKeys:@[@"image", @"dish", @"author"]];
    
    PFQuery *dishQuery = [PFQuery queryWithClassName:@"Dish"];
    [dishQuery whereKey:@"restaurantID" equalTo:self.restaurant.objectId];
    
    [postQuery whereKey:@"dish" matchesQuery:dishQuery];
    
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (!error) {
            self.posts = (NSMutableArray *) posts;
            [self.collectionView reloadData];
        } else {
            NSLog(@"Error getting posts: %@", error);
        }
    }];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PostCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCollectionCell" forIndexPath:indexPath];
    
    Post *post = self.posts[indexPath.item];
    
    cell.post = post;
    [cell refreshData];

    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}


@end
