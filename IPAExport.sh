#----------------------------------------------------------------------
# コマンドラインでのipaファイルの作成
#----------------------------------------------------------------------

#------- 証明書インポートととプロビジョニングファイルのコピー -------#

# Keychain Location
KEYCHAIN_LOCATION=~/Library/Keychains/login.keychain
# Mac OSX管理パスワード
OSX_ADMIN_PASSWORD=LoginPasswd

# 証明書ファイルパス
IOS_P12_FILE_PATH=$WORKSPACE/key/iPhoneDeveloper.p12
# 証明書ファイルパスワード
IOS_P12_PASSWORD=P12Passwd
# プロビジョニングファイルパス
IOS_PROVISIONING_FILE_PATH=$WORKSPACE/key/iOSProvisioningProfile.mobileprovision
# プロビジョニングファイルのUUID
PROFILE_UUID=`grep "UUID" ${IOS_PROVISIONING_FILE_PATH} -A 1 --binary-files=text 2>/dev/null |grep string|sed -e 's/^[[:blank:]]<string>//' -e 's/<\/string>//'`

# Keychainをアンロックにする
security unlock-keychain -p $OSX_ADMIN_PASSWORD "${KEYCHAIN_LOCATION}"

# 証明書のimport(すでにimport済みでも実行）
security import "${IOS_P12_FILE_PATH}" -f pkcs12 -P $IOS_P12_PASSWORD -k "${KEYCHAIN_LOCATION}" -T /usr/bin/codesign

# プロビジョニングファイルをコピーする
cp $IOS_PROVISIONING_FILE_PATH ~/Library/MobileDevice/Provisioning\ Profiles/$PROFILE_UUID.mobileprovision

#------- xcodeプロジェクトをビルドして .appを生成する -------#

# xcodeプロジェクトパス
XCODE_PROJECT_PATH=$WORKSPACE/Xcode_Device
XCODE_PROJECT_CONFIG_PATH=$XCODE_PROJECT_PATH/Unity-iPhone.xcodeproj
# ビルド CONFIGURATION設定
CONFIGURATION=Release

# コード署名用 IDENTITY
IDENTITY="iPhone Developer: yasuaki ohama (?????????)"

#デバッグ用のシンボルファイル書き出しは負荷がかかるのでやらない
BUILD_OPT_MAKE_DSYM="DEBUG_INFORMATION_FORMAT=dwarf"

# ビルド開始
xcodebuild -project "${XCODE_PROJECT_CONFIG_PATH}" -configuration "${CONFIGURATION}" CODE_SIGN_IDENTITY="${IDENTITY}" OTHER_CODE_SIGN_FLAGS="--keychain ${KEYCHAIN_LOCATION}" $BUILD_OPT_MAKE_DSYM

#------- .appからipa作成 -------#

# .appのPATH設定
TARGET_APP_PATH=$XCODE_PROJECT_PATH/build/Release-iphoneos/Untitled.app
# ipaのPATH設定
mkdir -p $WORKSPACE/Build
IPA_FILE_PATH=$WORKSPACE/Build/$JOB_NAME-$BUILD_NUMBER.ipa

# ipa生成開始
/usr/bin/xcrun -sdk iphoneos PackageApplication -v "${TARGET_APP_PATH}" -o "${IPA_FILE_PATH}" --sign "${IDENTITY}" --embed "${IOS_PROVISIONING_FILE_PATH}"
