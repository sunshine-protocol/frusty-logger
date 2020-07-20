<h1 align="center">Frusty Logger</h1>
<div align="center">
  <strong>
    A Bridge between Rust <small>log</small> crate and Flutter <small>debugPrint</small> function
  </strong>

<small>I know I'm terrible at naming packages 😅</small>

</div>

<br />

## Setup

### Rust Crate

> TODO: Publish frusty-logger crate to crates.io

Add `frusty-logger` to your dependencies

```toml
[dependencies]
log = "0.4"
frusty-logger = "0.1.0"
```

and import it into your project like so

```rust

frusty_logger::include_ffi!();

```

now you ready to go, just use the `log` crate as you would.

### Flutter Setup

> TODO: Publish frusty_logger package to pub.dev

Add `frusty_logger` package to your dependencies

```yaml
dependencies:
  frusty_logger: ^0.1.0
```

Then, it is easy to setup, just call

```dart
FrustyLogger.init(dynamicLibrary);
```

usually you will call `init` directly after loading your `dynamicLibrary` and passing a referance to `FrustyLogger` to let it setup the logger and hooking into rust functions.

Done, you should now see logs in your `Debug Console` :).

## Example

See the `native/demo` crate and the `example` app.

to Run the Example, simple run

```
$ cargo make
```

Fire up Android Emulator and the Run the app

```
$ cd example
$ flutter run
```

you should see some loggs on the `Debug Console` when you press the `FAB`.

## TODO

Here the Things that I want to do before making this ready

- [ ] Test it on iOS (it should just work)
- [ ] Add more Options and customization for the logger
- [ ] Publish on crates.io
- [ ] Add Colors & Emoji
- [ ] Publish on pub.dev
