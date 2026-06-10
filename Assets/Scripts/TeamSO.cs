using Newtonsoft.Json;
using System.Collections.Generic;
using System.IO;
using System.Linq;
#if UNITY_EDITOR
using UnityEditor.Search;
#endif
using UnityEditor;
using UnityEngine;
using static LocalizedStringJsonConverter;

[CreateAssetMenu(fileName = "TeamSO_", menuName = "Level/TeamSO")]
public class TeamSO : ModAsset
{
    public TeamTypes Type;
    public GameMode Category;
    public RangerSO Owner;
    [HideInInspector]
    public OpponentAISO AI; 
    public string AIRef; 
    public List<UnnaSaveData> team;
   
#if UNITY_EDITOR
    public override void PrintJson()
    {
        UpdateName();
        Debug.ClearDeveloperConsole();
        string path = $"{Application.streamingAssetsPath}/{ModName}/Team/{name}.txt";
        var settings = new JsonSerializerSettings();
        settings.Converters.Add(new UnnaSaveDataJsonConverter());
        settings.Converters.Add(new RangerSOJsonConverter());
        var jsonValue = JsonConvert.SerializeObject(this, Formatting.Indented, settings);
        Debug.Log(jsonValue);
        if (!Directory.Exists($"{Application.streamingAssetsPath}/{ModName}/Team"))
            Directory.CreateDirectory($"{Application.streamingAssetsPath}/{ModName}/Team");
        if (File.Exists(path)) File.Delete(path);
        File.WriteAllText(path, jsonValue);
    }
    void UpdateName()
    {
        /*string members=string.Empty;
        for (int i = 0; i < Members.Count; i++)
        {
            members += GetChars(Members[i].Name);
        }*/
        string newName = $"{Category}_{AI}_{Owner.name}";
        if (name == newName) return;
        AssetDatabase.RenameAsset(AssetDatabase.GetAssetPath(this), newName);
        EditorUtility.SetDirty(this);
        AssetDatabase.SaveAssets();
        AssetDatabase.Refresh();
    }
    string GetChars(string name)
    {
        if (name.Length>=4)
        return $"{name[0]}{name[1]}{name[2]}{name[3]}";
            else
        return $"{name[0]}{name[1]}{name[2]}";
    }
#endif
}
public enum TeamTypes
{
    Type, Assist, Ability, Status, Boss
}
[System.Serializable]
public struct TeamJson
{
    public List<UnnaSaveData> Members;
    public GameMode Category;
    public string Owner;
    public string AI;
    public TeamTypes TeamType;
}