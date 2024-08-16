//
//  TUICustomerServicePluginConfigDelegate.h
//  TUICustomer
//
//  Created by Role Wong on 8/15/24.
//


#ifndef TUICustomerServicePluginConfigDelegate_h
#define TUICustomerServicePluginConfigDelegate_h

#import <Foundation/Foundation.h>
#import <TUICustomerServicePlugin/TUICustomerServicePluginConfig.h>


@interface TUICustomerServicePluginDelegate : NSObject <TUICustomerServicePluginConfigDataSource>

@property (nonatomic, strong) NSArray<TUICustomerServicePluginMenuCellData *> *customMenuItems;

+ (instancetype) sharedInstance;

@end


#endif /* TUICustomerServicePluginConfigDelegate_h */
