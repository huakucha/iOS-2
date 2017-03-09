//
//  VarintUtil.m
//  TopsecSecurityCloudIOS
//
//  Created by topsec—lxj on 16/9/7.
//  Copyright © 2016年 topsec. All rights reserved.
//

#import "VarintUtil.h"

@implementation VarintUtil

-(NSMutableData*)writeVarintData:(NSData*) orgData;{
    
    
    NSMutableData *allData=[[NSMutableData alloc]init];
    
    int intValue=orgData.length;
    
    uint8_t* output=malloc(5);
    
    int outputSize=0;
    while(intValue>127){
        output[outputSize]=((uint8_t)(intValue & 127)) | 128;
        intValue >>=7;
        outputSize++;
    }
    output[outputSize++]=((uint8_t)intValue)& 127;
    
    NSData* headData=[NSData dataWithBytes:(const void *)output length:outputSize];;
    
    [allData appendData:headData];
    [allData appendData:orgData];
    
    return allData;
}

-(NSData*)readVarintData:(NSData *)varintData{
    
    uint8_t* input=varintData.bytes;
    
    int  protoDataLength=0;
    
    int varintLength=0;
    for (int i = 0; i < varintData.length; i++) {
        protoDataLength |= (input[i] & 127) << (7 * i);
        varintLength++;
        //If the next-byte flag is set
        if(!(input[i] & 128)) {
            
            break;
        }
    }
    
    uint8_t* output=malloc(protoDataLength);
    for (int i = 0; i < protoDataLength; i++) {
        output[i]=input[i+varintLength];
    }
    
    NSLog(@"jieguo%@",[NSData dataWithBytes:(const void *)output length:protoDataLength]);
    return  [NSData dataWithBytes:(const void *)output length:protoDataLength];;
    
}



@end
