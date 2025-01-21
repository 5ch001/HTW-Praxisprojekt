using UnityEngine;

public class BlinkAllLights : MonoBehaviour
{
    public Light[] lights;         // Array of lights to blink
    public float blinkSpeed = 1f;  // Speed of blinking (cycles per second)
    public float maxIntensity = 5f; // Maximum intensity of the lights
    public float minIntensity = 0f; // Minimum intensity of the lights

    private float blinkTimer = 0f; // Timer to manage blinking

    void Update()
    {
        // Update the timer for the blink
        blinkTimer += Time.deltaTime * blinkSpeed;

        // Calculate intensity using a sine wave for smooth transitions
        float intensity = Mathf.Lerp(minIntensity, maxIntensity, (Mathf.Sin(blinkTimer * Mathf.PI * 2) + 1) / 2);

        // Apply the calculated intensity to all lights
        foreach (Light light in lights)
        {
            if (light != null)
            {
                light.intensity = intensity;
            }
        }
    }
}
