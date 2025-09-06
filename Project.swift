import ProjectDescription

let project = Project(
    name: "RichDiary",
    targets: [
        .target(
            name: "RichDiary",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.RichDiary",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen.storyboard",
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
                    ]
                ]
            ),
            sources: ["RichDiary/Sources/**"],
            resources: ["RichDiary/Resources/**"],
            dependencies: [
                .external(name: "SnapKit", condition: .none),
                .external(name: "Then", condition: .none),
                .external(name: "RxSwift", condition: .none),
                .external(name: "Realm", condition: .none),
            ]
        ),
    ]
)
