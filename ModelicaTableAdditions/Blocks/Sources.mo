within ModelicaTableAdditions.Blocks;
package Sources
  "Library of signal source blocks generating Real, Integer and Boolean signals"
  import Modelica.Blocks.Interfaces;

  extends Modelica.Icons.SourcesPackage;

  block TimeTable
    "Generate a (possibly discontinuous) signal by linear interpolation in a table"
    parameter Real table[:, 2]=fill(0.0, 0, 2)
      "Table matrix (time = first column; e.g., table=[0, 0; 1, 1; 2, 4])"
      annotation (Dialog(groupImage="modelica://Modelica/Resources/Images/Blocks/Sources/TimeTable.png"));
    parameter Modelica.Units.SI.Time timeScale(
      min=Modelica.Constants.eps)=1 "Time scale of first table column"
      annotation (Evaluate=true);
    extends Modelica.Blocks.Interfaces.SignalSource;
    parameter Modelica.Units.SI.Time shiftTime=startTime
      "Shift time of first table column";
  protected
    CombiTimeTable combiTimeTable(
      final tableOnFile=false,
      final table=table,
      final smoothness=ModelicaTableAdditions.Blocks.Types.Smoothness.LinearSegments,
      final extrapolation=Modelica.Blocks.Types.Extrapolation.LastTwoPoints,
      final timeScale=timeScale,
      final offset={offset},
      final startTime=startTime,
      final shiftTime=shiftTime) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  algorithm 
    if size(table, 1) > 1 then
      assert(not (table[1, 1] > 0.0 or table[1, 1] < 0.0), "The first point in time has to be set to 0, but is table[1,1] = " + String(table[1, 1]));
    end if;
  equation 
    assert(size(table, 1) > 0, "No table values defined.");
    connect(combiTimeTable.y[1], y) annotation (Line(points={{11,0},{110,0}}, color={0,0,127}));
    annotation (Documentation(info="<html>
<p>
This block generates an output signal by <strong>linear interpolation</strong> in
a table. The time points and function values are stored in a matrix
<strong>table[i,j]</strong>, where the first column table[:,1] contains the
time points and the second column contains the data to be interpolated.
The table interpolation has the following properties:
</p>
<ul>
<li>The interpolation interval is found by a linear search where the interval used in the
    last call is used as start interval.</li>
<li>The time points need to be <strong>monotonically increasing</strong>.</li>
<li><strong>Discontinuities</strong> are allowed, by providing the same
    time point twice in the table.</li>
<li>Values <strong>outside</strong> of the table range, are computed by
    <strong>extrapolation</strong> through the last or first two points of the
    table.</li>
<li>If the table has only <strong>one row</strong>, no interpolation is performed and
    the function value is just returned independently of the actual time instant.</li>
<li>Via parameters <strong>shiftTime</strong> and <strong>offset</strong> the curve defined
    by the table can be shifted both in time and in the ordinate value.
    The time instants stored in the table are therefore <strong>relative</strong>
    to <strong>shiftTime</strong>.</li>
<li>If time &lt; startTime, no interpolation is performed and the offset
    is used as ordinate value for the output.</li>
<li>If the table has more than one row, the first point in time <strong>always</strong> has to be set to <strong>0</strong>, e.g.,
    <strong>table=[1,1;2,2]</strong> is <strong>illegal</strong>. If you want to
    shift the time table in time use the <strong>shiftTime</strong> parameter instead.</li>
<li>The table is implemented in a numerically sound way by
    generating <strong>time events</strong> at interval boundaries.
    This generates continuously differentiable values for the integrator.</li>
<li>Via parameter <strong>timeScale</strong> the first column of the table array can
    be scaled, e.g., if the table array is given in hours (instead of seconds)
    <strong>timeScale</strong> shall be set to 3600.</li>
</ul>
<p>
Example:
</p>
<blockquote><pre>
   table = [0, 0;
            1, 0;
            1, 1;
            2, 4;
            3, 9;
            4, 16];
If, e.g., time = 1.0, the output y =  0.0 (before event), 1.0 (after event)
    e.g., time = 1.5, the output y =  2.5,
    e.g., time = 2.0, the output y =  4.0,
    e.g., time = 5.0, the output y = 23.0 (i.e., extrapolation).
</pre></blockquote>

<div>
<img src=\"modelica://Modelica/Resources/Images/Blocks/Sources/TimeTable.png\"
     alt=\"TimeTable.png\">
</div>

</html>"),
      Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics={
          Line(points={{-80,68},{-80,-80}}, color={192,192,192}),
          Polygon(
            points={{-80,90},{-88,68},{-72,68},{-80,90}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Line(points={{-90,-70},{82,-70}}, color={192,192,192}),
          Polygon(
            points={{90,-70},{68,-62},{68,-78},{90,-70}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-48,70},{2,-50}},
            lineColor={255,255,255},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Line(points={{-48,-50},{-48,70},{52,70},{52,-50},{-48,-50},{-48,-20},
                {52,-20},{52,10},{-48,10},{-48,40},{52,40},{52,70},{2,70},{2,-51}}),
          Text(
            extent={{-150,-150},{150,-110}},
            textString="offset=%offset")}));
  end TimeTable;

  block CombiTimeTable
    "Table look-up with respect to time and various interpolation and extrapolation methods (data from matrix/file)"
    import ModelicaTableAdditions.Blocks.Tables.Internal;
    extends Modelica.Blocks.Interfaces.MO(final nout=max([size(columns, 1); size(offset, 1)]));
    parameter Boolean tableOnFile=false
      "= true, if table is defined on file or in function usertab"
      annotation (Dialog(group="Table data definition"));
    parameter Real table[:, :] = fill(0.0, 0, 2)
      "Table matrix (time = first column; e.g., table=[0, 0; 1, 1; 2, 4])"
      annotation (Dialog(group="Table data definition",enable=not tableOnFile));
    parameter String tableName="NoName"
      "Table name on file or in function usertab (see docu)"
      annotation (Dialog(group="Table data definition",enable=tableOnFile));
    parameter String fileName="NoName" "File where matrix is stored"
      annotation (Dialog(
        group="Table data definition",
        enable=tableOnFile,
        loadSelector(filter="Text files (*.txt);;MATLAB MAT-files (*.mat);;Comma-separated values files (*.csv);;EnergyPlus Weather files (*.epw);;JSON files (*.json)",
            caption="Open file in which table is present")));
    parameter String delimiter="," "Column delimiter character for CSV file"
      annotation (Dialog(
        group="Table data definition",
        enable=tableOnFile and isCsvExt),
        choices(choice=" " "Blank", choice="," "Comma", choice="\t" "Horizontal tabulator", choice=";" "Semicolon"));
    parameter Integer nHeaderLines=0 "Number of header lines to ignore for CSV file"
      annotation (Dialog(group="Table data definition",enable=tableOnFile and isCsvExt));
    parameter Boolean verboseRead=true
      "= true, if info message that file is loading is to be printed"
      annotation (Dialog(group="Table data definition",enable=tableOnFile));
    parameter Integer columns[:]=2:size(table, 2)
      "Columns of table to be interpolated"
      annotation (Dialog(group="Table data interpretation",
      groupImage="modelica://Modelica/Resources/Images/Blocks/Sources/CombiTimeTable.png"));
    parameter ModelicaTableAdditions.Blocks.Types.Smoothness smoothness=ModelicaTableAdditions.Blocks.Types.Smoothness.LinearSegments
      "Smoothness of table interpolation"
      annotation (Dialog(group="Table data interpretation"));
    parameter Modelica.Blocks.Types.Extrapolation extrapolation=Modelica.Blocks.Types.Extrapolation.LastTwoPoints
      "Extrapolation of data outside the definition range"
      annotation (Dialog(group="Table data interpretation"));
    parameter Modelica.Units.SI.Time timeScale(
      min=Modelica.Constants.eps)=1 "Time scale of first table column"
      annotation (Dialog(group="Table data interpretation"), Evaluate=true);
    parameter Real offset[:]={0} "Offsets of output signals"
      annotation (Dialog(group="Table data interpretation"));
    parameter Modelica.Units.SI.Time startTime=0
      "Output = offset for time < startTime"
      annotation (Dialog(group="Table data interpretation"));
    parameter Modelica.Units.SI.Time shiftTime=startTime
      "Shift time of first table column"
      annotation (Dialog(group="Table data interpretation"));
    parameter Modelica.Blocks.Types.TimeEvents timeEvents=Modelica.Blocks.Types.TimeEvents.Always
      "Time event handling of table interpolation"
      annotation (Dialog(group="Table data interpretation", enable=smoothness == Modelica.Blocks.Types.Smoothness.LinearSegments));
    parameter Boolean verboseExtrapolation=false
      "= true, if warning messages are to be printed if time is outside the table definition range"
      annotation (Dialog(group="Table data interpretation", enable=extrapolation == Modelica.Blocks.Types.Extrapolation.LastTwoPoints or extrapolation == Modelica.Blocks.Types.Extrapolation.HoldLastPoint));
    final parameter Modelica.Units.SI.Time t_min=t_minScaled*timeScale
      "Minimum abscissa value defined in table";
    final parameter Modelica.Units.SI.Time t_max=t_maxScaled*timeScale
      "Maximum abscissa value defined in table";
    final parameter Real t_minScaled=Internal.getTimeTableTmin(tableID)
      "Minimum (scaled) abscissa value defined in table";
    final parameter Real t_maxScaled=Internal.getTimeTableTmax(tableID)
      "Maximum (scaled) abscissa value defined in table";
  protected
    final parameter Real p_offset[nout]=(if size(offset, 1) == 1 then ones(nout)*offset[1] else offset)
      "Offsets of output signals";
    parameter ModelicaTableAdditions.Blocks.Types.ExternalCombiTimeTable tableID=
        ModelicaTableAdditions.Blocks.Types.ExternalCombiTimeTable(
          if tableOnFile then if isCsvExt then "Values" elseif isEpwExt then "Data" else tableName else "NoName",
          if tableOnFile and fileName <> "NoName" and not Modelica.Utilities.Strings.isEmpty(fileName) then fileName else "NoName",
          table,
          startTime/timeScale,
          columns,
          smoothness,
          extrapolation,
          shiftTime/timeScale,
          if smoothness == ModelicaTableAdditions.Blocks.Types.Smoothness.LinearSegments then timeEvents elseif smoothness == ModelicaTableAdditions.Blocks.Types.Smoothness.ConstantSegments then Modelica.Blocks.Types.TimeEvents.Always else Modelica.Blocks.Types.TimeEvents.NoTimeEvents,
          if tableOnFile then verboseRead else false,
          delimiter,
          nHeaderLines) "External table object";
    discrete Modelica.Units.SI.Time nextTimeEvent(start=0, fixed=true)
      "Next time event instant";
    discrete Real nextTimeEventScaled(start=0, fixed=true)
      "Next scaled time event instant";
    Real timeScaled "Scaled time";
    final parameter Boolean isCsvExt = if tableOnFile then Modelica.Utilities.Strings.findLast(fileName, ".csv", 0, false) + 3 == Modelica.Utilities.Strings.length(fileName) else false annotation (HideResult=true);
    final parameter Boolean isEpwExt = if tableOnFile then Modelica.Utilities.Strings.findLast(fileName, ".epw", 0, false) + 3 == Modelica.Utilities.Strings.length(fileName) else false annotation (HideResult=true);
  equation
    if tableOnFile then
      assert(tableName <> "NoName" or isCsvExt or isEpwExt,
        "tableOnFile = true and no table name given");
    else
      assert(size(table, 1) > 0 and size(table, 2) > 0,
        "tableOnFile = false and parameter table is an empty matrix");
    end if;

    if verboseExtrapolation and (
      extrapolation == Modelica.Blocks.Types.Extrapolation.LastTwoPoints or
      extrapolation == Modelica.Blocks.Types.Extrapolation.HoldLastPoint) then
      assert(noEvent(time >= t_min + shiftTime), "
Extrapolation warning: Time must be greater or equal
than the shifted minimum abscissa value defined in the table.
", level=AssertionLevel.warning);
      assert(noEvent(time <= t_max + shiftTime), "
Extrapolation warning: Time must be less or equal
than the shifted maximum abscissa value defined in the table.
", level=AssertionLevel.warning);
    end if;

    timeScaled = time/timeScale;
    when {time >= pre(nextTimeEvent), initial()} then
      nextTimeEventScaled = Internal.getNextTimeEvent(tableID, timeScaled);
      nextTimeEvent = if nextTimeEventScaled < Modelica.Constants.inf then nextTimeEventScaled*timeScale else Modelica.Constants.inf;
    end when;
    if smoothness == ModelicaTableAdditions.Blocks.Types.Smoothness.ConstantSegments then
      for i in 1:nout loop
        y[i] = p_offset[i] + Internal.getTimeTableValueNoDer(tableID, i, timeScaled, nextTimeEventScaled, pre(nextTimeEventScaled));
      end for;
    elseif smoothness == ModelicaTableAdditions.Blocks.Types.Smoothness.LinearSegments then
      for i in 1:nout loop
        y[i] = p_offset[i] + Internal.getTimeTableValueNoDer2(tableID, i, timeScaled, nextTimeEventScaled, pre(nextTimeEventScaled));
      end for;
    else
      for i in 1:nout loop
        y[i] = p_offset[i] + Internal.getTimeTableValue(tableID, i, timeScaled, nextTimeEventScaled, pre(nextTimeEventScaled));
      end for;
    end if;
    annotation (
      Documentation(info="<html>
<p>
This block generates an output signal y[:] by <strong>constant</strong>,
<strong>linear</strong> or <strong>cubic Hermite spline interpolation</strong>
in a table. The time points and function values are stored in a matrix
<strong>table[i,j]</strong>, where the first column table[:,1] contains the
time points and the other columns contain the data to be interpolated.
</p>

<div>
<img src=\"modelica://Modelica/Resources/Images/Blocks/Sources/CombiTimeTable.png\"
     alt=\"CombiTimeTable.png\">
</div>

<p>
Via parameter <strong>columns</strong> it can be defined which columns of the
table are interpolated. If, e.g., columns={2,4}, it is assumed that
2 output signals are present and that the first output is computed
by interpolation of column 2 and the second output is computed
by interpolation of column 4 of the table matrix.
The table interpolation has the following properties:
</p>
<ul>
<li>The interpolation interval is found by a binary search where the interval used in the
    last call is used as start interval.</li>
<li>The time points need to be <strong>strictly increasing</strong> for cubic Hermite
    spline interpolation, otherwise <strong>monotonically increasing</strong>.</li>
<li><strong>Discontinuities</strong> are allowed for (constant or) linear interpolation,
    by providing the same time point twice in the table.</li>
<li>Via parameter <strong>smoothness</strong> it is defined how the data is interpolated:
<blockquote><pre>
smoothness = 1: Linear interpolation
           = 2: Akima interpolation: Smooth interpolation by cubic Hermite
                splines such that der(y) is continuous, also if extrapolated.
           = 3: Constant segments
           = 4: Fritsch-Butland interpolation: Smooth interpolation by cubic
                Hermite splines such that y preserves the monotonicity and
                der(y) is continuous, also if extrapolated.
           = 5: Steffen interpolation: Smooth interpolation by cubic Hermite
                splines such that y preserves the monotonicity and der(y)
                is continuous, also if extrapolated.
           = 6: Modified Akima interpolation: Smooth interpolation by cubic
                Hermite splines such that der(y) is continuous, also if
                extrapolated. Additionally, overshoots and edge cases of the
                original Akima interpolation method are avoided.
           = 7: Natural cubic spline interpolation, such that der(y) and der2(y)
                are continuous.
</pre></blockquote></li>
<li>First and second <strong>derivatives</strong> are provided, with exception of the following two smoothness options.
<ol>
<li>No derivatives are provided for interpolation by constant segments.</li>
<li>No second derivative is provided for linear interpolation.<br>There is a design inconsistency, that it is possible
to model a signal consisting of constant segments using linear interpolation and duplicated sample points.
In contrast to interpolation by constant segments, the first derivative is provided as zero.</li>
</ol></li>
<li>Values <strong>outside</strong> of the table range, are computed by
    extrapolation according to the setting of parameter <strong>extrapolation</strong>:
<blockquote><pre>
extrapolation = 1: Hold the first or last value of the table,
                   if outside of the table scope.
              = 2: Extrapolate by using the derivative at the first/last table
                   points if outside of the table scope.
                   (If smoothness is LinearSegments or ConstantSegments
                   this means to extrapolate linearly through the first/last
                   two table points.).
              = 3: Periodically repeat the table data (periodical function).
              = 4: No extrapolation, i.e. extrapolation triggers an error
</pre></blockquote></li>
<li>If the table has only <strong>one row</strong>, no interpolation is performed and
    the table values of this row are just returned.</li>
<li>Via parameters <strong>shiftTime</strong> and <strong>offset</strong> the curve defined
    by the table can be shifted both in time and in the ordinate value.
    The time instants stored in the table are therefore <strong>relative</strong>
    to <strong>shiftTime</strong>.</li>
<li>If time &lt; startTime, no interpolation is performed and the offset
    is used as ordinate value for all outputs.</li>
<li>The table is implemented in a numerically sound way by
    generating <strong>time events</strong> at interval boundaries, in case of
    interpolation by linear segments.
    This generates continuously differentiable values for the integrator.
    Via parameter <strong>timeEvents</strong> it is defined how the time events are generated:
<blockquote><pre>
timeEvents = 1: Always generate time events at interval boundaries
           = 2: Generate time events at discontinuities (defined by duplicated sample points)
           = 3: No time events at interval boundaries
</pre></blockquote>
    For interpolation by constant segments time events are always generated at interval boundaries.
    For smooth interpolation by cubic Hermite splines no time events are generated at interval boundaries.</li>
<li>Via parameter <strong>timeScale</strong> the first column of the table array can
    be scaled, e.g., if the table array is given in hours (instead of seconds)
    <strong>timeScale</strong> shall be set to 3600.</li>
<li>For special applications it is sometimes needed to know the minimum
    and maximum time instant defined in the table as a parameter. For this
    reason parameters <strong>t_min</strong>/<strong>t_minScaled</strong> and
    <strong>t_max</strong>/<strong>t_maxScaled</strong> are provided and can be
    accessed from the outside of the table object. Whereas <strong>t_min</strong> and
    <strong>t_max</strong> define the scaled abscissa values (using parameter
    <strong>timeScale</strong>) in SI.Time, <strong>t_minScaled</strong> and
    <strong>t_maxScaled</strong> define the unitless original abscissa values of
    the table.</li>
</ul>
<p>
Example:
</p>
<blockquote><pre>
table = [0, 0;
         1, 0;
         1, 1;
         2, 4;
         3, 9;
         4, 16];
extrapolation = 2 (default), timeEvents = 2
If, e.g., time = 1.0, the output y =  0.0 (before event), 1.0 (after event)
    e.g., time = 1.5, the output y =  2.5,
    e.g., time = 2.0, the output y =  4.0,
    e.g., time = 5.0, the output y = 23.0 (i.e., extrapolation via last 2 points).
</pre></blockquote>
<p>
The table matrix can be defined in the following ways:
</p>
<ol>
<li>Explicitly supplied as <strong>parameter matrix</strong> \"table\",
    and the other parameters have the following values:
<blockquote><pre>
tableName is \"NoName\" or has only blanks,
fileName  is \"NoName\" or has only blanks.
</pre></blockquote></li>
<li><strong>Read</strong> from a <strong>file</strong> \"fileName\" where the matrix is stored as
    \"tableName\". CSV, EPW, JSON, text and MATLAB MAT-file format is possible.
    (Both the limitations on the CSV format and the text format are described below).
    The MAT-file format comes in four different versions: v4, v6, v7 and v7.3.
    The library supports at least v4, v6 and v7 whereas v7.3 is optional.
    It is most convenient to generate the MAT-file from FreeMat or MATLAB&reg;
    by command
<blockquote><pre>
save tables.mat tab1 tab2 tab3
</pre></blockquote>
    or Scilab by command
<blockquote><pre>
savematfile tables.mat tab1 tab2 tab3
</pre></blockquote>
    when the three tables tab1, tab2, tab3 should be used from the model.<br>
    Note, a fileName can be defined as URI by using the helper function
    <a href=\"modelica://Modelica.Utilities.Files.loadResource\">loadResource</a>.</li>
<li>Statically stored in function \"usertab\" in file \"usertab.c\".
    The matrix is identified by \"tableName\". Parameter
    fileName = \"NoName\" or has only blanks. Row-wise storage is always to be
    preferred as otherwise the table is reallocated and transposed.</li>
</ol>
<p>
When the constant \"NO_FILE_SYSTEM\" is defined, all file I/O related parts of the
source code are removed by the C-preprocessor, such that no access to files takes place.
</p>
<p>
If the table is read from a CSV file, the following limitations apply
</p>
<ol>
<li>Non-numeric data is silently considered as value 0.0.</li>
</ol>
<p>
If tables are read from a text file, the file needs to have the
following structure (\"-----\" is not part of the file content):
</p>
<blockquote><pre>
-----------------------------------------------------
#1
double tab1(6,2)   # comment line
  0   0
  1   0
  1   1
  2   4
  3   9
  4  16
double tab2(6,2)   # another comment line
  0   0
  2   0
  2   2
  4   8
  6  18
  8  32
-----------------------------------------------------
</pre></blockquote>
<p>
Note, that the first two characters in the file need to be
\"#1\" (a line comment defining the version number of the file format).
Afterwards, the corresponding matrix has to be declared
with type (= \"double\" or \"float\"), name and actual dimensions.
A valid matrix name (e.g., \"tab1\") must be ASCII encoded and not contain blanks, line breaks, tab (\\t), comma (,) or parentheses.
Finally, in successive rows of the file, the elements of the matrix
have to be given. The elements have to be provided as a sequence of
numbers in row-wise order (therefore a matrix row can span several
lines in the file and need not start at the beginning of a line).
Numbers have to be given according to C syntax (such as 2.3, -2, +2.e4).
Number separators are spaces, tab (\\t), comma (,), or semicolon (;).
Several matrices may be defined one after another. Line comments start
with the hash symbol (#) and can appear everywhere.
Text files should either be ASCII or UTF-8 encoded, where UTF-8 encoded strings are only allowed in line comments and an optional UTF-8 BOM at the start of the text file is ignored.
Other characters, like trailing non comments, are not allowed in the file.
</p>
<p>
MATLAB is a registered trademark of The MathWorks, Inc.
</p>
</html>"),
      Icon(
      coordinateSystem(preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
        graphics={
      Polygon(lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid,
        points={{-80,90},{-88,68},{-72,68},{-80,90}}),
      Line(points={{-80,68},{-80,-80}},
        color={192,192,192}),
      Line(points={{-90,-70},{82,-70}},
        color={192,192,192}),
      Polygon(lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid,
        points={{90,-70},{68,-62},{68,-78},{90,-70}}),
      Rectangle(lineColor={255,255,255},
        fillColor={255,215,136},
        fillPattern=FillPattern.Solid,
        extent={{-48,-50},{2,70}}),
      Line(points={{-48,-50},{-48,70},{52,70},{52,-50},{-48,-50},{-48,-20},{52,-20},{52,10},{-48,10},{-48,40},{52,40},{52,70},{2,70},{2,-51}}),
      Text(textColor={0,0,255},extent={{-85,110},{85,65}},textString=DynamicSelect("csv", if isCsvExt then if delimiter == " " then "c s v" elseif delimiter == "," then "c,s,v" elseif delimiter == "\t" then "c\\ts\\tv" elseif delimiter == ";" then "c;s;v" else "csv" elseif isEpwExt then "epw" else "")),
      Text(extent={{-150,-150},{150,-110}}, textString="tableOnFile=%tableOnFile")}));
  end CombiTimeTable;

  block FileUpdateTimeTable
    "Table look-up with respect to time and various interpolation and extrapolation methods (data from file)"
    import ModelicaTableAdditions.Blocks.Tables.Internal;
    extends CombiTimeTable(
      final tableOnFile=true,
      final table=fill(0.0, 0, 2));
    parameter Boolean forceRead = false "= true: Force reading of table data; = false: Only read, if not yet read."
      annotation (Dialog(group="Table data definition"));
    Modelica.Blocks.Interfaces.BooleanInput updateTrigger "Connector of Boolean input signal for reading table data from file"
      annotation (Placement(transformation(extent={{-20,-20},{20,20}}, rotation=-90, origin={0,120})));
    Real readSuccess "Table read success";
  equation
    when updateTrigger then
      readSuccess = Internal.readTimeTableData(tableID, forceRead, verboseRead);
    end when;
    annotation (
      Documentation(info="<html>
<p>
This block generates an output signal y[:] by <strong>constant</strong>,
<strong>linear</strong> or <strong>cubic Hermite spline interpolation</strong>
in a table. The time points and function values are stored in a matrix
<strong>table[i,j]</strong>, where the first column table[:,1] contains the
time points and the other columns contain the data to be interpolated.
</p>

<div>
<img src=\"modelica://Modelica/Resources/Images/Blocks/Sources/CombiTimeTable.png\"
     alt=\"CombiTimeTable.png\">
</div>

<p>
Via parameter <strong>columns</strong> it can be defined which columns of the
table are interpolated. If, e.g., columns={2,4}, it is assumed that
2 output signals are present and that the first output is computed
by interpolation of column 2 and the second output is computed
by interpolation of column 4 of the table matrix.
The table interpolation has the following properties:
</p>
<ul>
<li>The interpolation interval is found by a binary search where the interval used in the
    last call is used as start interval.</li>
<li>The time points need to be <strong>strictly increasing</strong> for cubic Hermite
    spline interpolation, otherwise <strong>monotonically increasing</strong>.</li>
<li><strong>Discontinuities</strong> are allowed for (constant or) linear interpolation,
    by providing the same time point twice in the table.</li>
<li>Via parameter <strong>smoothness</strong> it is defined how the data is interpolated:
<blockquote><pre>
smoothness = 1: Linear interpolation
           = 2: Akima interpolation: Smooth interpolation by cubic Hermite
                splines such that der(y) is continuous, also if extrapolated.
           = 3: Constant segments
           = 4: Fritsch-Butland interpolation: Smooth interpolation by cubic
                Hermite splines such that y preserves the monotonicity and
                der(y) is continuous, also if extrapolated.
           = 5: Steffen interpolation: Smooth interpolation by cubic Hermite
                splines such that y preserves the monotonicity and der(y)
                is continuous, also if extrapolated.
           = 6: Modified Akima interpolation: Smooth interpolation by cubic
                Hermite splines such that der(y) is continuous, also if
                extrapolated. Additionally, overshoots and edge cases of the
                original Akima interpolation method are avoided.
           = 7: Natural cubic spline interpolation, such that der(y) and der2(y)
                are continuous.
</pre></blockquote></li>
<li>First and second <strong>derivatives</strong> are provided, with exception of the following two smoothness options.
<ol>
<li>No derivatives are provided for interpolation by constant segments.</li>
<li>No second derivative is provided for linear interpolation.<br>There is a design inconsistency, that it is possible
to model a signal consisting of constant segments using linear interpolation and duplicated sample points.
In contrast to interpolation by constant segments, the first derivative is provided as zero.</li>
</ol></li>
<li>Values <strong>outside</strong> of the table range, are computed by
    extrapolation according to the setting of parameter <strong>extrapolation</strong>:
<blockquote><pre>
extrapolation = 1: Hold the first or last value of the table,
                   if outside of the table scope.
              = 2: Extrapolate by using the derivative at the first/last table
                   points if outside of the table scope.
                   (If smoothness is LinearSegments or ConstantSegments
                   this means to extrapolate linearly through the first/last
                   two table points.).
              = 3: Periodically repeat the table data (periodical function).
              = 4: No extrapolation, i.e. extrapolation triggers an error
</pre></blockquote></li>
<li>If the table has only <strong>one row</strong>, no interpolation is performed and
    the table values of this row are just returned.</li>
<li>Via parameters <strong>shiftTime</strong> and <strong>offset</strong> the curve defined
    by the table can be shifted both in time and in the ordinate value.
    The time instants stored in the table are therefore <strong>relative</strong>
    to <strong>shiftTime</strong>.</li>
<li>If time &lt; startTime, no interpolation is performed and the offset
    is used as ordinate value for all outputs.</li>
<li>The table is implemented in a numerically sound way by
    generating <strong>time events</strong> at interval boundaries, in case of
    interpolation by linear segments.
    This generates continuously differentiable values for the integrator.
    Via parameter <strong>timeEvents</strong> it is defined how the time events are generated:
<blockquote><pre>
timeEvents = 1: Always generate time events at interval boundaries
           = 2: Generate time events at discontinuities (defined by duplicated sample points)
           = 3: No time events at interval boundaries
</pre></blockquote>
    For interpolation by constant segments time events are always generated at interval boundaries.
    For smooth interpolation by cubic Hermite splines no time events are generated at interval boundaries.</li>
<li>Via parameter <strong>timeScale</strong> the first column of the table array can
    be scaled, e.g., if the table array is given in hours (instead of seconds)
    <strong>timeScale</strong> shall be set to 3600.</li>
<li>For special applications it is sometimes needed to know the minimum
    and maximum time instant defined in the table as a parameter. For this
    reason parameters <strong>t_min</strong>/<strong>t_minScaled</strong> and
    <strong>t_max</strong>/<strong>t_maxScaled</strong> are provided and can be
    accessed from the outside of the table object. Whereas <strong>t_min</strong> and
    <strong>t_max</strong> define the scaled abscissa values (using parameter
    <strong>timeScale</strong>) in SI.Time, <strong>t_minScaled</strong> and
    <strong>t_maxScaled</strong> define the unitless original abscissa values of
    the table.</li>
</ul>
<p>
Example:
</p>
<blockquote><pre>
table = [0, 0;
         1, 0;
         1, 1;
         2, 4;
         3, 9;
         4, 16];
extrapolation = 2 (default), timeEvents = 2
If, e.g., time = 1.0, the output y =  0.0 (before event), 1.0 (after event)
    e.g., time = 1.5, the output y =  2.5,
    e.g., time = 2.0, the output y =  4.0,
    e.g., time = 5.0, the output y = 23.0 (i.e., extrapolation via last 2 points).
</pre></blockquote>
<p>
The table matrix can be defined in the following ways:
</p>
<ol>
<li><strong>Read</strong> from a <strong>file</strong> \"fileName\" where the matrix is stored as
    \"tableName\". CSV, EPW, JSON, text and MATLAB MAT-file format is possible.
    (Both the limitations on the CSV format and the text format are described below).
    The MAT-file format comes in four different versions: v4, v6, v7 and v7.3.
    The library supports at least v4, v6 and v7 whereas v7.3 is optional.
    It is most convenient to generate the MAT-file from FreeMat or MATLAB&reg;
    by command
<blockquote><pre>
save tables.mat tab1 tab2 tab3
</pre></blockquote>
    or Scilab by command
<blockquote><pre>
savematfile tables.mat tab1 tab2 tab3
</pre></blockquote>
    when the three tables tab1, tab2, tab3 should be used from the model.<br>
    Note, a fileName can be defined as URI by using the helper function
    <a href=\"modelica://Modelica.Utilities.Files.loadResource\">loadResource</a>.</li>
</ol>
<p>
When the constant \"NO_FILE_SYSTEM\" is defined, all file I/O related parts of the
source code are removed by the C-preprocessor, such that no access to files takes place.
</p>
<p>
If the table is read from a CSV file, the following limitations apply
</p>
<ol>
<li>Non-numeric data is silently considered as value 0.0.</li>
</ol>
<p>
If tables are read from a text file, the file needs to have the
following structure (\"-----\" is not part of the file content):
</p>
<blockquote><pre>
-----------------------------------------------------
#1
double tab1(6,2)   # comment line
  0   0
  1   0
  1   1
  2   4
  3   9
  4  16
double tab2(6,2)   # another comment line
  0   0
  2   0
  2   2
  4   8
  6  18
  8  32
-----------------------------------------------------
</pre></blockquote>
<p>
Note, that the first two characters in the file need to be
\"#1\" (a line comment defining the version number of the file format).
Afterwards, the corresponding matrix has to be declared
with type (= \"double\" or \"float\"), name and actual dimensions.
A valid matrix name (e.g., \"tab1\") must be ASCII encoded and not contain blanks, line breaks, tab (\\t), comma (,) or parentheses.
Finally, in successive rows of the file, the elements of the matrix
have to be given. The elements have to be provided as a sequence of
numbers in row-wise order (therefore a matrix row can span several
lines in the file and need not start at the beginning of a line).
Numbers have to be given according to C syntax (such as 2.3, -2, +2.e4).
Number separators are spaces, tab (\\t), comma (,), or semicolon (;).
Several matrices may be defined one after another. Line comments start
with the hash symbol (#) and can appear everywhere.
Text files should either be ASCII or UTF-8 encoded, where UTF-8 encoded strings are only allowed in line comments and an optional UTF-8 BOM at the start of the text file is ignored.
Other characters, like trailing non comments, are not allowed in the file.
</p>
<p>
MATLAB is a registered trademark of The MathWorks, Inc.
</p>
</html>"));
  end FileUpdateTimeTable;
end Sources;
