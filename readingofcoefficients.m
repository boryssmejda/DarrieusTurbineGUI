function [LiftCoefficient,DragCoefficient]= readingofcoefficients(Reynolds,AngleOfAttack,TextFile)
[LiftCoefficient1,DragCoefficient1] = getCoefficientsFromTxt(TextFile, Reynolds, AngleOfAttack(:,1));
[LiftCoefficient2,DragCoefficient2] = getCoefficientsFromTxt(TextFile, Reynolds, AngleOfAttack(:,2));
[LiftCoefficient3,DragCoefficient3] = getCoefficientsFromTxt(TextFile, Reynolds, AngleOfAttack(:,3));
fclose('all');

LiftCoefficient = [LiftCoefficient1 LiftCoefficient2 LiftCoefficient3];
DragCoefficient = [DragCoefficient1 DragCoefficient2 DragCoefficient3];
