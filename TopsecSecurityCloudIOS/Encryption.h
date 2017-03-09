//
//  Encryption.h
//  TopsecSecurityCloudIOS
//
//  Created by topsec on 16/9/26.
//  Copyright © 2016年 topsec. All rights reserved.
//

#import <Foundation/Foundation.h>



@class NSString;



@interface NSData (Encryption)



- (NSData *)AES256EncryptWithKey:(NSString *)key;   //加密

- (NSData *)AES256DecryptWithKey:(NSString *)key;   //解密




@end

