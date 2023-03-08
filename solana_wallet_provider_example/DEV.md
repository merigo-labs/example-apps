# Solana Wallet Provider Example App

## Getting Started

### Open in Android Studio

Open file:
```
solana_wallet_provider_example/android/build.gradle.
```

### Open in XCode

Open file:
```
solana_wallet_provider_example/ios/Runner.xcworkspace.
```

The iOS platform code for your plugin is located in

<code>
Pods/Development&nbsp;Pods/solana_wallet_adapter_ios/../../../example_apps/solana_wallet_provider_example/ios/.symlinks/plugins/solana_wallet_adapter_ios/ios/Classes
</code>

</br>

### Run for Web (HTTPS)

Set up HTTPS on localhost using this [post](https://medium.com/@jonsamp/how-to-set-up-https-on-localhost-for-macos-b597bcf935ee)

1. Build for web
```
$ flutter build web
```

2. Run web server
```
$ cd build/web
$ http-server --ssl --cert ~/.localhost-ssl/localhost.crt --key ~/.localhost-ssl/localhost.key
```
