//
//  BESearchVC.m
//  app
//
//  Created by qun on 2021/6/10.
//

#import "BESearchVC.h"
#import "BESearchView.h"

@interface BESearchVC () <BESearchViewDelegate>

@property (nonatomic, strong) BESearchView *searchView;

@end

@implementation BESearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.searchView];
}

#pragma mark - BESearchViewDelegate
- (void)searchView:(BESearchLayoutView *)view searchDidChanged:(NSString *)search {
    
}

- (void)searchView:(BESearchView *)view didTapCancel:(UIView *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getter
- (BESearchView *)searchView {
    if (_searchView) {
        return _searchView;
    }
    
    _searchView = [[BESearchView alloc] initWithFrame:self.view.frame];
    _searchView.delegate = self;
    return _searchView;
}

@end
