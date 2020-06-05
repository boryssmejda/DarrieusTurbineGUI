function [Power,Moment,TotalForce,TangentialForce,NormalForce,ConstantTangential1,ConstantNormal1] = dynamiccalculator(Reynolds,AngleOfAttack,RelativeWaterSpeedM2,Height,ChordLenght,Theta,Radius,AngularSpeed)
%DynamicPressure
[LiftCoefficient1,DragCoefficient1] = getCoefficientsFromTxt('wholeRange.txt', Reynolds, AngleOfAttack(:,1));
[LiftCoefficient2,DragCoefficient2] = getCoefficientsFromTxt('wholeRange.txt', Reynolds, AngleOfAttack(:,2));
[LiftCoefficient3,DragCoefficient3] = getCoefficientsFromTxt('wholeRange.txt', Reynolds, AngleOfAttack(:,3));
LiftCoefficient = [LiftCoefficient1 LiftCoefficient2 LiftCoefficient3];
DragCoefficient = [DragCoefficient1 DragCoefficient2 DragCoefficient3];

ConstantTangential = LiftCoefficient.*sind(AngleOfAttack)-DragCoefficient.*cosd(AngleOfAttack);
ConstantTangential1=ConstantTangential(:,1);
ConstantNormal = LiftCoefficient.*cosd(AngleOfAttack)+DragCoefficient.*sind(AngleOfAttack);
ConstantNormal1=ConstantNormal(:,1);

%NormalForce = ConstantNormal.*DynamicPressure.*Height.*ChordLenght;
%TangentialForce = ConstantTangential.*DynamicPressure.*Height.*ChordLenght;

NormalForce = (ConstantNormal.*ChordLenght.*RelativeWaterSpeedM2)./2;
TangentialForce = (ConstantTangential.*ChordLenght.*RelativeWaterSpeedM2)./2;

TotalForce = sind(Theta)*NormalForce-cosd(Theta)*TangentialForce;
Moment = ConstantTangential.*500.*RelativeWaterSpeedM2.*Height.*Radius.*ChordLenght;
Power = Moment*AngularSpeed;