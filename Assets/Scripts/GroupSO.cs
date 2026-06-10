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
[CreateAssetMenu(fileName = "Group_", menuName = "Unna/Group")]
public class GroupSO : ModAsset
{
    public LocalizedString Name;
    [Tooltip("If the attacker is...then the damage multiplier is...")]
    public List<TypeTableEntry> IncomingAttackChart = new();
    public Color Color;
    public Sprite Icon;
    public bool GroundedImmunity;
    public override void PrintJson()
    {
       string directory = $"{Application.streamingAssetsPath}/{ModName}/Group/{name}/";
        string path = $"{directory}/{this.name}.txt";  
        if (!Directory.Exists(directory))Directory.CreateDirectory(directory);
        if (Icon)
        {

        if (!File.Exists($"{directory}/{Name.GetLocalizedString()}_icon.png")) File.Create($"{directory}/{Name.GetLocalizedString()}_icon.png").Close();
        File.WriteAllBytes($"{directory}/{Name.GetLocalizedString()}_icon.png", ImageConversion.EncodeToPNG(Icon.texture));
        }

        var jsonValue = SerializeAsset();
        Debug.Log(jsonValue);
        File.WriteAllText(path, jsonValue);
#if UNITY_EDITOR
        AssetDatabase.Refresh();
#endif
    }
    public string SerializeAsset()
    {
        var settings = new JsonSerializerSettings();
        settings.Converters.Add(new NewtonsoftColorConverter());
        settings.Converters.Add(new SpriteRefJsonConverter());
        settings.Converters.Add(new LocalizedStringJsonConverter());
        return JsonConvert.SerializeObject(this, Formatting.Indented, settings);
    }
}