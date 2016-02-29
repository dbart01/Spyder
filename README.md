# Spyder
Spyder simplifies the push notification testing & debugging process for Apple's new APNs Provider API based on the `HTTP/2` protocol so you can focus on building amazing software instead of wasting time on boiler-plate setup code. It doesn't require any certificate conversions, remote servers or complex procedures. Using the certificates in your keychain, it lets you send a push notification with a single command:
```
spyder \
    --token ed1906d6c03875a6f827ed9ea7222f7c4c1946d902271058c9b22a681b756537 \
    --cert 1 \
    --topic com.company.app \
    --message Hey
```
another equivalent:
```
spyder \
    --t ed1906d6c03875a6f827ed9ea7222f7c4c1946d902271058c9b22a681b756537 \
    --c 1 \
    --T com.company.app \
    --m Hey
```
### Installation
Clone / download the repo. Build the Xcode project. Doing so will automatically install the `spyder` binary to `/usr/local/bin`.
### Help
Spyder features a comprehensive summary of available options and their usage. Just type:
```
spyder --help
```
### Certificates
One of the pains with push notifications is converting the necessary certificates to specific formats like `.pem`. Spyder lets you skip these steps entirely by using certificates in your keychain instead. First, list all available certificates:
```
spyder -i
1. Apple Push Services: com.company.app
2. Apple Push Services: com.other.application
3. iPhone Developer: John Smith (5C7S4N3J2O)
4. iPhone Developer: Andy Appleseed (8F7G6H5J4S)
5. iPhone Developer: Kelly Welshe (7S0J4A7M2F)
6. iPhone Distribution: John Smith (5C7S4N3J2O)
7. iPhone Distribution: Andy Appleseed (8F7G6H5J4S)
8. iPhone Distribution: Kelly Welshe (7S0J4A7M2F)
```
Note the index number used for the certificate and use it as the value to the `--cert` parameter. Alternatively, you could also provide a path to the `.p12` file. The two methods are practically identical:
```
spyder \
    --cert 1 \
    --token #device-token# \
    --topic #topic# \
    --message Hey
```
or
```
spyder \
    --cert /path/to/certificate.p12 \
    --token #device-token# \
    --topic #topic# \
    --message Hey
```
### Payload
This is the most important part of a push notification. Spyder features two alternatives for creating the payload: 
##### Simple
You can simply use the `--message` option and provide just the body of the payload. The following default payload will be created:
```
{
    "aps": {
        "sound": "default",
        "alert": "#your-message#"
    }
}
```
##### Custom
You can provide your own, completely custom payload using the `--payload` option. This can be inline JSON or a path to a JSON file:
```
spyder \
    --cert /path/to/certificate.p12 \
    --token #device-token# \
    --topic #topic# \
    --payload "{\"aps\":{\"alert\":\"Hey\"}}"
```
or
```
spyder \
    --cert /path/to/certificate.p12 \
    --token #device-token# \
    --topic #topic# \
    --payload /path/to/payload.json
```
### Sandbox, or no sandbox...
Spyder defaults to using the Apple's sandbox endpoint for sending push notifications. You can either explicitly set this option using `--env dev` flag, or switch to an endpoint for production applications with `--env prod`.
### Ports
By default, Spyder uses the standard SSL port to connect the APNs servers - `443`. You can provide an alternate port using the `--port 2197` flag.
