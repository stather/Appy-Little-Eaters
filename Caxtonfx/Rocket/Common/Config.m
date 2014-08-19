//
//  Config.M
//
//  Created by Konstant on 22/05/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import "Config.h"


@implementation Config



//Live
//NSString		*SiteAPIURL				= @"http://www.meganega.com/";
//NSString		*SiteAPIURL				= @"http://www.meganega.com";


NSString		*ShowPerPage			= @"20";

//NSString		*DatabaseName			= @"cfx.sqlite";
NSString		*DatabaseName			= @"cfxNew.sqlite";
NSString		*DatabasePath;

NSString	*preferredLang;

NSString                    *preferredCurrency = @"";
NSString                    *targetCurrency = @"";
NSString                *fromConversionSection = @"";

NSString *resloutionType;

NSString                    *usersLocationCurrency = nil;

BOOL                         redrawWithNewCurrency = FALSE;
BOOL                        isBanksSettingsChanged = FALSE;
BOOL                        isCurrencySettingsChanged = FALSE;
BOOL                        isFacebookRequest;
BOOL                        shouldUpdateRates = FALSE;
BOOL                        isImageIsUsingForConversionFirstTime = FALSE;

NSString *userDOBStr;
NSString *userMobileStr;
NSString *userConactTypeStr;
NSString *appID = @"687286642";
NSString *flurryID = @"DWMZTSXNKNPF3BT55KKP";
NSString* dateInString;

NSInteger LoginAttamp;

@end