using UnityEngine;

public class SoundManager : MonoBehaviour
{
    public static SoundManager Instance { get; private set; }

    // Sound Effects (SFX) references
    [SerializeField] private AudioClip pickupSound;
    [SerializeField] private AudioClip destroyIngredient;
    [SerializeField] private AudioClip healSound;
    [SerializeField] private AudioClip doorSound;
    [SerializeField] private AudioClip cookingSound;
    [SerializeField] private AudioClip rareSound;
    [SerializeField] private AudioClip legendarySound;
    [SerializeField] private AudioClip normalSound;
    [SerializeField] private AudioClip[] painSounds;

    // We'll let *another* script tell us which background music to play.
    // So we don't store one "backgroundMusic" here by default (unless you want a fallback).

    private AudioSource _sfxSource;
    private AudioSource _musicSource;

    private void Awake()
    {
        // Standard Singleton check
        if (Instance != null && Instance != this)
        {
            Destroy(gameObject);
            return;
        }
        Instance = this;

        // Persist this object across scene loads
        DontDestroyOnLoad(gameObject);

        // Initialize audio sources
        _sfxSource = gameObject.AddComponent<AudioSource>();
        _musicSource = gameObject.AddComponent<AudioSource>();

        _musicSource.loop = true;
        _musicSource.volume = 0.2f;  // Adjust to taste

        // NOTE: We are *not* setting any music clip here.
        // We'll let SceneMusicChanger or another script call PlayBackgroundMusic(...)
    }

    //==================================================
    // SFX Methods
    //==================================================

    public void PlayPickupSound()
    {
        _sfxSource.PlayOneShot(pickupSound);
    }

    public void PlayDestroySound()
    {
        _sfxSource.PlayOneShot(destroyIngredient);
    }

    public void PlayHealSound()
    {
        _sfxSource.PlayOneShot(healSound);
    }

    public void PlayDoorSound()
    {
        _sfxSource.PlayOneShot(doorSound);
    }

    public void PlayCookingSound()
    {
        _sfxSource.PlayOneShot(cookingSound);
    }

    public void PlayRareSound()
    {
        _sfxSource.PlayOneShot(rareSound);
    }

    public void PlayLegendarySound()
    {
        _sfxSource.PlayOneShot(legendarySound);
    }

    public void PlayNormalSound()
    {
        _sfxSource.PlayOneShot(normalSound);
    }

    public void PlayPainSound()
    {
        if (painSounds.Length > 0)
        {
            int randomIndex = Random.Range(0, painSounds.Length);
            _sfxSource.PlayOneShot(painSounds[randomIndex]);
        }
    }

    //==================================================
    // Background Music Method
    //==================================================

    /// <summary>
    /// Call this from another script to change the background music clip.
    /// </summary>
    public void PlayBackgroundMusic(AudioClip clip, float volume = 0.2f)
{
    if (clip == null)
    {
        // Stop if no clip
        _musicSource.Stop();
        return;
    }

    // Only change if it's a different clip
    if (_musicSource.clip != clip)
    {
        _musicSource.clip = clip;
        _musicSource.volume = volume;
        _musicSource.Play();
    }
}

    // Optional: if you need to stop music from outside
    public void StopMusic() => _musicSource.Stop();
}
