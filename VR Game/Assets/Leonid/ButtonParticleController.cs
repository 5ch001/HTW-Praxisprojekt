using UnityEngine;

public class ButtonParticleController : MonoBehaviour
{
    [SerializeField] private ParticleSystem myParticleSystem;
    [SerializeField] private float maxEmissionRate = 50f; // Maximale Partikel-Emission pro Sekunde
    [SerializeField] private float requiredHoldTime = 3f; // Zeit, um die maximale Emission zu erreichen

    private float buttonHoldTime = 0f;

    public void UpdateParticleSystem(float holdTime)
    {
        buttonHoldTime = holdTime;

        if (myParticleSystem != null)
        {
            var emission = myParticleSystem.emission;
            // Erhöhe die Emissionsrate linear basierend auf der Haltezeit
            emission.rateOverTime = Mathf.Lerp(0, maxEmissionRate, buttonHoldTime / requiredHoldTime);

            if (!myParticleSystem.isPlaying)
            {
                myParticleSystem.Play(); // Starte das Partikel-System
            }
        }
    }

    public void StopParticleSystem()
    {
        if (myParticleSystem != null)
        {
            var emission = myParticleSystem.emission;
            emission.rateOverTime = 0f; // Setze die Emissionsrate auf 0
            myParticleSystem.Stop(); // Stoppe das Partikel-System
        }
    }
}