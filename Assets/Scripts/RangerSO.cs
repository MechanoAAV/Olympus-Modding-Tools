using Newtonsoft.Json;
using System.IO;
#if UNITY_EDITOR
using UnityEditor.Search;
#endif
using UnityEditor;
using UnityEngine;
using UnityEngine.Localization;

[CreateAssetMenu(fileName = "Rang_", menuName = "Level/Ranger")]
public class RangerSO : ModAsset
{
    public LocalizedString Name;
    public string SubName;
    public Sprite Card;
    public int CardSelection = 0;
    public Sprite Portrait;
#if UNITY_EDITOR
    public override void PrintJson()
    {
        string path = $"{Application.streamingAssetsPath}/{ModName}/Ranger/{name}/{name}.txt";
        var settings = new JsonSerializerSettings();
        settings.Converters.Add(new LocalizedStringJsonConverter());
        settings.Converters.Add(new SpriteRefJsonConverter());
        var jsonValue = JsonConvert.SerializeObject(this, settings);
        if (!Directory.Exists($"{Application.streamingAssetsPath}/{ModName}/Ranger"))
            Directory.CreateDirectory($"{Application.streamingAssetsPath}/{ModName}/Ranger");
        if (!Directory.Exists($"{Application.streamingAssetsPath}/{ModName}/Ranger/{name.ToLower()}"))
            Directory.CreateDirectory($"{Application.streamingAssetsPath}/{ModName}/Ranger/{name.ToLower()}");
        if (Portrait)
        {
            File.WriteAllBytes($"{Application.streamingAssetsPath}/{ModName}/Ranger/{name.ToLower()}/{name.ToLower()}_icon.png", ImageConversion.EncodeToPNG(Portrait.texture));
        }
        if (Card)
        {
            File.WriteAllBytes($"{Application.streamingAssetsPath}/{ModName}/Ranger/{name.ToLower()}/{name.ToLower()}_card.png", ImageConversion.EncodeToPNG(Card.texture));
        }
        File.WriteAllText(path, jsonValue);
    }
#endif
}