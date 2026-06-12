using System;
using UnityEngine;
[CreateAssetMenu(fileName = "Ability_", menuName = "Oly/Ability/BeforeMoveAbility")]
public class AbilityBeforeMove : AbilityBase
{
    public int _timeToHitMult = 1;
    public float _abilityModifier;
    public ConditionToApplyAbilityModifier _condition;
    public GroupSO _class;
}
    [Serializable]
    public struct ConditionToApplyAbilityModifier
    {
        public AbilityCondition Condition;
        public string AttackName;
    }
    public enum AbilityCondition
    {
        AttackType, Contact, NonContact, Class
    }