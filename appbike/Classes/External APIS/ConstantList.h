#import <UIKit/UIKit.h>

typedef enum {
    HTTPRequestTypeGeneral,
    HTTPRequestTypeUpdate,
    HTTPRequestTypeImageList,
    HTTPRequestTypeVideoList,
    HTTPRequestTypePlaceList,
    HTTPRequestTypePlaceDetail,
    HTTPRequestTypeLogin,
    HTTPRequestTypeActiveConcernDetail,
    HTTPRequestTypeDoctorConcernList,
} HTTPRequestType;

typedef enum {
    jServerError = 0,
    jSuccess,
    jInvalidResponse,
    jNetworkError,
    jFailResponse,
}ErrorCode;

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define DEVICE_FRAME [[ UIScreen mainScreen ] bounds ]
#define OS_VER [[[UIDevice currentDevice] systemVersion] floatValue]
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? YES : NO)
#define DEVICE_ID [[[UIDevice currentDevice]identifierForVendor]UUIDString]


#define dDeviceOrientation [[UIDevice currentDevice] orientation]
#define isPortrait  UIDeviceOrientationIsPortrait(dDeviceOrientation)
#define isLandscape UIDeviceOrientationIsLandscape(dDeviceOrientation)
#define isFaceUp    dDeviceOrientation == UIDeviceOrientationFaceUp   ? YES : NO
#define isFaceDown  dDeviceOrientation == UIDeviceOrientationFaceDown ? YES : NO



#define RGB(r,g,b)    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RECT(x,y,w,h)  CGRectMake(x, y, w, h)
#define POINT(x,y)     CGPointMake(x, y)
#define SIZE(w,h)      CGSizeMake(w, h)
#define RANGE(loc,len) NSMakeRange(loc, len)

#define NAV_COLOR       RGB(113,139,153)
#define TEXT_COLOR      RGB(52,65,71)

#define allTrim( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]

#define kUserName @"userName"
#define kPassWord @"password"
#define kFirstName @"firstName"
#define kLastName @"lastName"
#define kCityName  @"city"
#define kEmailId   @"email"
#define kZip       @"zip"
#define kAddress   @"address"
#define kState     @"state"
#define kCountry @"country"
#define klatitude @"latitude"
#define klongitude @"longitude"
#define KprofilePic @"profilepic"

#define UDSetObject(value, key) [[NSUserDefaults standardUserDefaults] setObject:value forKey:(key)];[[NSUserDefaults standardUserDefaults] synchronize]

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? YES : NO)

#define UDGetObject(key) [[NSUserDefaults standardUserDefaults] objectForKey:(key)]

#define KEYBORAD_HEIGHT_IPHONE 216

#define KEY @"AIzaSyCE_Ze-dmq-hpDPWnDPF0qEabE3XQQU-pQ"
#define THUMB_IMAGE_SIZE 100

//#define SERVER_URL             @"http://zaptechphplab.com/orthosnapp/webservices/"
#define SERVER_URL_LEARN       @"http://learn.cardgenius.com/api/api_ios.php?rquest="
#define SERVER_URL_PLAY       @"https://play.cardgenius.com/index.php?"
#define UPLOAD_CONCERN(username,password) [SERVER_URL_PLAY stringByAppendingFormat:@"action=process&usr=%@&pwd=%@&gotopage=ring_games&key=bentphone",username,password]
//#define SIGN_UP @"http://learn.cardgenius.com/api/api_ios.php?rquest"
#define SERVER_DATE_FORMAT    @"yyyy-MM-dd HH:mm:ss"
#define SIGN_UP(email,vemail,password,vpassword,fname,lname,username,country,state,deviceToken,latitude,longitude,profile_picture) [SERVER_URL_LEARN stringByAppendingFormat:@"createAppleUsr&email=%@&vemail=%@&password=%@&vpassword=%@&firstname=%@&lastname=%@&username=%@&country=%@&state=%@&deviceToken=%@&latitude=%@&longitude=%@&profile_picture=%@",email,vemail,password,vpassword,fname,lname,username,country,state,deviceToken,latitude,longitude,profile_picture]


//#define SIGN_IN
#define RESEND_CONFIRM_EMAIL(email)[SERVER_URL_LEARN stringByAppendingFormat:@"resendConfirm&email=%@",email]

#define FORGOT_PASSWORD(email)[SERVER_URL_LEARN stringByAppendingFormat :@"forgotPass&email=%@",email]





#define GOOGLE_API @"https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
#define PLACEDETAIL_API @"https://maps.googleapis.com/maps/api/place/details/json?"

#define RADIUS 100
#define KEYWORD @"Orthodontics"

#define NEARBY_LOCATIONS(latitude,longitude)[NSString stringWithFormat:@"%@key=%@&location=%f,%f&radius=%d&keyword=%@",GOOGLE_API,KEY,latitude,longitude,RADIUS,KEYWORD]

#define PLACES_DETAILS(placeId)[NSString stringWithFormat:@"%@key=%@&placeid=%@",PLACEDETAIL_API,KEY,placeId]

#define REGEX_EMAIL @"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"

//MapVC
#define kIsLoginWithFB @"IsLoginWithFB"
#define kFBUserName @"FBUserName"
#define kFBUserProfileImgURL @"FBUserProfileImgURL"

//#define IS_IPHONE_6      (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)667) < DBL_EPSILON)
//#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)736) < DBL_EPSILON)

#define IS_IPHONE_6 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 667)
#define IS_IPHONE_6_PLUS ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 736)

#define LocationUpdateNotification @"LocationDidUpdate"

#define MenuItemNotification @"MenuItemNotification"


#define gearMode1 @"Auto"
#define gearMode2 @"Auto"
#define dinamicMode1 @"City"
#define dinamicMode2 @"City"
#define dinamicMode3 @"City"

#define UserWeight 80
#define ConstantCycle 1.0
#define ConstantTreadmill 30.0



typedef enum {
    SelectedSensorTypeSpeedNormal,
    SelectedSensorTypeSpeedMinMax,
    SelectedSensorTypeCalories,
    SelectedSensorTypePulse,
    SelectedSensorTypeAvgPulse
} SelectedSensorType;


