within ModelicaTableAdditions.Blocks;
package Types
  "Library of constants, external objects and types with choices, especially to build menus"
  extends Modelica.Icons.TypesPackage;

  class ExternalCombiTimeTable
    "External object of 1-dim. table where first column is time"
    extends ExternalObject;

    function constructor "Initialize 1-dim. table where first column is time"
      extends Modelica.Icons.Function;
      input String tableName "Table name";
      input String fileName "File name";
      input Real table[:, :];
      input Modelica.Units.SI.Time startTime;
      input Integer columns[:];
      input Modelica.Blocks.Types.Smoothness smoothness;
      input Modelica.Blocks.Types.Extrapolation extrapolation;
      input Modelica.Units.SI.Time shiftTime=0.0;
      input Modelica.Blocks.Types.TimeEvents timeEvents=Modelica.Blocks.Types.TimeEvents.Always;
      input Boolean verboseRead=true "= true: Print info message; = false: No info message";
      input String delimiter="," "Column delimiter character for CSV file";
      input Integer nHeaderLines=0 "Number of header lines to ignore for CSV file";
      output ExternalCombiTimeTable externalCombiTimeTable;
    external"C" externalCombiTimeTable = ModelicaTableAdditions_CombiTimeTable_init3(
            fileName,
            tableName,
            table,
            size(table, 1),
            size(table, 2),
            startTime,
            columns,
            size(columns, 1),
            smoothness,
            extrapolation,
            shiftTime,
            timeEvents,
            verboseRead,
            delimiter,
            nHeaderLines) annotation (IncludeDirectory="modelica://ModelicaTableAdditions/Resources/C-Sources", Include="#include \"ModelicaTableAdditions.h\"", LibraryDirectory="modelica://ModelicaTableAdditions/Resources/Library", Library={"ModelicaTableAdditions", "ModelicaIOAdditions", "ModelicaMatIO", "zlib", "parson"});
    end constructor;

    function destructor "Terminate 1-dim. table where first column is time"
      extends Modelica.Icons.Function;
      input ExternalCombiTimeTable externalCombiTimeTable;
    external"C" ModelicaTableAdditions_CombiTimeTable_close(
        externalCombiTimeTable) annotation (IncludeDirectory="modelica://ModelicaTableAdditions/Resources/C-Sources", Include="#include \"ModelicaTableAdditions.h\"", LibraryDirectory="modelica://Modelica/Resources/Library", Library={"ModelicaTableAdditions", "ModelicaIOAdditions", "ModelicaMatIO", "zlib", "parson"});
    end destructor;

  end ExternalCombiTimeTable;

  class ExternalCombiTable1D
    "External object of 1-dim. table defined by matrix"
    extends ExternalObject;

    function constructor "Initialize 1-dim. table defined by matrix"
      extends Modelica.Icons.Function;
      input String tableName "Table name";
      input String fileName "File name";
      input Real table[:, :];
      input Integer columns[:];
      input Modelica.Blocks.Types.Smoothness smoothness;
      input Modelica.Blocks.Types.Extrapolation extrapolation=Modelica.Blocks.Types.Extrapolation.LastTwoPoints;
      input Boolean verboseRead=true "= true: Print info message; = false: No info message";
      input String delimiter="," "Column delimiter character for CSV file";
      input Integer nHeaderLines=0 "Number of header lines to ignore for CSV file";
      output ExternalCombiTable1D externalCombiTable1D;
    external"C" externalCombiTable1D = ModelicaTableAdditions_CombiTable1D_init3(
            fileName,
            tableName,
            table,
            size(table, 1),
            size(table, 2),
            columns,
            size(columns, 1),
            smoothness,
            extrapolation,
            verboseRead,
            delimiter,
            nHeaderLines) annotation (IncludeDirectory="modelica://ModelicaTableAdditions/Resources/C-Sources", Include="#include \"ModelicaTableAdditions.h\"", LibraryDirectory="modelica://ModelicaTableAdditions/Resources/Library", Library={"ModelicaTableAdditions", "ModelicaIOAdditions", "ModelicaMatIO", "zlib", "parson"});
    end constructor;

    function destructor "Terminate 1-dim. table defined by matrix"
      extends Modelica.Icons.Function;
      input ExternalCombiTable1D externalCombiTable1D;
    external"C" ModelicaTableAdditions_CombiTable1D_close(externalCombiTable1D)
        annotation (IncludeDirectory="modelica://ModelicaTableAdditions/Resources/C-Sources", Include="#include \"ModelicaTableAdditions.h\"", LibraryDirectory="modelica://Modelica/Resources/Library", Library={"ModelicaTableAdditions", "ModelicaIOAdditions", "ModelicaMatIO", "zlib", "parson"});
    end destructor;

  end ExternalCombiTable1D;

  class ExternalCombiTable2D
    "External object of 2-dim. table defined by matrix"
    extends ExternalObject;

    function constructor "Initialize 2-dim. table defined by matrix"
      extends Modelica.Icons.Function;
      input String tableName "Table name";
      input String fileName "File name";
      input Real table[:, :];
      input Modelica.Blocks.Types.Smoothness smoothness;
      input Modelica.Blocks.Types.Extrapolation extrapolation=Modelica.Blocks.Types.Extrapolation.LastTwoPoints;
      input Boolean verboseRead=true "= true: Print info message; = false: No info message";
      input String delimiter="," "Column delimiter character for CSV file";
      input Integer nHeaderLines=0 "Number of header lines to ignore for CSV file";
      output ExternalCombiTable2D externalCombiTable2D;
    external"C" externalCombiTable2D = ModelicaTableAdditions_CombiTable2D_init3(
            fileName,
            tableName,
            table,
            size(table, 1),
            size(table, 2),
            smoothness,
            extrapolation,
            verboseRead,
            delimiter,
            nHeaderLines) annotation (IncludeDirectory="modelica://ModelicaTableAdditions/Resources/C-Sources", Include="#include \"ModelicaTableAdditions.h\"", LibraryDirectory="modelica://ModelicaTableAdditions/Resources/Library", Library={"ModelicaTableAdditions", "ModelicaIOAdditions", "ModelicaMatIO", "zlib", "parson"});
    end constructor;

    function destructor "Terminate 2-dim. table defined by matrix"
      extends Modelica.Icons.Function;
      input ExternalCombiTable2D externalCombiTable2D;
    external"C" ModelicaTableAdditions_CombiTable2D_close(externalCombiTable2D)
        annotation (IncludeDirectory="modelica://ModelicaTableAdditions/Resources/C-Sources", Include="#include \"ModelicaTableAdditions.h\"", LibraryDirectory="modelica://Modelica/Resources/Library", Library={"ModelicaTableAdditions", "ModelicaIOAdditions", "ModelicaMatIO", "zlib", "parson"});
    end destructor;

  end ExternalCombiTable2D;
  annotation (Documentation(info="<html>
<p>
In this package <strong>types</strong>, <strong>constants</strong> and <strong>external objects</strong> are defined that are used
in library Modelica.Blocks. The types have additional annotation choices
definitions that define the menus to be built up in the graphical
user interface when the type is used as parameter in a declaration.
</p>
</html>"));
end Types;
