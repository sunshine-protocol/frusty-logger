#![deny(
    missing_debug_implementations,
    missing_copy_implementations,
    elided_lifetimes_in_paths,
    rust_2018_idioms,
    clippy::fallible_impl_from,
    clippy::missing_const_for_fn,
    intra_doc_link_resolution_failure
)]

//! A Rust Logger crate that logs messages using the Dart `println` function

use std::{ffi::CString, os::raw};

use log::{LevelFilter, Log, Metadata, Record};

type DartPrintlnFn = unsafe extern "C" fn(msg: *mut raw::c_char);

#[derive(Clone, Debug)]
struct FrustyLogger {
    println: Option<DartPrintlnFn>,
}

impl FrustyLogger {
    pub(crate) fn is_initialized(&self) -> bool {
        self.println.is_some()
    }
}

impl Log for FrustyLogger {
    fn enabled(&self, _: &Metadata<'_>) -> bool {
        true
    }
    fn log(&self, record: &Record<'_>) {
        let msg = format!("{}:{} {}", record.level(), record.target(), record.args());
        let msg = CString::new(msg).expect("bad string supplied!");
        if let Some(println) = self.println {
            unsafe {
                println(msg.into_raw());
            }
        }
    }
    fn flush(&self) {}
}

/// A small hack to tell cargo to link this crate with the yours so we could find symbols on runtime.
#[inline(never)]
pub const fn link_me_please() {}

/// A global Refrence to the Logger Impl
static mut LOGGER: FrustyLogger = FrustyLogger { println: None };

/// init the logger and return `0` if everything goes well, `1` in case it is already initialized.
#[no_mangle]
pub extern "C" fn frusty_logger_init(println: DartPrintlnFn) -> i32 {
    let logger = unsafe { &mut LOGGER };
    logger.println = Some(println);
    let result =
        log::set_logger(unsafe { &LOGGER }).map(|_| log::set_max_level(LevelFilter::Trace));
    match result {
        Ok(_) => 0,
        Err(_) => 1,
    }
}

/// Check if the Logger is already initialized to prevent any errors of calling init again.
/// return 1 if initialized before, 0 otherwise.
#[no_mangle]
pub extern "C" fn frusty_logger_is_initialized() -> i32 {
    let logger = unsafe { &mut LOGGER };
    if logger.is_initialized() {
        1
    } else {
        0
    }
}
