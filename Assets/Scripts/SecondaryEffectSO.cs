using UnityEngine;

[CreateAssetMenu(fileName = "SecEffectSO_", menuName = "Oly/Move/SecondaryEffect")]
public class SecondaryEffectSO : ScriptableObject
{
    [SerializeField] MoveEffects _effects;
    public MoveEffects Effects => _effects;
}

[System.Serializable]
public class SecondaryEffect
{
    [SerializeField] SecondaryEffectSO _effectData;
    [Range(0,100)][SerializeField] int chance;
    [SerializeField] MoveTarget target;
    [SerializeField] bool _canTriggerOnAssist;
    public SecondaryEffectSO EffectsData => _effectData;
    public int Chance { get { return chance; } }
    public bool CanTriggerOnAssist { get { return _canTriggerOnAssist; } }
    public MoveTarget Target { get { return target; } }
}