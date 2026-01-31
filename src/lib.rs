#![no_std]

use core::{
    arch::global_asm,
    ffi::c_void
};

#[repr(C)]
pub enum DebugRegister {
    DR0 = 1,
    DR1 = 3,
    DR2 = 5,
    DR3 = 7,
    ANY = 0
}

global_asm!(include_str!("set_hook.s"));

#[cfg(all(windows, target_arch="x86_64"))]
unsafe extern "system" {
    pub fn set_hwbp(
        ntcontinue: *const c_void, 
        ntgetcontextthread: *const c_void, 
        hwbp: *const c_void, 
        debug_register: DebugRegister
        ) -> i32;
    pub fn unset_hwbp(
        ntcontinue: *const c_void,
        ntgetthreadcontext: *const c_void,
        hwbp: *const c_void
    );
}
