using UnityEngine;
using UnityEngine.XR.Interaction.Toolkit;
using UnityEngine.XR.Interaction.Toolkit.Interactables;

public class IngredientCopyGrab : MonoBehaviour
{
    public GameObject ingredientPrefab; // Originalprefab
    private XRGrabInteractable grabInteractable; // Grab Interactable für das Objekt
    private GameObject spawnedPrefab; // Referenz auf das aktuelle Kopierte
    private bool hasSpawned = false; // Flag, ob bereits ein Prefab gespawnt

    void Start()
    {
        grabInteractable = gameObject.GetComponent<XRGrabInteractable>();
        grabInteractable.selectEntered.AddListener(OnGrabbed);
        grabInteractable.selectExited.AddListener(OnStopGrabbed);
        Debug.Log($"Registered OnGrabbed for {gameObject.name}");
    }

    private void OnGrabbed(SelectEnterEventArgs args)
    {
        if (!hasSpawned)
        {
            SpawnIngredientPrefab();
            hasSpawned = true;
        }
    }

    private void OnStopGrabbed(SelectExitEventArgs args) {
        ingredientPrefab.GetComponent<Rigidbody>().isKinematic = false;
    }

    private void SpawnIngredientPrefab()
    {
        // Kopie erstellen
        spawnedPrefab = Instantiate(ingredientPrefab, transform.position, transform.rotation);
        spawnedPrefab.name = ingredientPrefab.name;
        Debug.Log($"Spawned {spawnedPrefab.name} prefab at {transform.position}");

        // Komponenten deaktivieren, damit es nicht gegrabbt werden kann
        spawnedPrefab.GetComponent<XRGrabInteractable>().enabled = false;
        spawnedPrefab.GetComponent<BoxCollider>().enabled = false;
        spawnedPrefab.GetComponent<IngredientCopyGrab>().ingredientPrefab = spawnedPrefab;
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
            spawnedPrefab.GetComponent<Rigidbody>().useGravity = true;
            spawnedPrefab.GetComponent<BoxCollider>().enabled = true;
        }
        ReduceIngredientCount();
    }

    private void ReduceIngredientCount()
    {
        GameManager.SetIngredientCount(spawnedPrefab.name, GameManager.GetIngredientCount(spawnedPrefab.name) - 1);
    }
}
