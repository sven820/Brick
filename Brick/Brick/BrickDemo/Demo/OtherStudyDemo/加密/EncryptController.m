//
//  EncryptController.m
//  Brick
//
//  Created by 靳小飞 on 2018/2/8.
//  Copyright © 2018年 jinxiaofei. All rights reserved.
//

#import "EncryptController.h"
#import "NSString+Hash.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface EncryptController ()
@property (nonatomic, strong) NSString *oriStr;
@end

@implementation EncryptController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.oriStr = @"name: jinxiaofei hello hello hello hello hello 加密 加密加密 \n name: jinxiaofei hello hello hello hello hello 加密 加密加密 name: jinxiaofei hello hello hello hello hello 加密 加密加密 name: jinxiaofei hello hello hello hello hello 加密 加密加密";
    
    [self hashEncrypt];
    
    UIButton *fingerprint = [[UIButton alloc]init];
    [fingerprint setTitle:@"指纹解锁" forState:UIControlStateNormal];
    [fingerprint addTarget:self action:@selector(fingerprint) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fingerprint];
    fingerprint.frame = CGRectMake(10, 100, 100, 39);
    fingerprint.backgroundColor = [UIColor brownColor];
}

#pragma mark - base64
- (void)base64Encode
{
    //Base64编码会把3字节的二进制数据编码为4字节的文本数据，长度增加33%，好处是编码后的文本数据可以在邮件正文、网页等直接显示。
    
    //如果要编码的二进制数据不是3的倍数，最后会剩下1个或2个字节怎么办？Base64用\x00字节在末尾补足后，再在编码的末尾加上1个或2个=号，表示补了多少字节，解码的时候，会自动去掉
    /*
     对于IOS7之后在NSData通过Base64转化为NSString时，有一个枚举参数：NSDataBase64EncodingOptions有四个值，在将其转化为NSString时，对其进行了处理：
     
     NSDataBase64Encoding64CharacterLineLength
     其作用是将生成的Base64字符串按照64个字符长度进行等分换行。
     
     NSDataBase64Encoding76CharacterLineLength
     其作用是将生成的Base64字符串按照76个字符长度进行等分换行。
     
     NSDataBase64EncodingEndLineWithCarriageReturn
     其作用是将生成的Base64字符串以回车结束。
     
     NSDataBase64EncodingEndLineWithLineFeed
     其作用是将生成的Base64字符串以换行结束。
     */
    NSData *data = [self.oriStr dataUsingEncoding:NSUTF8StringEncoding];
    //转换后的事标准base64包含了= + /
    /*然而，标准的Base64并不适合直接放在URL里传输，因为URL编码器会把标准Base64中的“/”和“+”字符变为形如“%XX”的形式，而这些“%”号在存入数据库时还需要再进行转换，因为ANSI SQL中已将“%”号用作通配符。
     为解决此问题，可采用一种用于URL的改进Base64编码，它不仅在末尾去掉填充的'='号，并将标准Base64中的“+”和“/”分别改成了“-”和“_”，这样就免去了在URL编解码和数据库存储时所要作的转换，避免了编码信息长度在此过程中的增加，并统一了数据库、表单等处对象标识符的格式
     因此base64友其它变种，只是将 / + 替换为其它字符*/
    NSString *base64_encode = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSLog(@"base64 encode:  %@", base64_encode);
    
    NSData *base64_decode = [[NSData alloc]initWithBase64EncodedString:base64_encode options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSLog(@"base64 decode:  %@", [[NSString alloc]initWithData:base64_decode encoding:NSUTF8StringEncoding]);
}
- (void)aboutToken
{
    /* 传统身份验证的方法
     HTTP 是一种没有状态的协议，也就是它并不知道是谁是访问应用。这里我们把用户看成是客户端，客户端使用用户名还有密码通过了身份验证，不过下回这个客户端再发送请求时候，还得再验证一下。
     
     解决的方法就是，当用户请求登录的时候，如果没有问题，我们在服务端生成一条记录，这个记录里可以说明一下登录的用户是谁，然后把这条记录的 ID 号发送给客户端，客户端收到以后把这个 ID 号存储在 Cookie 里，下次这个用户再向服务端发送请求的时候，可以带着这个 Cookie ，这样服务端会验证一个这个 Cookie 里的信息，看看能不能在服务端这里找到对应的记录，如果可以，说明用户已经通过了身份验证，就把用户请求的数据返回给客户端。
     
     上面说的就是 Session，我们需要在服务端存储为登录的用户生成的 Session ，这些 Session 可能会存储在内存，磁盘，或者数据库里。我们可能需要在服务端定期的去清理过期的 Session
     */
    
    /*基于 Token 的身份验证方法
     使用基于 Token 的身份验证方法，在服务端不需要存储用户的登录记录。大概的流程是这样的：
     
     客户端使用用户名跟密码请求登录
     服务端收到请求，去验证用户名与密码
     验证成功后，服务端会签发一个 Token，再把这个 Token 发送给客户端
     客户端收到 Token 以后可以把它存储起来，比如放在 Cookie 里或者 Local Storage 里
     客户端每次向服务端请求资源的时候需要带着服务端签发的 Token
     服务端收到请求，然后去验证客户端请求里面带着的 Token，如果验证成功，就向客户端返回请求的数据
     */
    //JWT token
}
- (void)hashEncrypt
{
    //hash(摘要算法) 一般用来做签名，防信息篡改 {MD5, SHA}
    NSString * info = @"{name: jinxiaofei pwd: 123456}";
    NSLog(@"%@", info.md5String);
    NSLog(@"%@", info.sha1String);
    NSLog(@"%@", info.sha256String);
    NSLog(@"%@", info.sha512String);
}
- (void)ssl
{
    //对称加密 rc rc4等 加密解密的秘钥相同
    
    /*非对称加密 私钥（私有） 公钥（公开） {RSA, DSA,RSA可以用于加/解密,也可以用于签名验签,DSA则只能用于签名}
        1.公钥 -> 加密 -> 私钥 -> 解密 （加密）
        2.私钥 -> 加密 -> 钥钥 -> 解密 （签名，认证）
     * 实际应用中,一般都是和对方交换公钥,然后你要发给对方的数据,用他的公钥加密,他得到后用他的私钥解密,他要发给你的数据,用你的公钥加密,你得到后用你的私钥解密,这样最大程度保证了安全性.
     */
    /*
     CA/PEM/DER/X509/PKCS
     
     　　一般的公钥不会用明文传输给别人的,正常情况下都会生成一个文件,这个文件就是公钥文件,然后这个文件可以交给其他人用于加密,但是传输过程中如果有人恶意破坏,将你的公钥换成了他的公钥,然后得到公钥的一方加密数据,不是他就可以用他自己的密钥解密看到数据了吗,为了解决这个问题,需要一个公证方来做这个事,任何人都可以找它来确认公钥是谁发的.这就是CA,CA确认公钥的原理也很简单,它将它自己的公钥发布给所有人,然后一个想要发布自己公钥的人可以将自己的公钥和一些身份信息发给CA,CA用自己的密钥进行加密,这里也可以称为签名.然后这个包含了你的公钥和你的信息的文件就可以称为证书文件了.这样一来所有得到一些公钥文件的人,通过CA的公钥解密了文件,如果正常解密那么机密后里面的信息一定是真的,因为加密方只可能是CA,其他人没它的密钥啊.这样你解开公钥文件,看看里面的信息就知道这个是不是那个你需要用来加密的公钥了.
     
     　　实际应用中,一般人都不会找CA去签名,因为那是收钱的,所以可以自己做一个自签名的证书文件,就是自己生成一对密钥,然后再用自己生成的另外一对密钥对这对密钥进行签名,这个只用于真正需要签名证书的人,普通的加密解密数据,直接用公钥和私钥来做就可以了.
     
     　　密钥文件的格式用OpenSSL生成的就只有PEM和DER两种格式,PEM的是将密钥用base64编码表示出来的,直接打开你能看到一串的英文字母,DER格式是二进制的密钥文件,直接打开,你可以看到........你什么也看不懂!.X509是通用的证书文件格式定义.pkcs的一系列标准是指定的存放密钥的文件标准,你只要知道PEM DER X509 PKCS这几种格式是可以互相转化的.
     */
}
- (void)timePwd
{
    //时间戳密码 pwd(public) -> hash + timestr -> hash - new pwd
    //server比对： has pwd + timestr(cur, cur + 1min) - > hash 相等则有效
}
- (void)sskeycahin
{
    //https://github.com/Mingriweiji-github/sskeychain-master
    /*
     + (NSArray *)allAccounts;
     + (NSArray *)accountsForService:(NSString *)serviceName;
     + (NSString *)passwordForService:(NSString *)serviceName account:(NSString *)account;
     + (BOOL)deletePasswordForService:(NSString *)serviceName account:(NSString *)account;
     + (BOOL)setPassword:(NSString *)password forService:(NSString *)serviceName account:(NSString *)account;
     */
}
- (void)fingerprint
{
    // https://www.jianshu.com/p/d44b7d85e0a6
    
    //本地认证上下文联系对象
    LAContext * context = [[LAContext alloc] init];
    NSError * error = nil;
    //验证是否具有指纹认证功能，不建议使用版本判断方式实现
    BOOL canEvaluatePolicy = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
    if (canEvaluatePolicy) {
        NSLog(@"有指纹认证功能");
        //匹配指纹
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"验证指纹已确认您的身份" reply:^(BOOL success, NSError *error) {
            if (success) {
                NSLog(@"指纹验证成功"); //case1
            } else {
                NSLog(@"验证失败");
                NSLog(@"%@",error.localizedDescription);//case 2
            }
        }];
    } else {
        NSLog(@"无指纹认证功能"); //case3
        
        //case 2 和 3 如果锁定了，这里输入密码来解除锁定
        if (error.code == LAErrorTouchIDLockout) {
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"需要您的密码，才能启用 Touch ID" reply:^(BOOL success, NSError *error) {
                if (success) {
                    NSLog(@"解除锁定成功");//弹出指纹解锁
                } else {
                    NSLog(@"验证失败");
                    NSLog(@"%@",error.localizedDescription);
                }
            }];
        }
    }
    
    //设计指纹解锁登录，支付等
    
    //设备绑定
    //在设备第一次使用指纹登录之前，必须先登录原有的账号（app注册账号），进行设备（用户）绑定。图1所示
    /*
     开启：在app登录后，在“用户信息－安全”，点击开启“指纹登录”；
     验证TouchID：检测当前设备是否支持TouchID，若支持则发起TouchID验证；
     生成设备账号/密码：TouchID验证通过后，根据当前已登录的账号和硬件设备Token，生成设备账号/密码（规则可自定，密码要长要复杂），并保存在keychain；
     绑定：生成设备账号/密码后，将原账号及设备账号/密码，加密后（题主使用的是RSA加密）发送到服务端进行绑定；
     成功：验证原账号及设备账号有效后，返回相应状态，绑定成功则完成整个TouchID（设备）绑定流程。
     */
    //设备（指纹）登陆
    //在设备（用户）绑定之后，并且用户账号退出后，可以使用指纹登录，若当前设备未绑定，则不会出现“指纹登录”按钮。图2所示
    /*
     TouchID登录：在用户登录界面，点击“指纹登录”；
     验证TouchID：检测当前设备是否支持TouchID，若支持则发起TouchID验证；
     登录：读取app在本机的设备账号/密码，调用设备登录接口，发起登录请求；
     成功：验证设备账号/密码后，返回相应状态，登录成功则完成整个TouchID登录流程。
     */
}
@end
