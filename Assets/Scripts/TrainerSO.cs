using Newtonsoft.Json;
using System.IO;
#if UNITY_EDITOR
using UnityEditor.Search;
#endif
using UnityEditor;
using UnityEngine;
using UnityEngine.Localization;

[CreateAssetMenu(fileName = "Trnr_", menuName = "Level/Trainer")]
public class TrainerSO : ModAsset
{
    public LocalizedString Name;
    public string SubName;
    public Sprite Card;
    public int CardSelection=0;
    public Sprite Portrait;
#if UNITY_EDITOR
   public override void PrintJson()
    {
        TrainerJson json = new()
        {
            Name = Name.TableEntryReference.KeyId,
            SubName = SubName,
            SelectedCard=CardSelection
        };
        string path = $"{Application.streamingAssetsPath}/{ModName}/Trainer/{name}/{name}.json";
        var jsonValue = JsonConvert.SerializeObject(json);
        if (!Directory.Exists($"{Application.streamingAssetsPath}/{ModName}/Trainer"))
            Directory.CreateDirectory($"{Application.streamingAssetsPath}/{ModName}/Trainer");
        if (!Directory.Exists($"{Application.streamingAssetsPath}/{ModName}/Trainer/{name.ToLower()}"))
            Directory.CreateDirectory($"{Application.streamingAssetsPath}/{ModName}/Trainer/{name.ToLower()}");
        if (Portrait)
        {
            File.WriteAllBytes($"{Application.streamingAssetsPath}/{ModName}/Trainer/{name.ToLower()}/{name.ToLower()}_icon.png", ImageConversion.EncodeToPNG(Portrait.texture));
        }
        if (Card)
        {
            File.WriteAllBytes($"{Application.streamingAssetsPath}/{ModName}/Trainer/{name.ToLower()}/{name.ToLower()}_card.png", ImageConversion.EncodeToPNG(Card.texture));
        }
        File.WriteAllText(path, jsonValue);
    }
#endif
}
[System.Serializable]
public struct TrainerJson
{
    public long Name;
    public int SelectedCard;
    public string SubName;
}