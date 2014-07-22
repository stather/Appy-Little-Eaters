//
//  TargetCurrencyVC.h
//  Caxtonfx
//
//  Created by Nishant on 20/06/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TargetCurrencyVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    
    int selectedRow;
    NSString *searchText;
    NSString *selectedCurrency;
    BOOL status;
}

@property (nonatomic ,strong)  UISearchBar *searchBar;

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) NSMutableArray *allRatesMA;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *heightConstraint;


@end
