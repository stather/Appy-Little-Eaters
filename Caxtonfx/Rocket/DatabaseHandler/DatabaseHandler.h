#import <Foundation/Foundation.h>
#import<sqlite3.h>

@interface DatabaseHandler : NSObject
{
	sqlite3 *database;
	
}


// Declaration of DataBase Creation and Database Path Location fetching Methods
-(NSString *) dataFilePath;
-(void) checkAndCreateDatabase;
-(void)executeQuery:(NSString *)query;
-(NSMutableArray *)fetchingDataFromTable:(NSString *)query;
-(NSString *)getDataValue:(NSString *)query;
-(BOOL)recordExistOrNot:(NSString *)query;
-(int)gettingNumberOfrecords:(NSString *)query;
-(NSMutableArray *)fetchingDatesFromTable:(NSString *)query;
-(NSMutableArray *)fetchingEventDetailsFromTable:(NSString *)query;
-(NSMutableArray *)fetchingBanksDetailsFromTable:(NSString *)query;
- (NSMutableArray*) getData:(NSString *)query;

-(NSMutableArray *)fetchingGlobalRatesFromTable:(NSString *)query;
-(NSMutableArray *)fetchingHistoryDataFromTable:(NSString *)query;


+ (DatabaseHandler *)getSharedInstance;
@end
