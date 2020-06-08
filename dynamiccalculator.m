function [Power,Moment,TotalForce,TangentialForce,NormalForce,ConstantTangential1,ConstantNormal1] = dynamiccalculator(ReynoldsNumber,ro,AngleOfAttack,LiftCoefficient,DragCoefficient,RelativeWaterSpeedM2,Height,ChordLenght,Theta,Radius,AngularSpeed)
%DynamicPressure

ConstantTangential = LiftCoefficient.*sind(AngleOfAttack)-DragCoefficient.*cosd(AngleOfAttack);
ConstantTangential1=ConstantTangential(:,1);
ConstantNormal = LiftCoefficient.*cosd(AngleOfAttack)+DragCoefficient.*sind(AngleOfAttack);
ConstantNormal1=ConstantNormal(:,1);

%NormalForce = ConstantNormal.*DynamicPressure.*Height.*ChordLenght;
%TangentialForce = ConstantTangential.*DynamicPressure.*Height.*ChordLenght;

NormalForce = (ConstantNormal.*ChordLenght.*RelativeWaterSpeedM2)./2;
TangentialForce = (ConstantTangential.*ChordLenght.*RelativeWaterSpeedM2)./2;

TotalForce = sind(Theta)*NormalForce-cosd(Theta)*TangentialForce;
Moment = ConstantTangential.*0.5.*ro.*RelativeWaterSpeedM2.*Height.*Radius.*ChordLenght;
Power = Moment.*AngularSpeed;