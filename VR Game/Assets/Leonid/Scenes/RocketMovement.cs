using UnityEngine;

public class RocketMovement : MonoBehaviour
{
    
    public float speed = 5f;

    void Update()
    {
        
        Vector3 movement = new Vector3(1, 5, 0).normalized * speed * Time.deltaTime;

        
        transform.Translate(movement);
    }
}
