//
//  SHA256.m
//  Spyder
//
//  Copyright (c) 2016 Dima Bart
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//  2. Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  The views and conclusions contained in the software and documentation are those
//  of the authors and should not be interpreted as representing official policies,
//  either expressed or implied, of the FreeBSD Project.
//

#import "SHA256.h"
#import <CommonCrypto/CommonCrypto.h>

@interface Digest ()

@property (strong, nonatomic) NSData *data;

- (instancetype)initWithBytes:(uint8_t *)bytes length:(NSUInteger)length;

@end

@implementation SHA256

+ (Digest *)data:(NSData *)data {
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    [self data:data digest:digest];
    
    return [[Digest alloc] initWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
}

+ (Digest *)string:(NSString *)string {
    return [self data:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

+ (void)data:(NSData *)data digest:(uint8_t *)digest {
    __block CC_SHA256_CTX context;
    CC_SHA256_Init(&context);
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        CC_SHA256_Update(&context, bytes, (CC_LONG)byteRange.length);
    }];
    
    CC_SHA256_Final(digest, &context);
}



@end

@implementation Digest: NSObject

#pragma mark - Init -
- (instancetype)initWithBytes:(uint8_t *)bytes length:(NSUInteger)length {
    self = [super init];
    if (self) {
        _data = [NSData dataWithBytes:bytes length:length];
    }
    return self;
}

#pragma mark - Accessors -
- (NSData *)rawData {
    return self.data;
}

- (NSString *)hexRepresentation {
    return [[self class] string16FromData:self.data];
}

- (NSString *)base64Representation {
    return [self.data base64EncodedStringWithOptions:0];
}

#pragma mark - Hex -
+ (NSString *)string16FromData:(NSData *)data {
    uint8_t *d = (uint8_t *)data.bytes;
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            d[0],  d[1],  d[2],  d[3],  d[4],  d[5],  d[6],  d[7],
            d[8],  d[9],  d[10], d[11], d[12], d[13], d[14], d[15],
            d[16], d[17], d[18], d[19], d[20], d[21], d[22], d[23],
            d[24], d[25], d[26], d[27], d[28], d[29], d[30], d[31]
            ];
}

@end
