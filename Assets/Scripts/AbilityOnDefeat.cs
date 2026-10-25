using System;
using System.Collections;
using UnityEngine;

[CreateAssetMenu(fileName = "Ability_", menuName = "Oly/Ability/OnDefeat")]
public class AbilityOnDefeat : AbilityBase
{
    [SerializeField] AbilityDefeatEffect _effect;
}
[Serializable]
public struct AbilityDefeatEffect
{
    public AbilityDefeatEffectID Condition;
    public MoveTarget target;
    public MoveEffects boost;
    [Range(0, 100)]
    public int DamageAmountPercentage;
}
public enum AbilityDefeatEffectID
{
    Status, Damage, Clear, SpikesRemove, DisableItem
}