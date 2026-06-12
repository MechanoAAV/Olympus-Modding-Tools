using Newtonsoft.Json;
using System.Collections;
using System.IO;
using System.Linq;
using UnityEngine;
using UnityEngine.Localization;
using static UnnaSaveDataJsonConverter;
[CreateAssetMenu(fileName = "StatusCondition_", menuName = "Oly/Status")]
public class StatusconditionSO : ModAsset
{
    private WaitForSeconds _waitForSeconds0_25 = new WaitForSeconds(0.25f);
    public GameObject Prefab;
    public Vector3 Offset;
    public Sprite Icon;
    public LocalizedString OnStartMessage;
    public LocalizedString OnCureMessage;
    public LocalizedString OnHurtMessage;
    public LocalizedString OnHealMessage;
    public LocalizedString OnPreventedMoveMessage;
    public int TurnDuration = 3;
    public int MinTurnDuration = 3;
    public bool Volatile;
    [Space(20)]
    public bool PreventMovement;
    public bool Stackable;
    public bool Alternate;
    [Range(0, 100)] public float PreventMoveChance;
    [Space(20)]
    [Range(0, 100)] public float HurtAmount;
    public int HurtIncremental;
    [Range(0, 100)] public float HealOpponentAmount;
    public bool PreventStatusMoves;
    public bool PreventSwitching;
    public bool FlinchOnAttack;
    public bool HealBeforeMove;
    public bool RandomizeMove;
    [Range(0, 100)] public float Recoil;
    public bool OverrideChosenMove;
    public PositionStatus Position;
    public string[] groupAttackRemovesStatus;
    public string[] groupImmuneStatus;
    public StatBoost[] Changes;
    public override void PrintJson()
    {
        string path = Application.streamingAssetsPath + $"/{ModName}/Status/{name.ToLower()}/{name.ToLower()}.txt";
        if (!Directory.Exists(Application.streamingAssetsPath + $"/{ModName}/Status"))
            Directory.CreateDirectory(Application.streamingAssetsPath + $"/{ModName}/Status");
        if (!Directory.Exists(Application.streamingAssetsPath + $"/{ModName}/Status/{name.ToLower()}"))
            Directory.CreateDirectory(Application.streamingAssetsPath + $"/{ModName}/Status/{name.ToLower()}");
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
}
public enum PositionStatus
{
    neutral, backed, advanced
}