using UnityEngine;

[CreateAssetMenu(fileName = "Ability_", menuName = "Oly/Ability/BeforeStatus")]
public class AbilityBeforeStatus : AbilityBase
{
    [SerializeField] bool _onVolatile;
    [SerializeField] bool immune;
    [SerializeField] bool immuneAll;
    [SerializeField] ConditionID _immuneToCondition;   
}