// Copyright (C) 2019 Beijing Bytedance Network Technology Co., Ltd.

#import "BEModernFilterPickerViewController.h"

#import <Masonry/Masonry.h>

#import "BEModernFilterPickerView.h"

#import "Effect.h"

@interface BEModernFilterPickerViewController ()<BEModernFilterPickerViewDelegate>

@property (nonatomic, strong) BEModernFilterPickerView *filterPickerView;
@property (nonatomic, copy) NSArray <BEFilterItem *> *filters;
@property (nonatomic, copy) NSArray <BEEffectItem *> *lipsticks;

@end

@implementation BEModernFilterPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.filterPickerView];
    [self.filterPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self loadData];
    [self setAllCellsUnSelected];
}

#pragma mark - public
- (void)setAllCellsUnSelected{
    [self.filterPickerView setAllCellsUnSelected];
}

- (void)setSelectItem:(NSString *)filterPath {
    [self.filterPickerView setSelectItem:filterPath];
}

#pragma mark - BEModernFilterPickerViewDelegate
- (void)filterPicker:(BEModernFilterPickerView *)pickerView didSelectFilter:(BEFilterItem *)filter {
    [[NSNotificationCenter defaultCenter] postNotificationName:BEEffectFilterDidChangeNotification object:nil userInfo:@{BEEffectNotificationUserInfoKey: filter}];
}

- (void)loadData {
    self.filters = self.dataManager.filterArray;
    [self.filterPickerView refreshWithFilters:self.filters];
}

#pragma mark - getter

- (BEModernFilterPickerView *)filterPickerView {
    if (!_filterPickerView) {
        _filterPickerView = [[BEModernFilterPickerView alloc] init];
        _filterPickerView.delegate = self;
    }
    return _filterPickerView;
}

@end
