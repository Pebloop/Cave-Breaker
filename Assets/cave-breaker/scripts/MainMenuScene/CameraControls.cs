using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class CameraControls : MonoBehaviour
{
    [SerializeField]
    StandaloneInputModule inputModule;

    [SerializeField]
    private float cameraSpeed = 0.1f;

    [SerializeField]
    private BoxCollider2D cameraLimits;

    private Camera m_camera;

    // Start is called before the first frame update
    void Start()
    {
       m_camera = GetComponent<Camera>();
    }

    // Update is called once per frame
    void Update()
    {
        float horizontalMovement = inputModule.input.GetAxisRaw("Horizontal");
        float verticalMovement = inputModule.input.GetAxisRaw("Vertical");

        // calculate camera movement
        Vector2 movement = new Vector2(horizontalMovement, verticalMovement);
        movement.Normalize();
        movement.x *= Time.deltaTime * cameraSpeed;
        movement.y *= Time.deltaTime * cameraSpeed;

        // ensure the camera doesn't get out of bounds
        Vector3 newPosition = this.transform.position + new Vector3(movement.x, movement.y, 0);
        float halfHeight = m_camera.orthographicSize;
        float halfWidth = halfHeight * m_camera.aspect;
        if (cameraLimits.bounds.min.x < newPosition.x - halfWidth
            && cameraLimits.bounds.max.x > newPosition.x + halfWidth
            && cameraLimits.bounds.min.y < newPosition.y - halfHeight
            && cameraLimits.bounds.max.y > newPosition.y + halfHeight
            )
        {
            this.transform.position = newPosition;
        }
    }
}
