#import <Foundation/Foundation.h>

@interface BYCLegacyEntry : NSObject
@property (nonatomic, readonly) NSString *key;
@property (nonatomic, readonly) NSString *value;
@end

@interface BYCLegacyDatabase : NSObject
-(id)initWithDatabasePath:(NSString *)databasePath;
-(NSArray*)getEntries;
@end
