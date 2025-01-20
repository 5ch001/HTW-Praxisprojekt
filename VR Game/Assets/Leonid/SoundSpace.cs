using UnityEngine;

public class SoundSpace : MonoBehaviour
{ [SerializeField] private AudioClip sceneMusicClip; // Background music clip
    [SerializeField] private float musicVolume = 0.2f; // Background music volume

    [SerializeField] private AudioClip startSoundClip; // Sound to play at the start
    [SerializeField] private float startSoundVolume = 1.0f; // Volume of the start sound

    void Start()
    {
        // Play the start sound
        if (startSoundClip != null)
        {
            AudioSource.PlayClipAtPoint(startSoundClip, transform.position, startSoundVolume);
        }

        // Play the background music if SoundManager exists
        if (SoundManager.Instance != null)
        {
            SoundManager.Instance.PlayBackgroundMusic(sceneMusicClip, musicVolume);
        }
    }
}

