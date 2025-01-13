using UnityEngine;
using UnityEngine.XR.Interaction.Toolkit;
using UnityEngine.XR.Interaction.Toolkit.Interactables;

public class IngredientCopyGrab : MonoBehaviour
{
    public GameObject ingredientPrefab; // Originalprefab
    private XRGrabInteractable grabInteractable; // Grab Interactable für das Objekt
    private GameObject spawnedPrefab; // Referenz auf das aktuelle Kopierte
    private int ingredientCount = 0; // Zähler für eindeutige Namen

    void Start()
    {
        grabInteractable = gameObject.GetComponent<XRGrabInteractable>();
        grabInteractable.selectEntered.AddListener(OnGrabbed);
        Debug.Log($"Registered OnGrabbed for {gameObject.name}");
    }

    private void OnGrabbed(SelectEnterEventArgs args)
    {
        SpawnIngredientPrefab();
    }

    private void SpawnIngredientPrefab()
    {
        // Kopie erstellen
        spawnedPrefab = Instantiate(ingredientPrefab, transform.position, transform.rotation);
        ingredientCount++;
        spawnedPrefab.name = $"{ingredientPrefab.name}-{ingredientCount}";
        Debug.Log($"Spawned {spawnedPrefab.name} prefab at {transform.position}");

        // Komponenten deaktivieren, damit es nicht gegrabbt werden kann
        spawnedPrefab.GetComponent<XRGrabInteractable>().enabled = false;
        spawnedPrefab.GetComponent<BoxCollider>().enabled = false;

        // Listener für das Zerstören des aktuellen Objekts hinzufügen
        spawnedPrefab.GetComponent<IngredientCopyGrab>().ingredientPrefab = ingredientPrefab;
    }

    private void OnDestroy()
    {
        // Sicherstellen, dass der aktuelle GrabInteractable deaktiviert ist
        if (grabInteractable != null)
        {
            grabInteractable.selectEntered.RemoveListener(OnGrabbed);
        }

        // Aktivieren der Komponenten der Kopie
        if (spawnedPrefab != null)
        {
            spawnedPrefab.GetComponent<XRGrabInteractable>().enabled = true;
            spawnedPrefab.GetComponent<BoxCollider>().enabled = true;
        }
    }
}
