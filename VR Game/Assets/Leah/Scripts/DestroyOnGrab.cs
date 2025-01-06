using UnityEngine;
using UnityEngine.XR.Interaction.Toolkit;

public class DestroyOnGrab : MonoBehaviour
{
    [Header("Explosion Settings")]
    public GameObject explosionEffectPrefab;
    private float delayBeforeDisappearance = 0.3f;
    private bool isTriggered = false;
    public ScoreManager scoreManager;
    public PlayerController playerController;

    void Start()
    {
        scoreManager = FindFirstObjectByType<ScoreManager>();
        playerController = FindFirstObjectByType<PlayerController>();
        // Add the grab listener
        var grabInteractable = GetComponent<UnityEngine.XR.Interaction.Toolkit.Interactables.XRGrabInteractable>();
        if (grabInteractable != null)
        {
            grabInteractable.selectEntered.AddListener(HandleGrab);
            Debug.Log("Listener added to XRGrabInteractable selectEntered event.");
        }
        else
        {
            Debug.LogError("XRGrabInteractable component is missing!");
        }
    }

    public void HandleGrab(SelectEnterEventArgs args)
    {
        if (!isTriggered)
        {
            isTriggered = true;
            SoundManager.Instance.PlayPickupSound();

            SaveObjectData();

            // Schedule the disappearance and explosion
            Invoke(nameof(TriggerExplosion), delayBeforeDisappearance);
        }
    }

    void SaveObjectData()
    {
        Debug.Log($"Object grabbed: {gameObject.name}");

        // Save the object's name to the GameManager's list of destroyed objects
        if (GameManager.destroyedObjectNames == null)
        {
            GameManager.destroyedObjectNames = new System.Collections.Generic.List<string>();
        }
        GameManager.destroyedObjectNames.Add(gameObject.name);

        // Log the entire list of destroyed objects in one line
        string objectsList = string.Join(", ", GameManager.destroyedObjectNames);
        Debug.Log("Current List of Destroyed Objects: " + objectsList);
    }

    void TriggerExplosion()
    {
        if (explosionEffectPrefab != null)
        {
            Instantiate(explosionEffectPrefab, transform.position, Quaternion.identity);
        }

        SoundManager.Instance.PlayDestroySound();

        if (scoreManager != null)
        {
            scoreManager.AddScore(50f); // arbitrary value
        }
        else
        {
            Debug.LogWarning("ScoreManager is not assigned.");
        }

        if (gameObject.name.Contains("HealthPack"))
        {
            playerController.SetHealthAmount(playerController.GetHealthAmount() + 20f); // Adjust the health amount as needed
        }

        Destroy(gameObject);
    }
}
