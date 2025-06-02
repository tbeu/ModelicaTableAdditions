within ;
package ModelicaTableAdditions "Extension of the CombiTable blocks of the Modelica Standard Library to additionally support reading CSV, EPW (EnergyPlus Weather) and JSON files"
  extends Modelica.Icons.Package;
  annotation(
    uses(Modelica(version="4.0.0")),
    version="3.2.1",
    conversion(
      noneFromVersion="3.0.0",
      noneFromVersion="3.1.0",
      noneFromVersion="3.2.0",
      from(
        version={"1.0.0", "1.0.1", "1.0.2", "2.0.0", "2.0.1", "2.0.2", "2.1.0", "2.1.1", "2.2.0", "2.2.1", "2.2.2", "2.2.3", "2.3.0", "2.3.1", "2.3.2"},
        script="modelica://ModelicaTableAdditions/Resources/Scripts/Conversion/ConvertModelicaTableAdditions_from_any_to_3.0.0.mos")),
    Documentation(info="<html><p>Library <strong>ModelicaTableAdditions</strong> is an extension of the CombiTable blocks of the <a href=\"modelica://Modelica\">Modelica Standard Library</a> to additionally support reading <a href=\"https://en.wikipedia.org/wiki/Comma-separated_values\">CSV</a>, EPW (EnergyPlus Weather) and <a href=\"https://en.wikipedia.org/wiki/JSON\">JSON</a> files. Furthermore, it also features cubic spline interpolation.</p></html>"));
end ModelicaTableAdditions;
