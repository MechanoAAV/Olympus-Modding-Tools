using PrimeTween;
using System;
using System.Globalization;
using UnityEngine;

public class BattleAnimationEvents : MonoBehaviour
{
    public Action SpawnAttack;
    public Action SpawnDamage;
    [SerializeField] GameObject[] _gameObjects;
    [SerializeField] AudioClip _attackAudioClip;
    [SerializeField] AudioClip _deathAudioClip;
    public void ToggleObject(int i)
    {
        if (i >= _gameObjects.Length) return;
        _gameObjects[i].SetActive(true);
    }
    public void SpawnFX()
    {
        SpawnAttack?.Invoke();
    }
    public void TexAnim(string vector)
    {
        if (!data) GetComponentInParent<ModelData>(includeInactive: true);
        if (!data) return;
        if (data.Materials == null) return;
        string[] temp = vector.Substring(1, vector.Length - 2).Split(',');
        float floatx = float.Parse(temp[0], CultureInfo.InvariantCulture);
        float floaty = float.Parse(temp[1], CultureInfo.InvariantCulture);
        int index = (int)float.Parse(temp[2], CultureInfo.InvariantCulture);
        if (index >= data.Materials.Count) return;
        data.Materials[index].SetVector("_TexAnim", new Vector2(floatx, floaty));
    }
    public void TexAnimReset(int i)
    {
        if (!data) GetComponentInParent<ModelData>(includeInactive: true);
        if (!data) return;
        if (data.Materials == null) return;
        if (i >= data.Materials.Count) return;
        data.Materials[i].SetVector("_TexAnim", new Vector2(0, 0));
    }
    AudioSource _source;
    public void CryEnter()
    {
        if (!_source)
            _source = GetComponent<AudioSource>();
        _source.pitch = 1;
        _source.Play();
    }
    public void CryDeath()
    {
        if (!_source)
            _source = GetComponent<AudioSource>();
        if (_deathAudioClip)
        {
            _source.PlayOneShot(_deathAudioClip);
            return;
        }
        _source.pitch = .8f;
        _source.Play();
    }
    public void CryAttack()
    {
        if (!_source)
            _source = GetComponent<AudioSource>();
        if (_attackAudioClip)
        {
            _source.PlayOneShot(_attackAudioClip);
            return;
        }
        _source.Play();
    }
    public void SpawnDamageFX()
    {
        SpawnDamage?.Invoke();
    }
    ModelData data;
    private void Awake()
    {
        data = GetComponentInParent<ModelData>();
    }
}