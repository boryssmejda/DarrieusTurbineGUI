% CyKlone Tidal EPS 2020
%       Salas Mateo, David
%       Smejda, Borys
%       O'Flynn,Peter
%  The aim of the programme is to validate the models design
% and property of CyKlone Tydal as part of the interdisciplinary project
% called European Project Semester. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Instructions for designers:
%
% - Names for variables and parameters shall be significant, full words
% independently of their lenght
%
% -The name of the parameters shall be written with the first letter in
% uppercase
%
% -The name of the variables shall be in lowercase
%
% -Each time a loop or boolean condition is defined it shall be necessary
% to introduce a shift
%
% - Functions shall not be longer that 15 lines, otherwise further fuctions
% shall be defined
%
% - All the modifications of the code shall be marked with a commentary
% like these, marking author and date(day, month, year): David_24042020 
%
% - All the functions, loops and conditionants shall be explained in such
% way that any of the participants can understand its finallity and
% modification
%
% - Remember to add ";" at the end of each line to avoid the command window
% outputs that could delay the programme response
%
% -Have fun
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Now on, in the code V means vector, VA vector acumulation and M modulus
close all
clear all

ChordLenght = 0.05;
CyKloneFactor1 = 1.5;
CyKloneFactor2 = 0.05;
TextFile = 'wholeRange.txt';
ReynoldsNumber = 200000;
ro = 1000.0;

AbsoluteWaterSpeedVA = zeros(361,3);
AbsoluteWaterSpeed = 1;

i = 1;
Height = 1;
BladesNumber = 3;
Radius = 1;

n = 1/CyKloneFactor2;
row =1;
column=2;
s = 0;
[Cl_interpol,Cd_interpol]=getCoefficientsFromTxtFast(TextFile, ReynoldsNumber);

for AbsoluteWaterSpeed = 1:1:4
    AbsoluteWaterSpeedV = AbsoluteWaterSpeed*[0 -1 0];
    for i=1:1:360                                                               
        AbsoluteWaterSpeedVA(i,:) =AbsoluteWaterSpeedV;
    end
    for AngularSpeed =1.5:0.5:32
   
        AngularSpeedV = AngularSpeed*[0 0 1];                                       % Transforms the angular speed to a vector for further calculations
        [RelativeWaterSpeedM,PeripheralSpeedVA,RadiusVA,RelativeWaterSpeedVA,AngleOfAttackA,Theta]=vectorcalculator(Radius,AngularSpeedV,AbsoluteWaterSpeedV); %Uses the funtion made to get the values for more info use comand 'help'   
        RelativeWaterSpeedM2 = RelativeWaterSpeedM.*RelativeWaterSpeedM;
        DynamicPreasure = 0.5*ro*RelativeWaterSpeedM2;
        [LiftCoefficient,DragCoefficient]= readingofcoefficientsFast(AngleOfAttackA,Cl_interpol,Cd_interpol);

        [Power,Moment,TotalForce,TangentialForce,NormalForce,Ct,Cn] = dynamiccalculator(ReynoldsNumber,ro,AngleOfAttackA,LiftCoefficient,DragCoefficient,RelativeWaterSpeedM2,Height,ChordLenght,Theta,Radius,AngularSpeed);
        
        Theta = 0:1:360;
        Theta = deg2rad(Theta);
    
        T =(AngularSpeed*Radius/AbsoluteWaterSpeed);
        P = ((cos(Theta)+T).^2 + sin(Theta).^2);
        Q = (Cn'.*sin(Theta)-Ct'.*cos(Theta));
        J =(P.*Q);
        G = (BladesNumber*ChordLenght)/(16*180*Radius)*trapz(J);
    
        k = (1-G)/(1+G);
        TotalPower = Power(:,1)+Power(:,2)+Power(:,3);
        TotalPowerM = (trapz(TotalPower))*2*pi/360.0;

        TotalRelativeWaterSpeedM = (trapz(RelativeWaterSpeedM(:,1)))*2*pi/360.0;  
        PowerExp = 0.5*ro*Radius*Height*2*(2*AbsoluteWaterSpeed/(1+k))^3;    
        Cp = (BladesNumber*ChordLenght)/(32*180*Radius)*trapz(Ct'.*((P*AngularSpeed*Radius/AbsoluteWaterSpeed)*(1+k)^3));
        NewTipSpeed = AngularSpeed*Radius/AbsoluteWaterSpeed*((1+k)/2);
        Vupstream(row,column+s)=2*AbsoluteWaterSpeed/(1+k);
        Vupstream(row,column+s-1)=k;
        if column==2
            PinW(row,1)=AngularSpeed;
        end
        
        PinW(row,column)=0.5*ro*2*Radius*Height*2*AbsoluteWaterSpeed/(1+k)*Cp;
        row=row+1;
    end 
    column=column+1;
    s=s+1;
    row=1;
end
plot(PinW(:,1),PinW(:,2:column-1));