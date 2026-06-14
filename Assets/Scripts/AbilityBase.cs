using Newtonsoft.Json;
using System;
using System.Collections;
using System.IO;
using UnityEditor;
using UnityEngine;
using UnityEngine.Localization;
using UnityEngine.Serialization;
public abstract class AbilityBase : ModAsset
{
    public LocalizedString Name;
    public LocalizedString Description;
    public bool CanSkipChargeAttack = false;
    [Range(0,1)]public float HealMultiplier=1;
    /// <summary>
    /// How much an assist multiplies damage taken by the assist unit
    /// </summary>
    [Range(0,2)]public float AssistDamageMultiplier=1;
    /// <summary>
    /// How much an assist multiplies damage taken by the main unit
    /// </summary>
    [Range(0,2)]public float DamageMultiplier=1;
    [Range(0, 5)] public float CriticalChanceMultiplier = 1;
    [Range(0, 5)] public float CriticalChanceReceiveMultiplier = 1;
    [Range(0, 100)] public float Recoil = 0;
    public bool RecoilImmune = false;
    public bool SpikesImmune = false;
    public bool RemoveSpikes = false;
    public bool Mood = false;
    [Header("Status Immunity")]
    public PositionStatus ImmuneToPositionNerf;
    public bool immuneAll;
    public bool bounce;
    public string[] _immuneToCondition;
    public override void PrintJson()
    {
        string path = Application.streamingAssetsPath + $"/{ModName.ToLower()}/Ability/{this.GetType().Name}/{name}.json";
        if (!Directory.Exists(Application.streamingAssetsPath + $"/{ModName.ToLower()}/Ability"))
            Directory.CreateDirectory(Application.streamingAssetsPath + $"/{ModName.ToLower()}/Ability");
        if (!Directory.Exists(Application.streamingAssetsPath + $"/{ModName.ToLower()}/Ability/{this.GetType().Name}"))
            Directory.CreateDirectory(Application.streamingAssetsPath + $"/{ModName.ToLower()}/Ability/{this.GetType().Name}");
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