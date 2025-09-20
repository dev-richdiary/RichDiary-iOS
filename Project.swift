import ProjectDescription

let project = Project(
    name: "RichDiary",
    targets: [
        .target(
            name: "RichDiary",
            destinations: [.iPhone],
            product: .app,
            productName: "부자 가계부",
            bundleId: "io.tuist.RichDiary",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen",
                    "UIApplicationSceneManifest": [
                        "UIApplicationSupportsMultipleScenes": false,
                        "UISceneConfigurations": [
                            "UIWindowSceneSessionRoleApplication": [
                                [
                                    "UISceneConfigurationName": "Default Configuration",
                                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                                ],
                            ]
                        ]
                    ],
                    "CFBundleIconName": "AppIcon",
                    "CFBundleShortVersionString": "$(CFBundleShortVersionString)",
                    "CFBundleVersion": "$(CURRENT_PROJECT_VERSION)",
                    "UIAppFonts": [
                        "Pretendard-Bold.otf",
                        "Pretendard-Medium.otf",
                        "Pretendard-Regular.otf",
                        "Pretendard-SemiBold.otf"
                    ],
                    "UIUserInterfaceStyle": "Light",
                    "UISupportedInterfaceOrientations": [
                        "UIInterfaceOrientationPortrait"
                    ],
                ]
            ),
            sources: ["RichDiary/Sources/**"],
            resources: ["RichDiary/Resources/**"],
            dependencies: [
                .external(name: "SnapKit", condition: .none),
                .external(name: "Then", condition: .none),
                .external(name: "RxSwift", condition: .none),
                .external(name: "RxCocoa", condition: .none),
                .external(name: "RxRelay", condition: .none),
                .external(name: "RealmSwift", condition: .none),
                .external(name: "Realm", condition: .none)
            ]
        ),
    ]
)
