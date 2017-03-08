using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class rolling : MonoBehaviour {

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		transform.Rotate(Vector3.up * 30f * Time.deltaTime);
	}
}
