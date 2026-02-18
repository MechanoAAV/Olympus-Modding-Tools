using Newtonsoft.Json;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEngine;
using UnityEngine.Localization;
using UnityEngine.Serialization;
[System.Serializable]
public struct TypeTableEntry
{
    public string type;
    public float Multiplier;
}
[CreateAssetMenu(fileName = "TypesSO", menuName = "Unna/Types")]
public class TypesSO : ModAsset
{
    public LocalizedString Name;
    [Tooltip("If the attacker is...then the damage multiplier is...")]
    public List<TypeTableEntry> IncomingAttackChart = new();
    public List<TypeTableEntry> OutAttackChart = new();
    public Color Color;
    public bool custom = true;
    public override void PrintJson()
    {
        if (!Directory.Exists(Application.streamingAssetsPath + $"/{ModName.ToLower()}/Class"))
        {
            Directory.CreateDirectory(Application.streamingAssetsPath + $"/{ModName.ToLower()}/Class");
            File.Create(Application.streamingAssetsPath + $"/{ModName.ToLower()}/Class/{name}.txt").Close();
        }
        string path = $"{Application.streamingAssetsPath}/{ModName.ToLower()}/Class/{this.name}.txt";
        var settings = new JsonSerializerSettings();
        settings.Converters.Add(new NewtonsoftColorConverter());
        settings.Converters.Add(new LocalizedStringJsonConverter());
        var jsonValue = JsonConvert.SerializeObject(this, Formatting.Indented, settings);
        Debug.Log(jsonValue);
        File.WriteAllText(path, jsonValue);
#if UNITY_EDITOR
        AssetDatabase.Refresh();
#endif
    }
}