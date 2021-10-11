//
//  LTSupportAutomotiveVC.h
//  Auto Doctor
//
//  Created by Vijay on 09/10/21.
//

#import <UIKit/UIKit.h>
#import <LTSupportAutomotive/LTSupportAutomotive.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTSupportAutomotiveVC : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *adapterStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *rpmLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;

@property (weak, nonatomic) IBOutlet UILabel *rssiLabel;
@property (weak, nonatomic) IBOutlet UILabel *outgoingBytesNotification;
@property (weak, nonatomic) IBOutlet UILabel *incomingBytesNotification;

@end

NS_ASSUME_NONNULL_END
