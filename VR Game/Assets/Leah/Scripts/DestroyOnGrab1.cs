using UnityEngine;
using UnityEngine.XR.Interaction.Toolkit;

public class DestroyOnGrab : MonoBehaviour
{
    [Header("Explosion Settings")]
    public GameObject explosionEffectPrefab; // Drag your explosion prefab here
    public float delayBeforeDisappearance = 1f; // Time the object stays visible before disappearing

    private bool isTriggered = false;

    void Start()
    {
        // Add the grab listener
        var grabInteractable = GetComponent<UnityEngine.XR.Interaction.Toolkit.Interactables.XRGrabInteractable>();
        if (grabInteractable != null)
        {
            grabInteractable.selectEntered.AddListener(HandleGrab);
        }
    }

    void HandleGrab(SelectEnterEventArgs args)
    {
        if (!isTriggered)
        {
            isTriggered = true;

            // Schedule the disappearance and explosion using the delay set in the inspector
            Invoke(nameof(TriggerExplosion), delayBeforeDisappearance);
        }
    }

    void TriggerExplosion()
    {
        // Trigger the particle effect at the object's position
        if (explosionEffectPrefab != null)
        {
            Instantiate(explosionEffectPrefab, transform.position, Quaternion.identity);
        }

        // Destroy the object
        Destroy(gameObject);
    }
}
