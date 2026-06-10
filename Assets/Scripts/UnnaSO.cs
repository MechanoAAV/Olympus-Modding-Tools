using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;

#if UNITY_EDITOR
#endif
using UnityEngine;
using UnityEngine.Localization;
public enum GameMode
{
    Light, Heavy, SuperHeavy, Free
}
[CreateAssetMenu(fileName = "Oly_", menuName = "Oly/Oly")]
public class OlySO : ModAsset
{
    public int Index;
    public LocalizedString Name;
    public LocalizedString Descr;
    public string[] GroupsRef;
    [HideInInspector]
    public GroupSO[] Groups;
    public string[] AbilitiesRef;
    [HideInInspector]
    public AbilityBase[] Abilities;
    public GameMode WeightClass;
    public Sprite Portrait;
    public float Size = 1;
    [Range(0, 250)] public int MaxHP;
    [Range(0, 150)] public int Attack;
    [Range(0, 150)] public int BlessPower;
    [Range(0, 150)] public int Defense;
    [Range(0, 150)] public int BlessRes;
    [Range(0, 150)] public int Speed;
    public string[] AssistMovesRef;
    [HideInInspector]
    public MoveSO[] AssistMoves;
    public string[] LearnableMovesRef = new string[3];
    [HideInInspector]
    public MoveSO[] LearnableMoves = new MoveSO[3];
    public List<UnnaPreset> Presets;
    public int GetBST => Attack + Defense + MaxHP + BlessPower + BlessRes + Speed;
    public int GetHP
    {
        get { return MaxHP; }
    }
    public int Getattack
    {
        get { return Attack; }
    }
    public int Getdefense
    {
        get { return Defense; }
    }
    public int GetBlessPower
    {
        get { return BlessPower; }
    }
    public int GetBlessRes
    {
        get { return BlessRes; }
    }
    public int Getspeed
    {
        get { return Speed; }
    }
#if UNITY_EDITOR
    public override void PrintJson()
    {
        LearnableMoves = new MoveSO[LearnableMovesRef.Length];
        for (int i = 0; i < LearnableMoves.Length; i++)
        {
            LearnableMoves[i] = CreateInstance<MoveSO>();
            LearnableMoves[i].name = LearnableMovesRef[i];
        }
        AssistMoves = new MoveSO[AssistMovesRef.Length];
        for (int i = 0; i < AssistMovesRef.Length; i++)
        {
            AssistMoves[i] = CreateInstance<MoveSO>();
            AssistMoves[i].name = AssistMovesRef[i];
        }
        Groups = new GroupSO[GroupsRef.Length];
        for (int i = 0; i < Groups.Length; i++)
        {
            Groups[i] = CreateInstance<GroupSO>();
            Groups[i].name = GroupsRef[i];
        }
        Abilities = new AbilityBase[AbilitiesRef.Length];
        for (int i = 0; i < Abilities.Length; i++)
        {
            Abilities[i] = CreateInstance<AbilityGeneric>();
            Abilities[i].name = AbilitiesRef[i];
        }
        string path = Application.streamingAssetsPath + $"/{ModName}/Oly/{name.ToLower()}/{name.ToLower()}.txt";

        if (!File.Exists(path) || !Directory.Exists(Application.streamingAssetsPath + $"/{ModName}/Oly/{name.ToLower()}"))
        {
            Directory.CreateDirectory(Application.streamingAssetsPath + $"/{ModName}/Oly/{name.ToLower()}");
            File.Create(path).Dispose();
        }
        File.WriteAllBytes(Application.streamingAssetsPath + $"/{ModName}/Oly/{name.ToLower()}/{name.ToLower()}_icon.png", ImageConversion.EncodeToPNG(Portrait.texture));
        var settings = new JsonSerializerSettings();
        settings.Converters.Add(new TypeRefJsonConverter());
        settings.Converters.Add(new NewtonsoftMoveGOConverter());
        settings.Converters.Add(new SpriteRefJsonConverter());
        settings.Converters.Add(new MoveSOJsonConverter());
        settings.Converters.Add(new LocalizedStringJsonConverter());
        settings.Converters.Add(new UnnaPresetJsonConverter());
        settings.Converters.Add(new ModifierSOJsonConverter());
        settings.Converters.Add(new AbilityJsonConverter());
        File.WriteAllText(path, JsonConvert.SerializeObject(this, Formatting.Indented, settings));
        Debug.Log(name);
        SaveMJSon();
    }
    [SerializeField] ModelDataJson _mData;
    void SaveMJSon()
    {
        Debug.Log(name);
        string path = Application.streamingAssetsPath + $"/{ModName}/Oly/{name.ToLower()}/{name.ToLower()}_mdata.txt";

        if (!File.Exists(path) || !Directory.Exists(Application.streamingAssetsPath + $"/{ModName}/Oly/{name.ToLower()}"))
        {
            Directory.CreateDirectory(Application.streamingAssetsPath + $"/{ModName}/Oly/{name.ToLower()}");
            File.Create(path).Dispose();
        }
        File.WriteAllText(path, JsonUtility.ToJson(_mData, true));
    }

#endif
}
[System.Serializable]
public struct TextureAnimDataJson
{
    public string ClipName;
    public AnimDataJson[] animData;
}
[System.Serializable]
public struct AnimDataJson
{
    public int MatIndex;//which material
    public float Time;//The time the texture animation begins
    public float TexValuex;//The value of your x texture animation
    public float TexValuey;//The value of your y texture animation
}
[System.Serializable]
public struct ModelDataJson
{
    public float size;
    public float radius;
    public float EventCryEnterTime;
    public float EventCryDeathTime;
    public float EventPhysTime;
    public float EventBladeTime;
    public float EventKickTime;
    public float EventBeamTime;
    public float EventWaveTime;
    public float EventDefeatTime;
    public TextureAnimDataJson[] TexAnims;
    public Vector2 MaterialEmmissionMinMax;
    public float MaterialEmmissionSpeed;
    public float MaterialEmmissionColor;
}
[System.Serializable]
public struct UnnaSaveData
{
    public string name;
    public string modifier;
    public int ability;
    public int assist;
    public string[] learntMoves;
    public StatBoost[] StatReinforcement;
}
[Serializable]
public struct UnnaPreset
{
    public string Name;
    public UnnaSaveData Data;
}
public enum Stat
{
    Attack, Defense, BlessPower, Speed, BlessRes,
        //MoveStats
        Accuracy, Evasion,
        //Non Boost Stat
        HP
}