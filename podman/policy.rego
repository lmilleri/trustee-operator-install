
package policy

default allow = true

allow {
	input["tee"] != "sample"
}

