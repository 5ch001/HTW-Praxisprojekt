using UnityEngine;
using UnityEngine.XR.Interaction.Toolkit;

public class DestroyOnGrab : MonoBehaviour
{
    [Header("Explosion Settings")]
    public GameObject explosionEffectPrefab; // Drag your explosion prefab here
    public float delayBeforeDisappearance = 1f; // Time before the object disappears

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

            // Save the object's name and log the list
            SaveObjectData();

            // Schedule the disappearance and explosion
            Invoke(nameof(TriggerExplosion), delayBeforeDisappearance);
        }
    }

    void SaveObjectData()
    {
        // Log the name of the current object being destroyed
        Debug.Log($"Object grabbed: {gameObject.name}");

        // Save the object's name to the GameManager's list of destroyed objects
        GameManager.destroyedObjectNames.Add(gameObject.name);

        // Log the entire list of destroyed objects in one line
        string objectsList = string.Join(", ", GameManager.destroyedObjectNames);
        Debug.Log("Current List of Destroyed Objects: " + objectsList);
    }

    void TriggerExplosion()
    {
        // Instantiate the particle effect
        if (explosionEffectPrefab != null)
        {
            Instantiate(explosionEffectPrefab, transform.position, Quaternion.identity);
        }

        // Destroy the object
        Destroy(gameObject);
    }
}
