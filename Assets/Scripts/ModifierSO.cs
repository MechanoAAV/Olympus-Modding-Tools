using Newtonsoft.Json;
using System.IO;
using UnityEditor;
using UnityEngine;
using UnityEngine.Localization;

public abstract class ModifierSO : ModAsset
{
    public LocalizedString Name;
    public LocalizedString Description;
    public float DamageModifer=1;
    public bool OneUse = false;
    public Color Color;
    public bool SpikesImmune;
    public override void PrintJson()
    {
        string path = Application.streamingAssetsPath + $"/{ModName.ToLower()}/Modifier/{this.GetType().Name}/{name}.json";
        if (!Directory.Exists(Application.streamingAssetsPath + $"/{ModName.ToLower()}/Modifier"))
            Directory.CreateDirectory(Application.streamingAssetsPath + $"/{ModName.ToLower()}/Modifier");
        if (!Directory.Exists(Application.streamingAssetsPath + $"/{ModName.ToLower()}/Modifier/{this.GetType().Name}"))
            Directory.CreateDirectory(Application.streamingAssetsPath + $"/{ModName.ToLower()}/Modifier/{this.GetType().Name}");
        if (!File.Exists(path))
            File.Create(path).Dispose();
        JsonSerializerSettings serializerSettings = new();
        serializerSettings.Converters.Add(new NewtonsoftColorConverter());
        serializerSettings.Converters.Add(new LocalizedStringJsonConverter());
        File.WriteAllText(path, JsonConvert.SerializeObject(this, Formatting.Indented, serializerSettings));
#if UNITY_EDITOR
        AssetDatabase.Refresh();
#endif
    }
}