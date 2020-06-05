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
clear all
close all
ro = 1000.0;
AbsoluteWaterSpeedVA = zeros(361,3);
ReynoldsNumber = 200000;
AbsoluteWaterSpeed = 1;
AbsoluteWaterSpeedV = AbsoluteWaterSpeed*[0 -1 0];                                            %This vector is arbitrary fixed
for i=1:1:360                                                               %This loop makes a list of vectors to simplify further calculations
    AbsoluteWaterSpeedVA(i,:) =AbsoluteWaterSpeedV;
end
i = 1;
ChordLenght = 0.05877;
Height = 1;
BladesNumber = 3;
Radius = 1;

for AngularSpeed =2:0.5:20
   
    AngularSpeedV = AngularSpeed*[0 0 1];                                       % Transforms the angular speed to a vector for further calculations
    [RelativeWaterSpeedM,PeripheralSpeedVA,RadiusVA,RelativeWaterSpeedVA,AngleOfAttackA,Theta]=vectorcalculator(Radius,AngularSpeedV,AbsoluteWaterSpeedV); %Uses the funtion made to get the values for more info use comand 'help'   
    RelativeWaterSpeedM2 = RelativeWaterSpeedM.*RelativeWaterSpeedM;
    DynamicPreasure = 0.5*ro*RelativeWaterSpeedM2;
    [Power,Moment,TotalForce,TangentialForce,NormalForce,Ct,Cn] = dynamiccalculator(ReynoldsNumber,AngleOfAttackA,RelativeWaterSpeedM2,Height,ChordLenght,Theta,Radius,AngularSpeed);
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
    CpT(i,:)=[NewTipSpeed Cp];
    Checker(i,:)=[G k];
    i=i+1;
end 
plot(CpT(:,1),CpT(:,2));
    
    
    