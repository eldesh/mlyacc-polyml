# MLYacc for Poly/ML

MLYacc is an LALR parser generator for StandardML.
This repository publish MLYacc to be used from Poly/ML, and this is ported from MLYacc implementation bundled in MLton.


## Requires

- Poly/ML
- pdflatex (for docs)
- (optional) mllex-polyml
- (optional) mlyacc-polyml


## Build

To build `mlyacc-polyml`, run the `mlyacc-polyml` target or `mlyacc-polyml-nodocs` if you do not need documents.

```sh
$ make mlyacc-polyml
```


## Install

To install `mlyacc-polyml` and `mlyacc-lib-1.0.0.poly`, run the `install` target.

```sh
$ make install
```

By default, executables and binaries are installed to `/usr/local/polyml/{bin,lib}`.
You can specify the installation location by using the `PREFIX` variable.

```sh
$ make install PREFIX=~/.sml/polyml/5.8.1
```

If you do not want to install documents, run the `install-nodocs` target.

```sh
$ make install-nodocs
```


## Use

`mlyacc-polyml` take a `.grm` file and generates `.grm.sml`, `.grm.sig` and `.grm.desc` files.
For example, you pass `ml.grm` to this program, `ml.grm.sml`, `ml.grm.sig` and `ml.grm.desc` will be generated.

```sh
$ ./bin/mlyacc-polyml ml.grm

1 shift/reduce conflict
$ ls ml.grm.*
ml.grm.desc  ml.grm.sig  ml.grm.sml
```

These generated files depend on `mlyacc-lib`.
That library can be loaded as follows:

```sh
$ poly
> PolyML.loadModule "/usr/local/polyml/lib/mlyacc-lib-1.0.0.poly";
signature ARG_LEXER = ..
```


See `doc/mlyacc-polyml.pdf` for details.


## Test

To run unit tets, run the `test` target.

```sh
$ make test
```


## Document

To generate a document of mlyacc-polyml, run the `docs` target.
This target generates `mlyacc-polyml.pdf` to the `doc` directory.


## License

see LICENSE file for details.


