#ifndef yourlifeyourvoice_BYCConstants_h
#define yourlifeyourvoice_BYCConstants_h

typedef enum {
    BYCNotificationShowRootController_Reminder,
    BYCNotificationShowRootController_Talk,
    BYCNotificationShowRootController_Info,
    BYCNotificationShowRootController_Reports,
    BYCNotificationShowRootController_Tips,
} BYCNotificationShowRootControllerType;

#define BYCNotificationShowMenu @"BYCNotificationShowMenu"
#define BYCNotificationShowRootController @"BYCNotificationShowRootController"
#define BYCNotificationShowRootControllerKey @"BYCNotificationShowRootControllerKey"

#define BYCPhoneNumber @"1-800-448-3000"
#define BYCWebSite @"http://yourlifeyourvoice.org"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#endif