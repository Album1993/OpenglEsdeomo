//
//  AGLkTextureLoader.m
//  OpenGLES_Ch3_1
//
//  Created by 张一鸣 on 2017/4/29.
//
//

#import "AGLkTextureLoader.h"

typedef enum
{
    AGLK1 = 1,
    AGLK2 = 2,
    AGLK4 = 4,
    AGLK8 = 8,
    AGLK16 = 16,
    AGLK32 = 32,
    AGLK64 = 64,
    AGLK128 = 128,
    AGLK256 = 256,
    AGLK512 = 512,
    AGLK1024 = 1024,
}
AGLKPowerOf2;

/////////////////////////////////////////////////////////////////
// Forward declaration of function
static AGLKPowerOf2 AGLKCalculatePowerOf2ForDimension(
                                                      GLuint dimension);

/////////////////////////////////////////////////////////////////
// Forward declaration of function
static NSData *AGLKDataWithResizedCGImageBytes(
                                               CGImageRef cgImage,
                                               size_t *widthPtr,
                                               size_t *heightPtr);


@interface AGLkTextureInfo (AGLKTextureLoader)

- (id)initWithName:(GLuint)aName
            target:(GLenum)target
             width:(size_t)aWidth
            height:(size_t)aHeight;

@end

@implementation  AGLkTextureInfo (AGLKTextureLoader)

- (id)initWithName:(GLuint)aName target:(GLenum)aTarget width:(size_t)aWidth height:(size_t)aHeight {
    if (self = [super init]) {
        name = aName;
        target = aTarget;
        width = aWidth;
        height = aHeight;
    }
    return self;
}

@end

@implementation AGLkTextureInfo

@synthesize name;
@synthesize target;
@synthesize width;
@synthesize height;

@end

@implementation AGLkTextureLoader

+ (AGLkTextureInfo *)textureWithCGImage:(CGImageRef)cgImage
                                options:(NSDictionary *)options
                                  error:(NSError *__autoreleasing *)outError {
    size_t width;
    size_t height;
    NSData * imageData = AGLKDataWithResizedCGImageBytes(cgImage,
                                                         &width,
                                                         &height);
    
    GLuint textureBufferID;
    glGenTextures(1, &textureBufferID);
    glBindTexture(GL_TEXTURE_2D, textureBufferID);
    
    glTexImage2D(GL_TEXTURE_2D,
                 0,
                 GL_RGBA,
                 width,
                 height,
                 0,
                 GL_RGBA,
                 GL_UNSIGNED_BYTE,
                 [imageData bytes]);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    AGLkTextureInfo * result = [[AGLkTextureInfo alloc] initWithName:textureBufferID
                                                              target:GL_TEXTURE_2D
                                                               width:width
                                                              height:height];
    return result;
}

@end

static NSData *AGLKDataWithResizedCGImageBytes(
                                               CGImageRef cgImage,
                                               size_t *widthPtr,
                                               size_t *heightPtr)
{
    NSCParameterAssert(NULL != cgImage);
    NSCParameterAssert(NULL != widthPtr);
    NSCParameterAssert(NULL != heightPtr);
    
    size_t originalWidth = CGImageGetWidth(cgImage);
    size_t originalHeight = CGImageGetWidth(cgImage);
    NSCAssert(0 < originalWidth, @"Invalid image width");
    NSCAssert(0 < originalHeight, @"Invalid image width");
    
    size_t width = AGLKCalculatePowerOf2ForDimension(originalWidth);
    size_t height = AGLKCalculatePowerOf2ForDimension(originalHeight);
    
    NSMutableData * imageData = [NSMutableData dataWithLength:height * width * 4];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef cgContext = CGBitmapContextCreate([imageData mutableBytes], width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(cgContext, 0, height);
    CGContextScaleCTM(cgContext, 1.0, -1.0);
    
    CGContextDrawImage(cgContext, CGRectMake(0, 0, width, height), cgImage);
    
    CGContextRelease(cgContext);
    *widthPtr = width;
    *heightPtr = height;
    return imageData;
}


static AGLKPowerOf2 AGLKCalculatePowerOf2ForDimension(
                                                      GLuint dimension)
{
    AGLKPowerOf2  result = AGLK1;
    
    if(dimension > (GLuint)AGLK512)
    {
        result = AGLK1024;
    }
    else if(dimension > (GLuint)AGLK256)
    {
        result = AGLK512;
    }
    else if(dimension > (GLuint)AGLK128)
    {
        result = AGLK256;
    }
    else if(dimension > (GLuint)AGLK64)
    {
        result = AGLK128;
    }
    else if(dimension > (GLuint)AGLK32)
    {
        result = AGLK64;
    }
    else if(dimension > (GLuint)AGLK16)
    {
        result = AGLK32;
    }
    else if(dimension > (GLuint)AGLK8)
    {
        result = AGLK16;
    }
    else if(dimension > (GLuint)AGLK4)
    {
        result = AGLK8;
    }
    else if(dimension > (GLuint)AGLK2)
    {
        result = AGLK4;
    }
    else if(dimension > (GLuint)AGLK1)
    {
        result = AGLK2;
    }
    
    return result;
}
