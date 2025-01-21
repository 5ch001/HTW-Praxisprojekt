using UnityEngine;

public class SoundMars : MonoBehaviour
{
    [SerializeField] private AudioClip sceneMusicClip;
    [SerializeField] private float musicVolume = 0.2f;

    void Start()
    {
        // If SoundManager exists, tell it to play the scene's music
        if (SoundManager.Instance != null)
        {
            SoundManager.Instance.PlayBackgroundMusic(sceneMusicClip, musicVolume);
        }
    }
}
