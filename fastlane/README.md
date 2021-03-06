fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## iOS
### ios test
```
fastlane ios test
```
Runs tests
### ios test_all
```
fastlane ios test_all
```
Runs all tests
### ios fabric
```
fastlane ios fabric
```
Build and distribute build to Fabric Beta
### ios add_devices
```
fastlane ios add_devices
```

### ios prerelease
```
fastlane ios prerelease
```
Submit a new PreRelease Rinkeby Beta Build to Apple TestFlight

This will also make sure the profile is up to date
### ios certificates
```
fastlane ios certificates
```


----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
