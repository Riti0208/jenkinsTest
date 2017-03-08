using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;

public class MyBuilder
{
	private static List<string> getAllScene() {
		List<string> allScene = new List<string>();
		foreach (EditorBuildSettingsScene scene in EditorBuildSettings.scenes) {
			if (scene.enabled) {
				allScene.Add(scene.path);
			}
		}
		return allScene;
	}

	// ビルド実行でAndroidのapkを作成する例
	[UnityEditor.MenuItem("Tools/Build Project AllScene Android")]
	public static void BuildProjectAllSceneAndroid(){
		EditorUserBuildSettings.SwitchActiveBuildTarget(BuildTarget.Android);
		List<string> allScene = getAllScene();
		PlayerSettings.bundleIdentifier = "com.kurakura.test";
		PlayerSettings.statusBarHidden = true;
		BuildPipeline.BuildPlayer(
			allScene.ToArray(),
			"game.apk",
			BuildTarget.Android,
			BuildOptions.None
		);
	}
	[UnityEditor.MenuItem("Tools/Build Project AllScene IOS")]
	public static void BuildProjectAllSceneIOS() {
		EditorUserBuildSettings.SwitchActiveBuildTarget(BuildTarget.iOS);
		List<string> allScene = getAllScene();
		PlayerSettings.bundleIdentifier = "com.kurakura.test";
		PlayerSettings.statusBarHidden = true;
		BuildPipeline.BuildPlayer(
			allScene.ToArray(),
			"iosProject",
			BuildTarget.iOS,
			BuildOptions.None
		);

	}
	[UnityEditor.MenuItem("Tools/Build Project AllScene IOS and Android")]
	public static void BuildProjectAllSceneIOSandAndroid() { 
		EditorUserBuildSettings.SwitchActiveBuildTarget(BuildTarget.iOS);
		List<string> allScene = getAllScene();
		PlayerSettings.bundleIdentifier = "com.kurakura.test";
		PlayerSettings.statusBarHidden = true;
		BuildPipeline.BuildPlayer(
			allScene.ToArray(),
			"iosProject",
			BuildTarget.iOS,
			BuildOptions.None
		);
		EditorUserBuildSettings.SwitchActiveBuildTarget(BuildTarget.Android);
		BuildPipeline.BuildPlayer(
			allScene.ToArray(),
			"game.apk",
			BuildTarget.Android,
			BuildOptions.None
		);
	}
}
