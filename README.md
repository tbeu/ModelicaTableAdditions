# ModelicaTableAdditions

Free Modelica library for univariate and bivariate interpolation and extrapolation in lookup-tables.

## Status

[![CI checks](https://github.com/tbeu/ModelicaTableAdditions/actions/workflows/checkCI.yml/badge.svg)](https://github.com/tbeu/ModelicaTableAdditions/actions/workflows/checkCI.yml) [![GitHub license](https://img.shields.io/github/license/tbeu/ModelicaTableAdditions)](https://github.com/tbeu/ModelicaTableAdditions/blob/main/LICENSE)

## Library description

ModelicaTableAdditions is an extension of the CombiTable blocks of the [Modelica Standard Library](https://github.com/modelica/ModelicaStandardLibrary) to support reading CSV, EPW (EnergyPlus Weather) and JSON files.
An overview of the library is provided in

> Thomas Beutlich and Dietmar Winkler. Efficient Parameterization of Modelica Models. In: _Proceedings of
the 14th International Modelica Conference_. Ed. by Martin Sjölund, Lena Buffoni, Adrian Pop, and Lennart Ochel. Linköping, Sweden, September 2021.
DOI: [10.3384/ecp21181141](https://doi.org/10.3384/ecp21181141).

Some more implementation details have been published earlier in

> Thomas Beutlich, Gerd Kurzbach and Uwe Schnabel. Remarks on the Implementation of the Modelica Standard Tables. In: _Proceedings of
the 10th International Modelica Conference_. Ed. by Hubertus Tummescheit and Karl-Erik Årzén. Lund, Sweden, March 2014.
DOI: [10.3384/ecp14096893](https://doi.org/10.3384/ecp14096893).

### Main features

* Read support of file formats
  * [CSV](https://en.wikipedia.org/wiki/Comma-separated_values)
  * EPW (EnergyPlus Weather)
  * [JSON](https://en.wikipedia.org/wiki/JSON)
  * [MATLAB](https://en.wikipedia.org/wiki/MATLAB) MAT of version v4, v6, v7 (and v7.3 depending on Modelica tool)
  * MOS (Text)
* Univariate interpolation by
  * Constant segments
  * Linear segments
  * Akima splines
  * Natural cubic splines
  * Fritsch-Butland splines
  * Steffen splines
  * Modified Akima splines
* Bivariate interpolation by
  * Constant segments
  * Bilinear segments
  * Akima splines
  * Natural cubic splines
* Extrapolation by
  * Constant continuation
  * Continuously differentiable continuation
  * Periodic repetition
  * Extrapolation triggers an error
* C (and not C++) code for external functions and objects
* Cross-platform (Windows and Linux)
* Dependency on the [Modelica Standard Library](https://github.com/modelica/ModelicaStandardLibrary) v4.0.0
* Tested in [Dymola](http://www.dynasim.se) and [OpenModelica](https://openmodelica.org/)

## License

ModelicaTableAdditions is released under the terms of the Simplified BSD License.

## Citing

Use the following BibTeX lines to cite the ModelicaTableAdditions library.

```bibtex
@InProceedings{ModelicaTableAdditions,
  title = {{Efficient Parameterization of Modelica Models}},
  author = {Beutlich, Thomas and Winkler, Dietmar},
  pages = {141--146},
  doi = {10.3384/ecp21181141},
  booktitle = {Proceedings of the 14th International Modelica Conference},
  location = {Link\"oping, Sweden},
  editor = {Sj\"olund, Martin and Buffoni, Lena and Pop, Adrian and Ochel, Lennart},
  isbn = {978-91-7929-027-6},
  issn = {1650-3740},
  month = sep,
  series = {Link\"oping Electronic Conference Proceedings},
  number = {181},
  publisher = {Modelica Association and Link\"oping University Electronic Press},
  year = {2021}
}
```

## Development and contribution

You may report any issues with using the [Issues](../../issues) button.

Contributions in shape of [Pull Requests](../../pulls) are always welcome.
