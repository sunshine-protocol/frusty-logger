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

use log::{Log, Metadata, Record};

pub use {allo_isolate, allo_isolate::Isolate, log};
#[derive(Clone, Debug, Copy)]
pub struct FrustyLogger {
    pub isolate: Option<Isolate>,
}

impl FrustyLogger {
    pub fn is_initialized(&self) -> bool {
        self.isolate.is_some()
    }
}

impl Log for FrustyLogger {
    fn enabled(&self, _: &Metadata<'_>) -> bool {
        true
    }
    fn log(&self, record: &Record<'_>) {
        let msg = format!("{}:{} {}", record.level(), record.target(), record.args());
        if let Some(isolate) = self.isolate {
            isolate.post(msg);
        }
    }
    fn flush(&self) {}
}

#[macro_export]
macro_rules! include_ffi {
    () => {
        $crate::include_ffi!(with_filter: $crate::log::LevelFilter::Trace);
    };
    (with_filter: $filter: expr) => {
        /// A global Refrence to the Logger Impl
        static mut FRUSTY_LOGGER: $crate::FrustyLogger = $crate::FrustyLogger { isolate: None };

        /// init the logger and return `0` if everything goes well, `1` in case it is already initialized.
        #[no_mangle]
        pub extern "C" fn frusty_logger_init(
            port: i64,
            post_c_object: $crate::allo_isolate::ffi::DartPostCObjectFnType,
        ) -> i32 {
            let logger = unsafe { &mut FRUSTY_LOGGER };
            logger.isolate = Some($crate::allo_isolate::Isolate::new(port));
            let result = $crate::log::set_logger(unsafe { &FRUSTY_LOGGER })
                .map(|_| $crate::log::set_max_level($filter));
            match result {
                Ok(_) => {
                    unsafe {
                        $crate::allo_isolate::store_dart_post_cobject(post_c_object);
                    };
                    0
                }
                Err(_) => 1,
            }
        }

        /// Check if the Logger is already initialized to prevent any errors of calling init again.
        /// return 1 if initialized before, 0 otherwise.
        #[no_mangle]
        pub extern "C" fn frusty_logger_is_initialized() -> i32 {
            let logger = unsafe { &mut FRUSTY_LOGGER };
            if logger.is_initialized() {
                1
            } else {
                0
            }
        }
    };
}
