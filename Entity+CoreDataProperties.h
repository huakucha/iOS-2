//
//  Entity+CoreDataProperties.h
//  
//
//  Created by topsec on 17/1/10.
//
//

#import "Entity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Entity (CoreDataProperties)

+ (NSFetchRequest<Entity *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *uuid;
@property (nullable, nonatomic, copy) NSString *tasktage;
@property (nullable, nonatomic, copy) NSString *imag;

@end

NS_ASSUME_NONNULL_END
