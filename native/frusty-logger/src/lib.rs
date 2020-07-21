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

use log::{Level, Log, Metadata, Record};

pub use {
    allo_isolate,
    env_logger::filter::{Builder as FilterBuilder, Filter},
    log,
};

/// Filter for android logger.
#[derive(Debug)]
pub struct Config {
    log_level: Option<Level>,
    filter: Option<env_logger::filter::Filter>,
}

impl Config {
    pub const fn empty() -> Self {
        Self {
            log_level: None,
            filter: None,
        }
    }

    pub const fn new(level: Level, filter: env_logger::filter::Filter) -> Self {
        Self {
            log_level: Some(level),
            filter: Some(filter),
        }
    }

    pub const fn log_level(&self) -> Option<Level> {
        self.log_level
    }

    fn filter_matches(&self, record: &Record<'_>) -> bool {
        if let Some(ref filter) = self.filter {
            filter.matches(&record)
        } else {
            true
        }
    }
}

#[derive(Debug)]
pub struct FrustyLogger {
    pub isolate: Option<allo_isolate::Isolate>,
    pub config: Config,
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
        if !self.config.filter_matches(record) {
            return;
        }
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
        $crate::include_ffi!(with_config: $crate::Config::empty());
    };
    (with_config: $config: expr) => {
        /// A global Refrence to the Logger Impl
        static mut FRUSTY_LOGGER: $crate::FrustyLogger = $crate::FrustyLogger {
            isolate: None,
            config: $crate::Config::empty(),
        };

        /// init the logger and return `0` if everything goes well, `1` in case it is already initialized.
        #[no_mangle]
        pub extern "C" fn frusty_logger_init(
            port: i64,
            post_c_object: $crate::allo_isolate::ffi::DartPostCObjectFnType,
        ) -> i32 {
            let logger = unsafe { &mut FRUSTY_LOGGER };
            logger.isolate = Some($crate::allo_isolate::Isolate::new(port));
            logger.config = $config;
            let result = $crate::log::set_logger(unsafe { &FRUSTY_LOGGER });
            match result {
                Ok(_) => {
                    if let Some(level) = logger.config.log_level() {
                        log::set_max_level(level.to_level_filter());
                    }
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
