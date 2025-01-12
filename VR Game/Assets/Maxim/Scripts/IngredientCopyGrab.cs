using UnityEngine;
using UnityEngine.XR.Interaction.Toolkit;
using UnityEngine.XR.Interaction.Toolkit.Interactables;

public class IngredientCopyGrab : MonoBehaviour
{
    public GameObject ingredientPrefab; // Prefab, das gespawnt wird
    private XRGrabInteractable grabInteractable; // Grab Interactable für dieses Objekt
    private bool isGrabbed = false; // Flag to track if the item has been grabbed

    void Start()
    {
        // Initialisiere Grab Interactable und registriere das Event
        grabInteractable = gameObject.GetComponent<XRGrabInteractable>();
        grabInteractable.selectEntered.AddListener(OnGrabbed);
        Debug.Log($"Registered OnGrabbed for {gameObject.name}");
    }

    private void OnGrabbed(SelectEnterEventArgs args)
    {
        if (!isGrabbed)
        {
            isGrabbed = true; // Set the flag to true to indicate the item has been grabbed
            GameManager.collectedIngredients[gameObject.name.Replace("(Clone)", "")]--;
            SpawnIngredientPrefab();
            Invoke(nameof(ResetGrabFlag), 0.1f); // Reset the flag after a short delay
        }
    }

    private void ResetGrabFlag()
    {
        isGrabbed = false; // Reset the flag to allow future grabs
    }

    private void SpawnIngredientPrefab()
    {
        GameObject spawnedPrefab = Instantiate(ingredientPrefab, transform.position, transform.rotation);
        Debug.Log($"Spawned {gameObject.name} prefab at {transform.position}");

        // Enable the grab interactable on the spawned prefab and disable it on the original
        spawnedPrefab.GetComponent<XRGrabInteractable>().enabled = true;
        grabInteractable.enabled = false;

        // Transfer the grab to the spawned prefab
        if (grabInteractable.interactorsSelecting.Count > 0)
        {
            var interactor = grabInteractable.interactorsSelecting[0];
            grabInteractable.interactionManager.SelectExit(interactor, grabInteractable);
            grabInteractable.interactionManager.SelectEnter(interactor, spawnedPrefab.GetComponent<XRGrabInteractable>());
        }
    }

    private void OnDestroy()
    {
        // Remove the event listener to avoid memory leaks
        if (grabInteractable != null)
        {
            grabInteractable.selectEntered.RemoveListener(OnGrabbed);
        }
    }
}