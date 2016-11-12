# swiftags

Generate ctags for Swift projects using [SourceKitten][].

  [SourceKitten]: https://github.com/jpsim/SourceKitten

## Install

1. Clone the repo
2. `cd swiftags && swift build -c release`
3. Place `.build/release/swiftags` somewhere on your `PATH`

## Usage

    cd my-spm-project
    swift build
    swiftags --spm-module my-spm-project    # creates ./tags

## Contributing

swiftags is currently a proof of concept. Contributions are welcome!

## License

swiftags is copyright © 2016 Adam Sharp. It is free software,
and may be redistributed under the terms specified in the LICENSE file.
