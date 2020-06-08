function [LiftCoefficient,DragCoefficient]= readingofcoefficientsFast(AngleOfAttack,Cl_interpol,Cd_interpol)

% [LiftCoefficient1,DragCoefficient1] = getCoefficientsFromTxt(TextFile, Reynolds, AngleOfAttack(:,1));
% [LiftCoefficient2,DragCoefficient2] = getCoefficientsFromTxt(TextFile, Reynolds, AngleOfAttack(:,2));
% [LiftCoefficient3,DragCoefficient3] = getCoefficientsFromTxt(TextFile, Reynolds, AngleOfAttack(:,3));

LiftCoefficient1=ppval(Cl_interpol,AngleOfAttack(:,1)');
LiftCoefficient2=ppval(Cl_interpol,AngleOfAttack(:,2)');
LiftCoefficient3=ppval(Cl_interpol,AngleOfAttack(:,3)');
DragCoefficient1=ppval(Cd_interpol,AngleOfAttack(:,1)');
DragCoefficient2=ppval(Cd_interpol,AngleOfAttack(:,2)');
DragCoefficient3=ppval(Cd_interpol,AngleOfAttack(:,3)');

LiftCoefficient = [LiftCoefficient1' LiftCoefficient2' LiftCoefficient3'];
DragCoefficient = [DragCoefficient1' DragCoefficient2' DragCoefficient3'];
