using Newtonsoft.Json;
using Steamworks;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Unity.Cinemachine;
using UnityEditor;
using UnityEngine;
using UnityEngine.Networking;
[System.Serializable]
public struct UpdateItemParams
{
    public ulong ItemID;
    public string ItemName;
    [TextArea]
    public string ItemDescription;
    public bool ContentRelativePath;
    [TextArea]
    [Tooltip("[Unity]Right Click on your Content's folder and select Copy Full Path Location\n" +
        "[Outside Unity] On the top bar of your file explorer, right click and press Copy Path")]
    public string contentPath;
    public bool ImageRelativePath;
    [TextArea]
    [Tooltip("Right Click on your Preview Image and select Copy Path")]
    public string imagePath;
    [Tooltip ("Patch notes")]
    public string changeNotes;
}
[CreateAssetMenu(fileName = "SteamWorksItem", menuName = "SteamItem/SteamWorksItem")]
[SaveDuringPlay]
public class SteamWorksItem : ScriptableObject
{
    [SerializeField] UpdateItemParams updateItemParams;
    public UpdateItemParams UpdateItemParams=>updateItemParams;
    readonly uint appID= 3610180;
    [Tooltip("If your mod uses asset bundles, specify its name to build them")]
    public string AssetBundleName;
    public void DeleteItem()
    {
        if (!SteamManager.Initialized)
        {
            Debug.Log(steamLog);
            return;
        }// Make the call to the steam back-end
        Debug.Log("deleted");
        SteamUGC.DeleteItem(new(updateItemParams.ItemID));
        updateItemParams.ItemID = 0;
        SaveAsset();
    }
    readonly string steamLog = "Steam client is not running!";
    public void UpdateItem()
    {
        SteamManager.Destroy();
        if (!SteamManager.Initialized)
        {
            Debug.Log(steamLog);
            return;
        }
        UpdateWorkshopItem(new(updateItemParams.ItemID), updateItemParams);
    }
    public void CreateItem()
    {
        SteamManager.Destroy();
        if (!SteamManager.Initialized)
        {
            Debug.Log(steamLog);
            return;
        }
        Debug.Log("Creating Item");
        var createHandle = SteamUGC.CreateItem(new(appID), EWorkshopFileType.k_EWorkshopFileTypeCommunity);
        var callResult = CallResult<CreateItemResult_t>.Create(new CallResult<CreateItemResult_t>.APIDispatchDelegate(HandleCreateItemResult));
        callResult.Set(createHandle);
    }
    private void HandleCreateItemResult(CreateItemResult_t result, bool bIOFailure)
    {
        if (result.m_bUserNeedsToAcceptWorkshopLegalAgreement)
        {
            var url = $"steam://url/CommunityFilePage/{result.m_nPublishedFileId}";
            Debug.LogError($"Cannot create workshop item. Please accept workshop legal agreement: {url}");
            Application.OpenURL(url);
        }

        if (result.m_eResult == EResult.k_EResultOK)
        {
            updateItemParams.ItemID = result.m_nPublishedFileId.m_PublishedFileId;
            SaveAsset();
            Debug.Log($"Workshop item created! (https://steamcommunity.com/sharedfiles/filedetails/?id={result.m_nPublishedFileId})");
            UpdateItem();
        }
        else
            Debug.LogError($"Workshop item creation failed: {result.m_eResult}");
    }
    void UpdateWorkshopItem(PublishedFileId_t itemId, UpdateItemParams updateItemParams)
    {
        Debug.Log("Updating item");
        // Retrieved from the project's steam_appid.txt. Can be manually inserted here as well
        // Initialize the item update
        var updateHandle = SteamUGC.StartItemUpdate(new(appID), itemId);
        // Sets the folder that will be stored as the content for an item. (https://partner.steamgames.com/doc/api/ISteamUGC#SetItemContent)
        SteamUGC.SetItemTitle(updateHandle, updateItemParams.ItemName);
        SteamUGC.SetItemDescription(updateHandle, updateItemParams.ItemDescription);
        SteamUGC.SetItemVisibility(updateHandle, ERemoteStoragePublishedFileVisibility.k_ERemoteStoragePublishedFileVisibilityPublic);
        string contentPath = updateItemParams.ContentRelativePath ? Application.streamingAssetsPath +"/"+ updateItemParams.contentPath : updateItemParams.contentPath;
        SteamUGC.SetItemContent(updateHandle, contentPath);
        string imagePath = updateItemParams.ImageRelativePath ? Application.streamingAssetsPath+"/" + updateItemParams.imagePath:updateItemParams.imagePath;
        Debug.Log(contentPath);
        Debug.Log(imagePath);
        if (!string.IsNullOrEmpty(imagePath))
        {
            // Sets the primary preview image for the item. (https://partner.steamgames.com/doc/api/ISteamUGC#SetItemPreview)
            SteamUGC.SetItemPreview(updateHandle, imagePath);
        }

        // Make the call to the steam back-end
        var itemUpdateHandle = SteamUGC.SubmitItemUpdate(updateHandle, updateItemParams.changeNotes);
        var callResult = CallResult<SubmitItemUpdateResult_t>.Create(new CallResult<SubmitItemUpdateResult_t>.APIDispatchDelegate(HandleItemUpdateResult));
        callResult.Set(itemUpdateHandle);
    }

    /// <summary>
    /// Handle the item update result
    /// </summary>
    private void HandleItemUpdateResult(SubmitItemUpdateResult_t result, bool bIOFailure)
    {
        if (result.m_eResult == EResult.k_EResultOK)
        {
            var url = $"steam://url/CommunityFilePage/{result.m_nPublishedFileId}";
            Debug.Log($"Update Item success! ({url})");
        }
        else
        {
            if (result.m_eResult == EResult.k_EResultFileNotFound)
            {
                updateItemParams.ItemID = 0;
                SaveAsset();
            }
            Debug.LogWarning($"Workshop item update failed: {result.m_eResult}");
        }
    }
    void SaveAsset()
    {
#if UNITY_EDITOR
        EditorUtility.SetDirty(this);
        AssetDatabase.SaveAssets();
        AssetDatabase.Refresh();
        EditorApplication.ExecuteMenuItem("File/Save Project");
#endif
    }
    private void GetSteamWorkshopItems()
    {
        // Retrieved from the project's `steam_appid.txt`. Can be manually inserted here as well
        var appId = SteamUtils.GetAppID();
        Debug.Log($"Requesting items for {appId.m_AppId}...");
        // Create a query request
        var queryRequest = SteamUGC.CreateQueryUserUGCRequest(
            SteamUser.GetSteamID().GetAccountID(),
            EUserUGCList.k_EUserUGCList_Subscribed,
            EUGCMatchingUGCType.k_EUGCMatchingUGCType_Items_ReadyToUse,
            EUserUGCListSortOrder.k_EUserUGCListSortOrder_VoteScoreDesc,
            appId,
            appId,
            1);

        // Make the call to the steam back-end
        var queryHandle = SteamUGC.SendQueryUGCRequest(queryRequest);
        var callResult = CallResult<SteamUGCQueryCompleted_t>.Create(new CallResult<SteamUGCQueryCompleted_t>.APIDispatchDelegate(HandleQueryCompleted));
        callResult.Set(queryHandle);
    }
    /// <summary>
    /// Handle the Steam UGC query result
    /// </summary>
    private void HandleQueryCompleted(SteamUGCQueryCompleted_t response, bool bIOFailure)
    {
        LoadItemsRoutine(response);
    }
    Callback<DownloadItemResult_t> onItemDownloaded;
    void OnItemDownloaded(DownloadItemResult_t item)
    {
        SteamUGC.GetItemInstallInfo(item.m_nPublishedFileId, out var size, out var contentFolder, 255, out var timestamp);
        // Do something with the contents of the Steam Workshop item here!
        Debug.Log($"File content path: {contentFolder}");
    }
    /// <summary>
    /// Coroutine to get the information from Steam Workshop items.
    /// </summary>
    private void LoadItemsRoutine(SteamUGCQueryCompleted_t response)
    {
        Debug.Log($"Items received {response.m_eResult}");
        for (uint i = 0; i < response.m_unNumResultsReturned; i++)
        {
            // Get the Steam Workshop item from the query
            SteamUGC.GetQueryUGCResult(response.m_handle, i, out var workshopItem);
            // Get the size, folder and timestamp of the Steam Workshop item
            if (SteamUGC.DownloadItem(workshopItem.m_nPublishedFileId, true))
            {
                onItemDownloaded = Callback<DownloadItemResult_t>.Create(OnItemDownloaded);
                Debug.Log("Downloading...");
            }

            // Get the mod title
            Debug.Log(workshopItem.m_rgchTitle);

            // Get the mod description
            Debug.Log(workshopItem.m_rgchDescription);

            // Load the mod thumbnail image
            SteamUGC.GetQueryUGCPreviewURL(response.m_handle, i, out var imageUrl, 255);
            Sprite thumbnail = null;
            using (UnityWebRequest uwr = UnityWebRequestTexture.GetTexture(imageUrl))
            {
                uwr.SendWebRequest();

                if (uwr.result != UnityWebRequest.Result.Success)
                    Debug.Log(uwr.error);
                else
                {
                    var texture = DownloadHandlerTexture.GetContent(uwr);
                    thumbnail = Sprite.Create(texture, new Rect(0, 0, texture.width, texture.height), Vector2.zero);
                }
            }
        }
    }
}
#if UNITY_EDITOR
[CustomEditor(typeof(SteamWorksItem))]
class SteamWorksItemEditor : Editor
{
    public override void OnInspectorGUI()
    {
        var _target = target as SteamWorksItem;
        base.OnInspectorGUI();
        GUIStyle style = new(GUI.skin.button)
        {
            fixedHeight = 30
        };
        GUILayout.Space(30);
        if (GUILayout.Button(_target.UpdateItemParams.ItemID==0?"Upload Item":"Update Item", style))
        {
            if (_target.UpdateItemParams.ItemID == 0)
                _target.CreateItem();
            else
                _target.UpdateItem();
        }
        GUILayout.Space(15);
        if (GUILayout.Button("Delete Item", style))
        {
            if (_target.UpdateItemParams.ItemID == 0) return;
            _target.DeleteItem();
        }
        if (GUILayout.Button("Print Mod Assets", style))
        {
            PrintAsset("Assets/" + Directory.GetParent(AssetDatabase.GetAssetPath(_target)).Name);
        }
        if (GUILayout.Button("Update Mod Name to Mod Assets", style))
        {
            RefreshAsset("Assets/"+Directory.GetParent(AssetDatabase.GetAssetPath(_target)).Name, _target.AssetBundleName, _target.UpdateItemParams.ItemID);
        }
        GUILayout.Space(15);
        if (GUILayout.Button("Create AssetBundle", style))
        {
            ClearLogConsole();
            string assetBundleDirectory = $"Assets/StreamingAssets";
            if (!Directory.Exists(assetBundleDirectory)) Directory.CreateDirectory(assetBundleDirectory);
            string[] assetBundles = new string[]
            {
                $"{_target.AssetBundleName.ToLower()}/move/move",
                $"{_target.AssetBundleName.ToLower()}/unna/unna"
            };
            BuildAssetBundlesByName(assetBundles, assetBundleDirectory);
        }
    }
    void PrintAsset(string parent)
    {
        var unnaAssets = AssetDatabase.FindAssets("t:ModAsset", new string[1] { parent });
        foreach (var item in unnaAssets)
        {
            var path = AssetDatabase.GUIDToAssetPath(item);
            var modAsset = (ModAsset)AssetDatabase.LoadAssetAtPath(path, typeof(ModAsset));
            modAsset.PrintJson();
            EditorUtility.SetDirty(modAsset);
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();
        }
    }
    void RefreshAsset(string parent, string modName, ulong modID)
    {
        var unnaAssets = AssetDatabase.FindAssets("t:ModAsset",new string[1] { parent });
        foreach (var item in unnaAssets)
        {
            var path = AssetDatabase.GUIDToAssetPath(item);
            var modAsset = (ModAsset)AssetDatabase.LoadAssetAtPath(path, typeof(ModAsset));
            modAsset.ModName = modName;
            modAsset.ModID = modID;
            Debug.Log(modAsset.name);
            EditorUtility.SetDirty(modAsset);
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();
        }
    }
    public static void BuildAssetBundlesByName(string[] assetBundleNames, string outputPath)
    {
        // Argument validation
        if (assetBundleNames == null || assetBundleNames.Length == 0)
        {
            return;
        }

        // Remove duplicates from the input set of asset bundle names to build.
        //assetBundleNames = assetBundleNames.Distinct().ToArray();

        List<AssetBundleBuild> builds = new List<AssetBundleBuild>();

        foreach (string assetBundle in assetBundleNames)
        {
            var assetPaths = AssetDatabase.GetAssetPathsFromAssetBundle(assetBundle);

            AssetBundleBuild build = new AssetBundleBuild();
            build.assetBundleName = assetBundle;
            build.assetNames = assetPaths;

            builds.Add(build);
            Debug.Log("assetBundle to build:" + build.assetBundleName);
        }

        BuildPipeline.BuildAssetBundles(outputPath, builds.ToArray(), BuildAssetBundleOptions.None, EditorUserBuildSettings.activeBuildTarget);
    }
    public static void ClearLogConsole()
    {
#if UNITY_EDITOR
        System.Reflection.Assembly assembly = System.Reflection.Assembly.GetAssembly(typeof(UnityEditor.SceneView));

        System.Type type = assembly.GetType("UnityEditor.LogEntries");
        System.Reflection.MethodInfo method = type.GetMethod("Clear");
        method.Invoke(new object(), null);
#endif
    }

    void WarnPlay()
    {
        Debug.LogWarning("Press Play before uploading an item! (Ctrl+P)");
    }
}
#endif