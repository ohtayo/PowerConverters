model ChopperStepDown_LCR "Step down chopper with R-L load"
  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.Resistance R=0.33 "Resistance";
  parameter Modelica.SIunits.Inductance L=0.5e-6 "Inductance";
  parameter Modelica.SIunits.Capacitance C=235e-6 "Capacitance";
  parameter Modelica.SIunits.Voltage Vs=9.6 "Source voltage";
  parameter Modelica.SIunits.Frequency f=450e3 "Switching frequency";
  parameter Real dutyCycle=0.25 "Duty cycle";
  parameter Modelica.SIunits.Voltage V0=Vs*dutyCycle "No-load voltage";
  parameter Modelica.SIunits.Voltage Vt=3.3 "Target output voltage";
  
  Modelica.Electrical.Analog.Basic.Resistor resistor(R=R) annotation (
      Placement(visible = true, transformation(origin = {54, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Electrical.Analog.Basic.Inductor inductor(L=L, i(fixed=true, start=0)) annotation (Placement(visible = true, transformation(origin = {-4, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.PowerConverters.DCDC.ChopperStepDown chopperStepDown(useHeatPort = false) annotation(
    Placement(visible = true, transformation(extent = {{-52, 14}, {-32, 34}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(visible = true, transformation(extent = {{-94, -22}, {-74, -2}}, rotation = 0)));
  Modelica.Electrical.Analog.Sources.ConstantVoltage constantVoltage(V = Vs) annotation(
    Placement(visible = true, transformation(origin = {-84, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Electrical.Analog.Sensors.CurrentSensor currentSensor annotation(
    Placement(visible = true, transformation(extent = {{12, 8}, {-8, 28}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Capacitor capacitor(C = C)  annotation(
    Placement(visible = true, transformation(origin = {28, 28}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Sensors.VoltageSensor voltageSensor annotation(
    Placement(visible = true, transformation(origin = {80, 28}, extent = {{-10, 10}, {10, -10}}, rotation = 270)));
  Modelica.Electrical.PowerConverters.DCDC.Control.SignalPWM signalPWM(f = f, useConstantDutyCycle = false) annotation(
    Placement(visible = true, transformation(origin = {-42, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimPID limPID(Td = 0, Ti = 0.00002, k = 0.01, yMax = 1, yMin = 0)  annotation(
    Placement(visible = true, transformation(origin = {8, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant const(k = Vt)  annotation(
    Placement(visible = true, transformation(origin = {50, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
equation
  connect(ground.p, constantVoltage.n) annotation(
    Line(points = {{-84, -2}, {-84, 14}}, color = {0, 0, 255}));
  connect(chopperStepDown.dc_n1, constantVoltage.n) annotation(
    Line(points = {{-52, 18}, {-68, 18}, {-68, 14}, {-84, 14}}, color = {0, 0, 255}));
  connect(chopperStepDown.dc_p1, constantVoltage.p) annotation(
    Line(points = {{-52, 30}, {-68, 30}, {-68, 34}, {-84, 34}}, color = {0, 0, 255}));
  connect(currentSensor.n, chopperStepDown.dc_n2) annotation(
    Line(points = {{-8, 18}, {-32, 18}}, color = {0, 0, 255}));
  connect(chopperStepDown.dc_p2, inductor.p) annotation(
    Line(points = {{-32, 30}, {-14, 30}, {-14, 38}}, color = {0, 0, 255}));
  connect(capacitor.p, inductor.n) annotation(
    Line(points = {{28, 38}, {6, 38}}, color = {0, 0, 255}));
  connect(capacitor.n, currentSensor.p) annotation(
    Line(points = {{28, 18}, {12, 18}}, color = {0, 0, 255}));
  connect(resistor.n, capacitor.n) annotation(
    Line(points = {{54, 18}, {28, 18}}, color = {0, 0, 255}));
  connect(resistor.p, capacitor.p) annotation(
    Line(points = {{54, 38}, {28, 38}}, color = {0, 0, 255}));
  connect(voltageSensor.n, resistor.n) annotation(
    Line(points = {{80, 18}, {54, 18}}, color = {0, 0, 255}));
  connect(voltageSensor.p, resistor.p) annotation(
    Line(points = {{80, 38}, {54, 38}}, color = {0, 0, 255}));
  connect(signalPWM.fire, chopperStepDown.fire_p) annotation(
    Line(points = {{-48, -3}, {-48, 11}}, color = {255, 0, 255}));
  connect(voltageSensor.v, limPID.u_m) annotation(
    Line(points = {{92, 28}, {92, -2}, {8, -2}, {8, -40}}, color = {0, 0, 127}));
  connect(limPID.y, signalPWM.dutyCycle) annotation(
    Line(points = {{-3, -52}, {-54, -52}, {-54, -14}}, color = {0, 0, 127}));
  connect(limPID.u_s, const.y) annotation(
    Line(points = {{20, -52}, {40, -52}}, color = {0, 0, 127}));
  annotation(
    experiment(StartTime = 0, StopTime = 0.002, Tolerance = 1e-06, Interval = 4e-06),
    Documentation(info = "<html>
<p>This example demonstrates the switching on of an R-L load operated by a step down chopper.
DC output voltage is equal to <code>dutyCycle</code> times the input voltage.
Plot current <code>currentSensor.i</code>, averaged current <code>meanCurrent.y</code>, total voltage <code>voltageSensor.v</code> and voltage <code>meanVoltage.v</code>. The waveform the average current is determined by the time constant <code>L/R</code> of the load.</p>
</html>"),
    uses(Modelica(version = "3.2.3")));
end ChopperStepDown_LCR;
