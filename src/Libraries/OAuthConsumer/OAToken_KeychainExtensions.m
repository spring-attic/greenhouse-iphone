//
//  OAToken_KeychainExtensions.m
//  TouchTheFireEagle
//
//  Created by Jonathan Wight on 04/04/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#define SERVICE_NAME_FORMAT @"%@::OAuth::%@"
#define KEYCHAIN_LABEL @"OAuth Access Token"

#import <Security/Security.h>
#import "OAToken_KeychainExtensions.h"


@interface OAToken(Private)

- (OSStatus)addKeychainUsingAppName:(NSString *)name serviceProviderName:(NSString *)provider;
- (NSDictionary *)fetchKeychainUsingAppName:(NSString *)name serviceProviderName:(NSString *)provider;
- (OSStatus)deleteKeychainUsingAppName:(NSString *)name serviceProviderName:(NSString *)provider;

@end


@implementation OAToken (OAToken_KeychainExtensions)

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 30000 && TARGET_IPHONE_SIMULATOR

- (id)initWithKeychainUsingAppName:(NSString *)name serviceProviderName:(NSString *)provider 
{
    [super init];
    SecKeychainItemRef item;
	NSString *serviceName = [NSString stringWithFormat:SERVICE_NAME_FORMAT, name, provider];
	OSStatus status = SecKeychainFindGenericPassword(NULL,
													 strlen([serviceName UTF8String]),
													 [serviceName UTF8String],
													 0,
													 NULL,
													 NULL,
													 NULL,
													 &item);
    if (status != noErr) {
        return nil;
    }
    
    // from Advanced Mac OS X Programming, ch. 16
    UInt32 length;
    char *password;
    SecKeychainAttribute attributes[8];
    SecKeychainAttributeList list;
	
    attributes[0].tag = kSecAccountItemAttr;
    attributes[1].tag = kSecDescriptionItemAttr;
    attributes[2].tag = kSecLabelItemAttr;
    attributes[3].tag = kSecModDateItemAttr;
    
    list.count = 4;
    list.attr = attributes;
    
    status = SecKeychainItemCopyContent(item, NULL, &list, &length, (void **)&password);
    
    if (status == noErr) {
        self.key = [NSString stringWithCString:list.attr[0].data
                                        length:list.attr[0].length];
        if (password != NULL) {
            char passwordBuffer[1024];
            
            if (length > 1023) {
                length = 1023;
            }
            strncpy(passwordBuffer, password, length);
            
            passwordBuffer[length] = '\0';
			self.secret = [NSString stringWithCString:passwordBuffer];
        }
        
        SecKeychainItemFreeContent(&list, password);
        
    } else {
		// TODO find out why this always works in i386 and always fails on ppc
		NSLog(@"Error from SecKeychainItemCopyContent: %d", status);
        return nil;
    }
    
    NSMakeCollectable(item);
    
    return self;
}


- (int)storeInDefaultKeychainWithAppName:(NSString *)name serviceProviderName:(NSString *)provider 
{
    return [self storeInKeychain:NULL appName:name serviceProviderName:provider];
}

- (int)storeInKeychain:(SecKeychainRef)keychain appName:(NSString *)name serviceProviderName:(NSString *)provider 
{
	OSStatus status = SecKeychainAddGenericPassword(keychain,                                     
                                                    [name length] + [provider length] + 9, 
                                                    [[NSString stringWithFormat:SERVICE_NAME_FORMAT, name, provider] UTF8String],
                                                    [self.key length],                        
                                                    [self.key UTF8String],
                                                    [self.secret length],
                                                    [self.secret UTF8String],
                                                    NULL
                                                    );
	return status;
}


#else

- (id)initWithKeychainUsingAppName:(NSString *)name serviceProviderName:(NSString *)provider 
{
    if ((self = [super init]))
	{		
		NSDictionary *result = [self fetchKeychainUsingAppName:name serviceProviderName:provider];
		
		if (result == nil)
		{
			return nil;
		}
		
		self.key = (NSString *)[result objectForKey:(NSString *)kSecAttrAccount];
		self.secret = (NSString *)[result objectForKey:(NSString *)kSecAttrGeneric];
		
		[result release];
	}
	
	return self;
}

- (BOOL)storeInDefaultKeychainWithAppName:(NSString *)name serviceProviderName:(NSString *)provider 
{	
	[self deleteKeychainUsingAppName:name serviceProviderName:provider];
	
	OSStatus status = [self addKeychainUsingAppName:name serviceProviderName:provider];
	
	return (status == noErr);
		
//	if (status == errSecDuplicateItem)
//	{		
//		NSDictionary *query = [[NSDictionary alloc] initWithObjectsAndKeys:
//							   (id)kSecClassGenericPassword, (id)kSecClass,
//							   serviceName, kSecAttrService,
//							   nil];
//		
//		NSDictionary *attributesToUpdate = [[NSDictionary alloc] initWithObjectsAndKeys:
//											self.key, kSecAttrAccount,
//											self.secret, kSecAttrGeneric,
//											nil];
//		
//		status = SecItemUpdate((CFDictionaryRef)query, (CFDictionaryRef)attributesToUpdate);
//		
//		[query release];
//		[attributesToUpdate release];
//	}
}

- (BOOL)removeFromDefaultKeychainWithAppName:(NSString *)name serviceProviderName:(NSString *)provider
{
	OSStatus status = [self deleteKeychainUsingAppName:name serviceProviderName:provider];
	
	return (status == noErr);
}


#pragma mark -
#pragma mark Private methods

- (OSStatus)addKeychainUsingAppName:(NSString *)name serviceProviderName:(NSString *)provider
{
	NSString *serviceName = [NSString stringWithFormat:SERVICE_NAME_FORMAT, name, provider];
	
	NSDictionary *query = [[NSDictionary alloc] initWithObjectsAndKeys:
						   (id)kSecClassGenericPassword, (id)kSecClass, 
						   serviceName, kSecAttrService, 
						   KEYCHAIN_LABEL, kSecAttrLabel, 
						   self.key, kSecAttrAccount, 
						   self.secret, kSecAttrGeneric,
						   nil];
	
	OSStatus status = SecItemAdd((CFDictionaryRef)query, NULL);
	
	[query release];
	
	return status;
}

- (NSDictionary *)fetchKeychainUsingAppName:(NSString *)name serviceProviderName:(NSString *)provider
{
	NSString *serviceName = [NSString stringWithFormat:SERVICE_NAME_FORMAT, name, provider];
		
	NSDictionary *query = [[NSDictionary alloc] initWithObjectsAndKeys:
						   (id)kSecClassGenericPassword, (id)kSecClass, 
						   serviceName, kSecAttrService, 
						   kCFBooleanTrue, kSecReturnAttributes, 
						   nil];
	
	NSMutableDictionary *result = nil;
	OSStatus status = SecItemCopyMatching((CFDictionaryRef)query, (CFTypeRef *)&result);
	
	[query release];
	
	if (status != noErr) 
	{
		return nil;
	}
	
	return result;
}

- (OSStatus)deleteKeychainUsingAppName:(NSString *)name serviceProviderName:(NSString *)provider
{
	NSString *serviceName = [NSString stringWithFormat:SERVICE_NAME_FORMAT, name, provider];
	
	NSDictionary *query = [[NSDictionary alloc] initWithObjectsAndKeys:
						   (id)kSecClassGenericPassword, (id)kSecClass,
						   serviceName, kSecAttrService,
						   nil];
	
	OSStatus status = SecItemDelete((CFDictionaryRef)query);
	
	[query release];
	
	return status;
}

#endif

@end
