# MLYacc for Poly/ML

MLYacc is an LALR parser generator for StandardML.
This repository publish MLYacc to be used from Poly/ML, and this is ported from MLYacc implementation bundled in MLton.


## Requires

- Poly/ML
- pdflatex (for docs)
- (optional) mllex-polyml
- (optional) mlyacc-polyml


## Build

Perform `make` like below:

```sh
$ make mlyacc-polyml
```

`mlyacc-lib-1.0.0` and `mlyacc-polyml` will be built.


## Install

Just type `make install`. This command install `mlyacc-polyml` to `/usr/local/bin`.

```sh
$ make install
```

You can change the installation location by using the `PREFIX` variable.

```sh
$ make install PREFIX=~/.sml/polyml
```


## Use

`mlyacc-polyml` take a `.grm` file and generates `.grm.sml`, `.grm.sig` and `.grm.desc` files.
For example, you pass `ml.grm` to this program, `ml.grm.sml`, `ml.grm.sig` and `ml.grm.desc` will be generated.

```sh
$ ./mlyacc-polyml ml.grm

1 shift/reduce conflict
$ ls ml.grm.*
ml.grm.desc  ml.grm.sig  ml.grm.sml
```

These generated files depend on `mlyacc-lib`.
That library can be loaded as follows:

```sh
$ poly
> PolyML.loadModule "/usr/local/lib/polyml/mlyacc-lib-1.0.0.poly";
signature ARG_LEXER = ..
```


See `mlyacc-polyml.pdf` for details.


## Test

Perform `make test`.


## Document

`make docs` will generate `mlyacc-polyml.pdf`.


## License

see LICENSE file for details.


