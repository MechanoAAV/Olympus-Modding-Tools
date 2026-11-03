using Newtonsoft.Json;
using System.IO;
using UnityEngine;


[CreateAssetMenu(fileName = "AI_", menuName = "Level/AI")]
public class MasterAI : OpponentAISO
{
    public bool _canSwitchOut;
    public bool _canAssist;
    public bool _canPredict;
    public bool _smartSwitchOnFaint;
    public override void PrintJson()
    {
        string path = $"{Application.streamingAssetsPath}/{ModName}/AI/{name}.txt";
        var jsonValue = JsonConvert.SerializeObject(this, Formatting.Indented);
        Debug.Log(jsonValue);
        if (!Directory.Exists($"{Application.streamingAssetsPath}/{ModName}/AI"))
            Directory.CreateDirectory($"{Application.streamingAssetsPath}/{ModName}/AI");
        if (File.Exists(path)) File.Delete(path);
        File.WriteAllText(path, jsonValue);
    }
}