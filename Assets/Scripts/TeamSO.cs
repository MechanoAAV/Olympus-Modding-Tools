using Newtonsoft.Json;
using System.Collections.Generic;
using System.IO;
using System.Linq;
#if UNITY_EDITOR
using UnityEditor.Search;
#endif
using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;

[CreateAssetMenu(fileName = "TeamSO_", menuName = "Level/TeamSO")]
public class TeamSO : ModAsset
{
    public TeamTypes Type;
    public GameMode Category;
    public TrainerSO Owner;
    public string AI;
    public UnnaSaveData Lead;
    public UnnaSaveData Second;
    public UnnaSaveData Third;
    public UnnaSaveData Ace;
    public List<UnnaSaveData> Members
    {
        get
        {
            List<UnnaSaveData> members = new()
            {
                Lead,
                Second,
                Third,
                Ace
            };
            return members;
        } 
    }
#if UNITY_EDITOR
    public override void PrintJson()
    {
        UpdateName();
        Debug.ClearDeveloperConsole();
        TeamJson json = new()
        {
            Category = Category,
            TeamType = Type,
            Owner = Owner.name,
            AI = AI,
            Members = new()
            {
                Lead,
                Second,
                Third,
                Ace
            }
        };
        string path = $"{Application.streamingAssetsPath}/{ModName}/Team/{name}.json";
        var settings = new JsonSerializerSettings();
        settings.Converters.Add(new UnnaSaveDataJsonConverter());
        var jsonValue = JsonConvert.SerializeObject(json, Formatting.Indented, settings);
        Debug.Log(jsonValue);
        if (!Directory.Exists($"{Application.streamingAssetsPath}/{ModName}/Team"))
            Directory.CreateDirectory($"{Application.streamingAssetsPath}/{ModName}/Team");
        if (File.Exists(path))File.Delete(path);
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