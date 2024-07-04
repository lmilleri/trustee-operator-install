
package policy

default allow = false
allow {
        input["tcb-status"]["sample.svn"] == "1"
}
