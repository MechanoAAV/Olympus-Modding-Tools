using System;
using System.Collections;
using UnityEngine;

[CreateAssetMenu(fileName = "Ability_", menuName = "Unna/Ability/OnDefeat")]
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
}
public enum AbilityDefeatEffectID
{
    Status, Damage, Clear
}