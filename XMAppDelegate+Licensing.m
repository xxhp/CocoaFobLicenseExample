//
//  CodexFab
//
// XMAppDelegate+Licensing.m
//
//  App delegate extension for licensing methods.
//  Pay attention to the TODO: comments below.
//
//  Licensed under CC Attribution License 3.0 <http://creativecommons.org/licenses/by/3.0/>
//
// Designed to work with CocoaFob by Gleb Dolgich
// <http://github.com/gbd/cocoafob/tree/master>
//
//  Created by Alex Clarke on 10/06/09.
//  Copyright 2009 MachineCodex Software Australia. All rights reserved.


#import "XMAppDelegate.h"
#import "XMLicensingWindowController.h"
#import "XMArgumentKeys.h"
#import "CFobLicVerifier.h"
#import "CFobLicGenerator.h"

@implementation XMAppDelegate (Licensing)


- (XMLicensingWindowController *)sharedLicensingWindowController {
	
	return [XMLicensingWindowController sharedLicensingWindowController];
}

- (IBAction)showLicensingWindow:(id)sender {
  
	[[[self sharedLicensingWindowController] window] makeKeyAndOrderFront:self];
}

- (void) launchCheck {
	
	if ([self verifyLicense]) {
		
		NSLog(@"Application is registered.");
		[self sharedLicensingWindowController].isLicensed= YES;
	}
	else {
		
		NSLog(@"Application not registered.");
		[self sharedLicensingWindowController].isLicensed= NO;

		// Perform trial timeout check
	}
}

- (BOOL) verifyLicense {
		
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	NSString * regCode = [defaults valueForKey:kXMRegCode];
	NSString * name = [defaults valueForKey:kXMRegName];
	
	// Here we match CocoaFob's licensekey.rb "productname,username" format
//	NSString * regName = [NSString stringWithFormat:@"%@,%@", kXMProductCode, name];
	
	// TODO: Obfuscated public key inspired by AquaticPrime: break up your pubkey.pem and insert it below.
	// Do not use this actual key in your app: it was generated specifically for LicenseExample.app.
	// Don't insert the header or footer text, just the key itself. 
	// Add a "\n" token to represent each pubkey.pem newline.
	NSMutableString *pkb64 = [NSMutableString string];
	[pkb64 appendString:@"MIHxMIGoBgcqhkjOOAQBM"];
	[pkb64 appendString:@"IGcAkEAlkHhqwIttlb"];
	[pkb64 appendString:@"DZEK6mOY7"];
	[pkb64 appendString:@"s7EBjI/GFh"];
	[pkb64 appendString:@"hT/F7m\n4eA4vVefuIsdTm"];
	[pkb64 appendString:@"A5gBplebQ"];
	[pkb64 appendString:@"02k8JMPW"];
	[pkb64 appendString:@"aP0mV8hCDzcdIHMqrS"];
	[pkb64 appendString:@"wIVAPdSrKvB8U59\n+7I0"];
	[pkb64 appendString:@"X0wfm74v0WTzAkBwKLW3thX3IOPo4vjghDX/nHtJG3V"];
	[pkb64 appendString:@"XSmCTC7mFpv2nhXuz\nblSbboRAlMa/j0kl4vURs"];
	[pkb64 appendString:@"uVXl"];
	[pkb64 appendString:@"gvvWpCpgA0SSf0TA0QAAkEAh5RNl7/OdeCseUUY\nhn"];
	[pkb64 appendString:@"WI5rVfc7g8ZjVydDTnznSaOXBFelXJJFERjE"];
	[pkb64 appendString:@"K71bA3b"];
	[pkb64 appendString:@"zgbUHnS"];
	[pkb64 appendString:@"5P4KYBhzJO5G\n+wwciQ==\n"];
    
   
	NSString *publicKey = [NSString stringWithString:pkb64];
	
	publicKey = [CFobLicVerifier completePublicKeyPEM:publicKey];
//
	CFobLicVerifier * verifier = [[CFobLicVerifier alloc] init];
    [verifier setPublicKey:publicKey error:nil];
    return [verifier verifyRegCode:regCode forName:name error:nil];

}
	 
- (void) registrationChanged:(NSNotification *)notification {
		
	XMLicensingWindowController * licenseWindowController = [self sharedLicensingWindowController];
	[self showLicensingWindow:self];
	
	BOOL isValidLicense = [self verifyLicense];
	
	[licenseWindowController showLicensedStatus:isValidLicense];
}
- (NSString *)generateCode{

    NSError *er;
    CFobLicGenerator * generat = [[CFobLicGenerator alloc] init];
    NSMutableString *pkb64 = [NSMutableString string];
    [pkb64 appendString:@"-----BEGIN DSA PRIVATE KEY-----\n"];
    [pkb64 appendString:@"MIH4AgEAAkEAlkHhqwIttlbDZEK6mOY7s7EBjI/GFhhT/F7m4eA4vVefuIsdTmA5\n"];
    [pkb64 appendString:@"gBplebQ02k8JMPWaP0mV8hCDzcdIHMqrSwIVAPdSrKvB8U59+7I0X0wfm74v0WTz\n"];
    [pkb64 appendString:@"AkBwKLW3thX3IOPo4vjghDX/nHtJG3VXSmCTC7mFpv2nhXuzblSbboRAlMa/j0kl\n"];
    [pkb64 appendString:@"4vURsuVXlgvvWpCpgA0SSf0TAkEAh5RNl7/OdeCseUUYhnWI5rVfc7g8ZjVydDTn\n"];
    [pkb64 appendString:@"znSaOXBFelXJJFERjEK71bA3bzgbUHnS5P4KYBhzJO5G+wwciQIUZ6EIi1UPfBtF\n"];
    [pkb64 appendString:@"2M1HMrtFkdh16GI=\n"];
    [pkb64 appendString:@"-----END DSA PRIVATE KEY-----\n"];
    [generat setPrivateKey:pkb64 error:&er];
    
    NSString *code =   [generat generateRegCodeForName:@"Test User" error:&er];
    NSLog(@" code is: %@",code);
    return code;

}

@end
