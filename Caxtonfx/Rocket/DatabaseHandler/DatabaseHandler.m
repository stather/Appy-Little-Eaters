//
//  DatabaseHandler.m
//  cfx
//
//  Created by Amzad on 10/10/12.
//
//

#import "DatabaseHandler.h"

@implementation DatabaseHandler
#pragma mark -
#pragma mark Creating Database if that not exists


+ (DatabaseHandler *)getSharedInstance
{
    static DatabaseHandler *sharedHandler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHandler = [[self alloc] init];
    });
    return sharedHandler;
}


-(NSString *) dataFilePath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:DatabaseName];
}

-(void) checkAndCreateDatabase{
	// check if the SQL database has already been saved to the users phone, if not then copy it over
	BOOL success;
	
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	// Check if the database has already been created in the users filesystem
	success = [fileManager fileExistsAtPath:[self dataFilePath]];
	
	// If the database already exists then return without doing anything
	if(success)
	{
		//NSLog(@"Existed");
		return;
	}
	else
		NSLog(@"Not Existed");
	
	// If not then proceed to copy the database from the application to the users filesystem
	
	// Get the path to the database in the application package
	NSString *DatabasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DatabaseName];
	NSLog(@"DatabasePathFromApp - >%@",DatabasePathFromApp);
    
    
    
	// Copy the database from the package to the users filesystem
	[fileManager copyItemAtPath:DatabasePathFromApp toPath:[self dataFilePath] error:nil];
	
}

/*==================================================================
 METHOD FOR INSERTING DATA IN DATABASE
 ==================================================================*/
-(void)executeQuery:(NSString *)query
{
    sqlite3_stmt *statement;
    //NSLog(@"query: %@",query);
	if(sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK)
	{
        int SQL =sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, NULL);
		if (SQL == SQLITE_OK)
		{
			if (sqlite3_step(statement) != SQLITE_DONE)
			{
				sqlite3_finalize(statement);
			}
		}
		else
		{
			NSLog(@"query Statement Not Compiled %@ - ERROR CODE: %i",query, SQL);
		}
		sqlite3_finalize(statement);
		sqlite3_close(database);
	}
	else
	{
		NSLog(@"Data not Opened");
	}
}

/*==================================================================
 METHOD FOR Updating Tables IN DATABASE
 ==================================================================*/
-(void)executeQueryUpdate:(NSString *)query
{
    sqlite3_stmt *statement;
	if(sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK)
	{
		if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)
		{
			if (sqlite3_step(statement) != SQLITE_DONE)
			{
				sqlite3_finalize(statement);
			}
		}
		else
		{
			@throw [NSException exceptionWithName:@"executeQueryUpdate" reason:query userInfo:nil];
		}
		
		sqlite3_finalize(statement);
		sqlite3_close(database);
	}
	else
	{
		NSLog(@"Data not Opened");
	}
}

/*==================================================================
 METHOD FOR Fetching DATA FROM DATABASE
 ==================================================================*/

-(NSMutableArray *)fetchingDataFromTable:(NSString *)query
{
	//////NSLog(@"enter......");
	NSString *idToReturn;
	NSMutableArray *temp= [NSMutableArray array];
	//////NSLog(@"temp :- %@ and count = %d",temp,[temp count]);
	if(sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK)
	{
		sqlite3_stmt *statement;
		if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)==SQLITE_OK)
		{
			while(sqlite3_step(statement)==SQLITE_ROW)
			{
				const char *s=(char *)sqlite3_column_text(statement, 0);
				if(s==NULL)
				{
					idToReturn=@"";
				}
				else
				{
					idToReturn =[NSString stringWithUTF8String:s];
				}
				if ([idToReturn length] != 0)
				{
					[temp addObject:idToReturn];
				}
			}
            
            if(sqlite3_errmsg(database))
            {
                NSLog(@" error %s,",sqlite3_errmsg(database));
            }
			sqlite3_finalize(statement);
			sqlite3_close(database);
		}
	}
	return temp;
}


/*==================================================================
 METHOD FOR Fetching DATA FROM DATABASE
 ==================================================================*/
-(NSString *)getDataValue:(NSString *)query
{
	NSString *valueToReturn=@"";
	if(sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK)
	{
		sqlite3_stmt *statement;
		if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)==SQLITE_OK)
		{
			if (sqlite3_step(statement)==SQLITE_ROW)
			{
				const char *value1=(char *)sqlite3_column_text(statement,0);
				if(value1==NULL)
				{
					valueToReturn=@"";
				}
				else
				{
					valueToReturn =[NSString stringWithUTF8String:value1];
				}
			}
            
            if(sqlite3_errmsg(database))
            {
                NSLog(@" error %s,",sqlite3_errmsg(database));
            }
            
			sqlite3_finalize(statement);
			sqlite3_close(database);
		}
	}
	return valueToReturn ;
}


/*==================================================================
 METHOD FOR CHECKING WHETHER RECORD EXISTS OR NOT IN DATABASE
 ==================================================================*/

-(BOOL)recordExistOrNot:(NSString *)query{
	BOOL recordExist=NO;
	if(sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK)
	{
		sqlite3_stmt *statement;
		if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)==SQLITE_OK)
		{
			if (sqlite3_step(statement)==SQLITE_ROW)
			{
				recordExist=YES;
			}
			else
			{
				NSLog(@"%s,",sqlite3_errmsg(database));
			}
			sqlite3_finalize(statement);
			sqlite3_close(database);
		}
	}
	return recordExist;
}



-(int)gettingNumberOfrecords:(NSString *)query
{
	int count = 0;
	if(sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK)
	{
		sqlite3_stmt *statement;
		if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)==SQLITE_OK)
		{
			
			//Loop through all the returned rows (should be just one)
            while( sqlite3_step(statement) == SQLITE_ROW )
            {
                count = sqlite3_column_int(statement, 0);
            }
		}
		else {
			NSLog(@"%s,",sqlite3_errmsg(database));
		}
		
		sqlite3_finalize(statement);
		sqlite3_close(database);
	}
	return count;
}




/*==================================================================
 METHOD FOR Fetching STARTDATE AND END DATE FROM DATABASE
 ==================================================================*/

-(NSMutableArray *)fetchingDatesFromTable:(NSString *)query
{
	NSString *idToReturn;
	NSMutableArray *returnArray = [NSMutableArray new];
	if(sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK)
	{
		sqlite3_stmt *statement;
		if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)==SQLITE_OK)
		{
			while(sqlite3_step(statement)==SQLITE_ROW)
			{
				NSMutableDictionary *temp= [NSMutableDictionary new];
				const char *s;
				s=(char *)sqlite3_column_text(statement, 0);
				if(s==NULL)
				{
					idToReturn=@"";
				}
				else
				{
					idToReturn =[NSString stringWithUTF8String:s];
				}
				[temp setObject:idToReturn forKey:@"mthyear"];
				
				if (temp != nil)
				{
					[returnArray addObject:temp];
                    
					temp = nil;
				}
				
			}
            
            if(sqlite3_errmsg(database))
            {
                NSLog(@" error %s,",sqlite3_errmsg(database));
            }
			sqlite3_finalize(statement);
			sqlite3_close(database);
		}
	}
	return returnArray;
}

/*==================================================================
 METHOD FOR Fetching Event Details FROM DATABASE
 ==================================================================*/

-(NSMutableArray *)fetchingEventDetailsFromTable:(NSString *)query
{
	NSLog(@"QUERY : %@",query);
    
	NSString *idToReturn=@"";
	NSMutableArray *returnArray = [NSMutableArray new];
	if(sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK)
	{
		sqlite3_stmt *statement;
		if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)==SQLITE_OK)
		{
			while(sqlite3_step(statement)==SQLITE_ROW)
			{
				NSMutableDictionary *temp= [NSMutableDictionary new];
				const char *s;
                
                int i= sqlite3_column_int(statement, 0);
                [temp setObject:[NSString stringWithFormat:@"%d",i] forKey:@"id"];
                
				s=(char *)sqlite3_column_text(statement, 1);
				if(s==NULL)
				{
					idToReturn=@"";
				}
				else
				{
					idToReturn =[NSString stringWithUTF8String:s];
				}
				[temp setObject:idToReturn forKey:@"source"];
				
				s=(char *)sqlite3_column_text(statement, 2);
				if(s==NULL)
				{
					idToReturn=@"";
				}
				else
				{
					idToReturn =[NSString stringWithUTF8String:s];
				}
				[temp setObject:idToReturn forKey:@"target"];
				
				s=(char *)sqlite3_column_text(statement, 3);
				if(s==NULL)
				{
					idToReturn=@"";
				}
				else
				{
					idToReturn =[NSString stringWithUTF8String:s];
				}
				[temp setObject:idToReturn forKey:@"name"];
				
				s=(char *)sqlite3_column_text(statement, 4);
				if(s==NULL)
				{
					idToReturn=@"";
				}
				else
				{
					idToReturn =[NSString stringWithUTF8String:s];
				}
				[temp setObject:idToReturn forKey:@"date"];
				
				s=(char *)sqlite3_column_text(statement, 5);
				if(s==NULL)
				{
					idToReturn=@"";
				}
				else
				{
					idToReturn =[NSString stringWithUTF8String:s];
				}
				[temp setObject:idToReturn forKey:@"mthyear"];
                s=(char *)sqlite3_column_text(statement, 6);
				if(s==NULL)
				{
					idToReturn=@"";
				}
				else
				{
					idToReturn =[NSString stringWithUTF8String:s];
				}
				[temp setObject:idToReturn forKey:@"timestamp"];
				
				s=(char *)sqlite3_column_text(statement, 7);
				if(s==NULL)
				{
					idToReturn=@"";
				}
				else
				{
					idToReturn =[NSString stringWithUTF8String:s];
				}
				[temp setObject:idToReturn forKey:@"image"];
                
                s=(char *)sqlite3_column_text(statement, 8);
				if(s==NULL)
				{
					idToReturn=@"";
				}
				else
				{
					idToReturn =[NSString stringWithUTF8String:s];
				}
				[temp setObject:idToReturn forKey:@"multiplier"];
				
				if (temp != nil)
				{
					[returnArray addObject:temp];
                    
					temp = nil;
				}
				
			}
            
            if(sqlite3_errmsg(database))
            {
                NSLog(@" error %s,",sqlite3_errmsg(database));
            }
            
			sqlite3_finalize(statement);
			sqlite3_close(database);
		}
	}
	return returnArray;
	
}

/*==================================================================
 METHOD FOR Fetching Banks Details FROM DATABASE
 ==================================================================*/

-(NSMutableArray *)fetchingBanksDetailsFromTable:(NSString *)query
{
	
	NSString *idToReturn=@"";
	NSMutableArray *returnArray = [NSMutableArray new];
	if(sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK)
	{
		sqlite3_stmt *statement;
		if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)==SQLITE_OK)
		{
			while(sqlite3_step(statement)==SQLITE_ROW)
			{
				NSMutableDictionary *temp= [NSMutableDictionary new];
				const char *s;
                
                
                int i= sqlite3_column_int(statement, 0);
                [temp setObject:[NSString stringWithFormat:@"%d",i] forKey:@"id"];
                
				s=(char *)sqlite3_column_text(statement, 1);
				if(s==NULL)
				{
					idToReturn=@"";
				}
				else
				{
					idToReturn =[NSString stringWithUTF8String:s];
				}
				[temp setObject:idToReturn forKey:@"institution_name"];
				
				s=(char *)sqlite3_column_text(statement, 2);
				if(s==NULL)
				{
					idToReturn=@"";
				}
				else
				{
					idToReturn =[NSString stringWithUTF8String:s];
				}
				[temp setObject:idToReturn forKey:@"product_name"];
				
				s=(char *)sqlite3_column_text(statement, 3);
				if(s==NULL)
				{
					idToReturn=@"";
				}
				else
				{
					idToReturn =[NSString stringWithUTF8String:s];
				}
				[temp setObject:idToReturn forKey:@"transaction_fee"];
				
				s=(char *)sqlite3_column_text(statement, 4);
				if(s==NULL)
				{
					idToReturn=@"";
				}
				else
				{
					idToReturn =[NSString stringWithUTF8String:s];
				}
				[temp setObject:idToReturn forKey:@"conversion_fee"];
				
				s=(char *)sqlite3_column_text(statement, 5);
				if(s==NULL)
				{
					idToReturn=@"";
				}
				else
				{
					idToReturn =[NSString stringWithUTF8String:s];
				}
				[temp setObject:idToReturn forKey:@"one_off_fee"];
				
				s=(char *)sqlite3_column_text(statement, 6);
				if(s==NULL)
				{
					idToReturn=@"";
				}
				else
				{
					idToReturn =[NSString stringWithUTF8String:s];
				}
				[temp setObject:idToReturn forKey:@"account_id"];
                
                s=(char *)sqlite3_column_text(statement, 7);
				if(s==NULL)
				{
					idToReturn=@"";
				}
				else
				{
					idToReturn =[NSString stringWithUTF8String:s];
				}
				[temp setObject:idToReturn forKey:@"country"];
                
                s=(char *)sqlite3_column_text(statement, 8);
				if(s==NULL)
				{
					idToReturn=@"";
				}
				else
				{
					idToReturn =[NSString stringWithUTF8String:s];
				}
				[temp setObject:idToReturn forKey:@"logo"];
                s=(char *)sqlite3_column_text(statement, 9);
				if(s==NULL)
				{
					idToReturn=@"";
				}
				else
				{
					idToReturn =[NSString stringWithUTF8String:s];
				}
				[temp setObject:idToReturn forKey:@"base"];
                s=(char *)sqlite3_column_text(statement, 10);
				if(s==NULL)
				{
					idToReturn=@"";
				}
				else
				{
					idToReturn =[NSString stringWithUTF8String:s];
				}
				[temp setObject:idToReturn forKey:@"timestamp"];
                
                s=(char *)sqlite3_column_text(statement, 11);
				if(s==NULL)
				{
					idToReturn=@"";
				}
				else
				{
					idToReturn =[NSString stringWithUTF8String:s];
				}
				[temp setObject:idToReturn forKey:@"isSelected"];
				
				if (temp != nil)
				{
					[returnArray addObject:temp];
                    
					temp = nil;
				}
				
			}
            
            
            if(sqlite3_errmsg(database))
            {
                NSLog(@" error %s,",sqlite3_errmsg(database));
            }
            
			sqlite3_finalize(statement);
			sqlite3_close(database);
		}
        
	}
	return returnArray;
	
}

/*==================================================================
 METHOD FOR Fetching Global RAtes FROM DATABASE
 ==================================================================*/
-(NSMutableArray *)fetchingGlobalRatesFromTable:(NSString *)query
{
	NSLog(@"QUERY : %@",query);
    
	NSString *idToReturn=@"";
	NSMutableArray *returnArray = [NSMutableArray new];
	if(sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK)
	{
		sqlite3_stmt *statement;
		if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)==SQLITE_OK)
		{
			while(sqlite3_step(statement)==SQLITE_ROW)
			{
				NSMutableDictionary *temp= [NSMutableDictionary new];
				const char *s;
                
                int i= sqlite3_column_int(statement, 0);
                [temp setObject:[NSString stringWithFormat:@"%d",i] forKey:@"id"];
                
				s=(char *)sqlite3_column_text(statement, 1);
				if(s==NULL)
				{
					idToReturn=@"";
				}
				else
				{
					idToReturn =[NSString stringWithUTF8String:s];
				}
				[temp setObject:idToReturn forKey:@"CcyCode"];
				
                
                float rate = sqlite3_column_double(statement, 2);
                [temp setObject:[NSNumber numberWithDouble:rate] forKey:@"rate"];
                
                s=(char *)sqlite3_column_text(statement, 3);
				if(s==NULL)
				{
					idToReturn=@"";
				}
				else
				{
					idToReturn =[NSString stringWithUTF8String:s];
				}
				[temp setObject:idToReturn forKey:@"imageName"];
                
				if (temp != nil)
				{
					[returnArray addObject:temp];
                    
					temp = nil;
				}
				
			}
            
            if(sqlite3_errmsg(database))
            {
                NSLog(@" error %s,",sqlite3_errmsg(database));
            }
			sqlite3_finalize(statement);
			sqlite3_close(database);
		}
	}
	return returnArray;
	
}
//CREATE TABLE "getHistoryTable" ("id" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , "amount" DOUBLE NOT NULL , "date" DATETIME NOT NULL , "vendor" VARCHAR NOT NULL , "currencyId" TEXT)
/*==================================================================
 METHOD FOR Fetching History Data FROM DATABASE
 ==================================================================*/
-(NSMutableArray *)fetchingHistoryDataFromTable:(NSString *)query;
{
	NSLog(@"QUERY : %@",query);
    
	NSString *idToReturn=@"";
	NSMutableArray *returnArray = [NSMutableArray new];
	if(sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK)
	{
		sqlite3_stmt *statement;
		if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)==SQLITE_OK)
		{
			while(sqlite3_step(statement)==SQLITE_ROW)
			{
				NSMutableDictionary *temp= [NSMutableDictionary new];
				const char *s;
                
                int i= sqlite3_column_int(statement, 0);
                [temp setObject:[NSString stringWithFormat:@"%d",i] forKey:@"id"];
                
                
                float amount = sqlite3_column_double(statement, 1);
                [temp setObject:[NSNumber numberWithDouble:amount] forKey:@"amount"];
                
				s=(char *)sqlite3_column_text(statement, 2);
				if(s==NULL)
				{
					idToReturn=@"";
				}
				else
				{
					idToReturn =[NSString stringWithUTF8String:s];
				}
				[temp setObject:idToReturn forKey:@"date"];
				
                
                s=(char *)sqlite3_column_text(statement, 3);
				if(s==NULL)
				{
					idToReturn=@"";
				}
				else
				{
					idToReturn =[NSString stringWithUTF8String:s];
				}
				[temp setObject:idToReturn forKey:@"vendor"];
                
                s=(char *)sqlite3_column_text(statement, 5);
				if(s==NULL)
				{
					idToReturn=@"";
				}
				else
				{
					idToReturn =[NSString stringWithUTF8String:s];
				}
				[temp setObject:idToReturn forKey:@"cardName"];
				if (temp != nil)
				{
					[returnArray addObject:temp];
                    
					temp = nil;
				}
				
			}
            
            if(sqlite3_errmsg(database))
            {
                NSLog(@" error %s,",sqlite3_errmsg(database));
            }
			sqlite3_finalize(statement);
			sqlite3_close(database);
		}
	}
	return returnArray;
	
}


- (NSMutableArray*) getData:(NSString *)query {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    if(sqlite3_open([[self dataFilePath] UTF8String], &database) == SQLITE_OK)
    {
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSMutableDictionary *row = [[NSMutableDictionary alloc] init];
                int columns = sqlite3_column_count(statement);
                for( int i = 0; i < columns; i++ ) {
                    long type = sqlite3_column_type(statement, i);
                    char *name = (char *) sqlite3_column_name(statement, i);
                    NSString *value = [[NSString alloc] init];
                    switch(type) {
                        case SQLITE_INTEGER:
                            value = [NSString stringWithFormat:@"%d", sqlite3_column_int(statement, i)];
                            break;
                            
                        case SQLITE_FLOAT:
                            value = [NSString stringWithFormat:@"%f", sqlite3_column_double(statement, i)];
                            break;
                            
                        case SQLITE_TEXT:
//                            value = [NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)];
                             value = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(statement,i)];
                            break;
                            
                        case SQLITE_BLOB:
                            value = [NSString stringWithFormat:@"%d", sqlite3_column_bytes(statement, i)];
                            break;
                            
                        case SQLITE_NULL:
                            break;
                            
                        default:
                         
                            break;
                    }
                    [row setValue:value forKey:[NSString stringWithFormat:@"%s", name]];
                }
                [arr addObject:[row copy]];
            }
            
           if(sqlite3_errmsg(database))
           {
               NSLog(@" error %s,",sqlite3_errmsg(database));
           }
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    return arr;
}


@end
