using Newtonsoft.Json;
using System.IO;
using UnityEngine;

[CreateAssetMenu(fileName = "CustomizSO_", menuName = "Level/CustomizSO")]
public class CustomizSO : ModAsset
{
    public CustomizState State;
    public Texture2D[] Options;
    public override void PrintJson()
    {
        string path = Application.streamingAssetsPath + $"/{ModName}/Customization/{name}";
        if (!Directory.Exists(path))
            Directory.CreateDirectory(path);
        var json = new CustomizJson()
        {
            State = State
        };
        string content = JsonConvert.SerializeObject(json);
        for (int i = 0; i < Options.Length; i++)
        {
            if (Options[i])
                File.WriteAllBytes(path + $"/{Options[i].name}.png", ImageConversion.EncodeToPNG(Options[i]));
        }
        File.WriteAllText(path + $"/{name}.txt", content);
    }
}
[System.Serializable]
public struct CustomizJson
{
    public CustomizState State;
}
public enum CustomizState
{
    BackHair,
    Clothes,
    Collar,
    Jaw,
    Mouth,
    Nose,
    Eyes,
    Earrings,
    Hair,
    Glasses,
    Cap,
    Hands
}