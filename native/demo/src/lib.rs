#[no_mangle]
pub extern "C" fn nop() {
    frusty_logger::link_me_please();
}

#[no_mangle]
pub extern "C" fn rand_log() {
    let lvl = fastrand::u8(0..=4);
    match lvl {
        0 => log::trace!("Hello From Rust :)"),
        1 => log::debug!("Hello From Rust, nice to meet you!"),
        2 => log::info!("Hey there, It is working :D"),
        3 => log::warn!("Oh I guess you miss something here!"),
        4 => log::error!("Damn, something horrible happened :("),
        _ => unreachable!("no way you could get here!"),
    }
}
