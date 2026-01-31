# NtContHWBP-RS

This is a small library designed to set hardware breakpoints in Rust via NtContinue.

It contains two functions, set_hwbp, and unset_hwbp. set_hwbp will take enums for the DRx register you want to set. If the ANY enum value is supplied it will search through L0-L3 to determine whether any are currently free.

You'll need to supply pointer to NtContinue, NtGetContextThread, and the HWBP pointer for both functions.

All functions are written in assembly to avoid any unexpected behaviour in Rust. It allows for stricter control over the stack, and to ensure that there are no changes to non-volatile registers inbetween retrieving the context and applying it to the thread that can cause unrecoverable errors.

Only basic testing has been done on these functions, so use at your own peril.
