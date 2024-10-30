using UnityEngine;

public class PlayerHurtbox : MonoBehaviour
{
    public AudioSource badSound;
    void OnTriggerEnter(Collider other) {
        badSound.Play();
    }
}
