using Newtonsoft.Json;
using System.Collections;
using System.IO;
using System.Linq;
using UnityEngine;
using UnityEngine.Localization;
using static UnnaSaveDataJsonConverter;
[CreateAssetMenu(fileName = "FieldCondition_", menuName = "Oly/Field")]
public class FieldconditionSO : ModAsset
{
    private WaitForSeconds _waitForSeconds_25 = new WaitForSeconds(.25f);
    public bool Weather;
    public bool ReverseSpeed;
    public bool RemoveIfAppliedAgain;
    public GameObject Prefab;
    public Vector3 Offset;
    public Sprite Icon;
    public LocalizedString OnStartMessage;
    public LocalizedString OnCureMessage;
    public LocalizedString OnHurtMessage;
    public LocalizedString OnHealMessage;
    public LocalizedString OnSendoutMessage;
    public int TurnDuration = 3;
    public int MinTurnDuration = 3;
    public int Stackable = 0;
    public FieldBoost[] HealOpponentAmount;
    public bool PreventStatusMoves;
    public bool PreventSwitching;
    public bool RandomizeMove;
    public bool BlockPriority;
    public bool BlockSun;
    public string[] BlockStatusConditions;
    [Range(0, 100)] public float Recoil;
    [Range(0, 100)] public float HurtOnSendout;
    public bool OverrideChosenMove;
    public PositionStatus Position;
    public string[] groupAttackRemovesField;
    public string[] groupImmuneField;
    public FieldBoost[] groupBoostField;
    public FieldBoost[] groupNerfField;
    public FieldBoost[] groupHealField;
    public FieldBoost[] groupHurtField;
    [Space(20)]
    public MoveEffects SetField;
    public FieldStatBoost[] StatChanges;
    [Space(20)]
    [ColorUsage(false, true)] public Color skyColor;
    [ColorUsage(false, true)] public Color equColor;
    [ColorUsage(false, true)] public Color groundColor;
    [ColorUsage(false, false)] public Color fogColor;
    [System.Serializable]
    public struct FieldStatBoost
    {
        public StatBoost Change;
        public string Group;
    }
    [System.Serializable]
    public struct FieldBoost
    {
        public float Change;
        public string Group;
    }
    [System.Serializable]
    public struct FieldHeal
    {
        public float Change;
        public string Group;
    }
    public override void PrintJson()
    {
        string path = Application.streamingAssetsPath + $"/{ModName}/Field/{name.ToLower()}/{name.ToLower()}.txt";
        if (!Directory.Exists(Application.streamingAssetsPath + $"/{ModName}/Field"))
            Directory.CreateDirectory(Application.streamingAssetsPath + $"/{ModName}/Field");
        if (!Directory.Exists(Application.streamingAssetsPath + $"/{ModName}/Field/{name.ToLower()}"))
            Directory.CreateDirectory(Application.streamingAssetsPath + $"/{ModName}/Field/{name.ToLower()}");
        if (!File.Exists(path))
            File.Create(path).Dispose();

        File.WriteAllText(path, SerializeAsset());
    }
    public override string SerializeAsset()
    {
        JsonSerializerSettings serializerSettings = new();
        serializerSettings.Converters.Add(new NewtonsoftColorConverter());
        serializerSettings.Converters.Add(new LocalizedStringJsonConverter());
        serializerSettings.Converters.Add(new SpriteRefJsonConverter());
        serializerSettings.Converters.Add(new NewtonsoftMoveGOConverter());
        serializerSettings.Converters.Add(new NewtonsoftVector3Converter());
        return JsonConvert.SerializeObject(this, Formatting.Indented, serializerSettings);
    }
    public string FieldBlockAging;
}