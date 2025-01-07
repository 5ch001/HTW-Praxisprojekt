using UnityEngine;
using UnityEngine.Audio;


public class SoundManager : MonoBehaviour
{
   public static SoundManager Instance { get; private set; }

    // Serialized Fields to allow drag-and-drop in the Inspector
    [SerializeField] private AudioClip pickupSound;
    [SerializeField] private AudioClip backgroundMusic;
    [SerializeField] private AudioClip destroyIngredient;
    [SerializeField] private AudioClip healSound;
    [SerializeField] private AudioClip[] pain;

    // Audio Sources
    private AudioSource _sfxSource; // For sound effects like picking up objects
    private AudioSource _musicSource; // For background music

    void Awake()
    {
        // Singleton pattern to ensure only one SoundManager exists
        if (Instance != null && Instance != this)
        {
            Destroy(gameObject);
            return;
        }
        Instance = this;
        DontDestroyOnLoad(gameObject); // Keeps SoundManager when changing scenes

        // Add the audio sources to the object
        _sfxSource = gameObject.AddComponent<AudioSource>();
        _musicSource = gameObject.AddComponent<AudioSource>();

        // Set up music source (looping background music)
        _musicSource.loop = true;
        _musicSource.clip = backgroundMusic;
         _musicSource.volume = 0.2f;
        _musicSource.Play();
    }

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
    public void PlayPainSound()
    {
        if (pain.Length > 0)
        {
            int randomIndex = Random.Range(0, pain.Length); // Get a random index
            _sfxSource.PlayOneShot(pain[randomIndex]); // Play the randomly selected sound
        }
    }
    public void StopMusic()
    {
        _musicSource.Stop();
    }
    

    public void PlayMusic()
    {
        if (!_musicSource.isPlaying)
        {
            _musicSource.Play();
        }
    }
}