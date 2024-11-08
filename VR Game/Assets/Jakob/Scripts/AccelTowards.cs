using UnityEngine;

public class AccelTowards : MonoBehaviour
{
    public Transform Target;
    public float Acceleration;

    private Rigidbody body;
    private Vector3 targetOffset;

    void Awake() {
        body = gameObject.GetComponent<Rigidbody>();
    }

    void Start() {
        targetOffset = new Vector3(
            Random.Range(-1f, 1f),
            Random.Range(-1f, 1f),
            Random.Range(-1f, 1f)
        ).normalized * 0.5f;
    }

    void FixedUpdate()
    {
        // accelerate towards target
        Vector3 targetVec = (Target.position + targetOffset - transform.position).normalized;
        body.AddForce(targetVec * Acceleration);
    }
}
