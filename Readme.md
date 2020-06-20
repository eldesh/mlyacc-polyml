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

`mlyacc-polyml` will be built.


## Use

`mlyacc-polyml` take a `.grm` file and generates `.grm.sml`, `.grm.sig` and `.grm.desc` files.
For example, you pass `ml.grm` to this program, `ml.grm.sml`, `ml.grm.sig` and `ml.grm.desc` will be generated.

```sh
$ ./mlyacc-polyml ml.grm

1 shift/reduce conflict
$ ls ml.grm.*
ml.grm.desc  ml.grm.sig  ml.grm.sml
```

See `mlyacc-polyml.pdf` for details.


## Test

Perform `make test`.


## Document

`make docs` will generate `mlyacc-polyml.pdf`.


## License

see LICENSE file for details.


