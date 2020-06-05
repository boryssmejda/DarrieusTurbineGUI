function [RelativeWaterSpeedM,PeripheralSpeedVA,RadiusVA,RelativeWaterSpeedVA,AngleOfAttackA,ThetaA,CheckM]= vectorcalculator(Radius,AngularSpeedV,AbsoluteWaterSpeedV)
%This finction calculates the different vectors and magnitudes needed for
%the understandig of the turbine behaviour. The parameters are the
%following:
%INPUTS:
% 
%OUTPUTS:
%   

%Predefyning matrixes to reduce computational time
    CheckM=zeros(361,3);
    RadiusVA = zeros(361,9);
    PeripheralSpeedVA= zeros(361,9);
    RelativeWaterSpeedVA = zeros(361,9);
    RelativeWaterSpeedM = zeros(361,3);
    AngleOfAttackA = zeros(361,3);
%Angle in wich it will variate the rotational angle
    step = 1;    
%All the calculations will be repeated for each of the theta values
        for Theta =0:step:360.0
            %Create a vector that represents the radius of the rotor
            RadiusV1 = Radius*[cosd(Theta) sind(Theta) 0];
            RadiusV2 = Radius*[cosd(Theta+120.0) sind(Theta+120.0) 0];
            RadiusV3 = Radius*[cosd(Theta+240.0) sind(Theta+240.0) 0];
            %Obtain the peripheral speed vectorial
            PeripheralSpeedV1 = cross(AngularSpeedV,RadiusV1);
            PeripheralSpeedV2 = cross(AngularSpeedV,RadiusV2);
            PeripheralSpeedV3 = cross(AngularSpeedV,RadiusV3);
            %Operating the vectors obtain the AirSpeed
            AirSpeedV1 = AbsoluteWaterSpeedV-PeripheralSpeedV1;
            AirSpeedV2 = AbsoluteWaterSpeedV-PeripheralSpeedV2;
            AirSpeedV3 = AbsoluteWaterSpeedV-PeripheralSpeedV3;
            Check1 = atan2(AirSpeedV1(:,2),AirSpeedV1(:,1));
            Check2 = atan2(AirSpeedV2(:,2),AirSpeedV2(:,1));
            Check3 = atan2(AirSpeedV3(:,2),AirSpeedV3(:,1));
            %Operating the vectors obtain the angle of attackk
%             AngleOfAttack1 = rad2deg(Check1 - (atan2(PeripheralSpeedV1(:,2),PeripheralSpeedV1(:,1))-pi()));
%             AngleOfAttack2 = rad2deg(Check2 - (atan2(PeripheralSpeedV2(:,2),PeripheralSpeedV2(:,1))-pi()));
%             AngleOfAttack3 = rad2deg(Check3 - (atan2(PeripheralSpeedV3(:,2),PeripheralSpeedV3(:,1))-pi()));
        AngleOfAttack1 = rad2deg(atan(sind(Theta)/((norm(AngularSpeedV)*Radius/norm(AbsoluteWaterSpeedV))+cosd(Theta))));
        AngleOfAttack2 = rad2deg(atan(sind(Theta+120.0)/((norm(AngularSpeedV)*Radius/norm(AbsoluteWaterSpeedV))+cosd(Theta+120.0))));
        AngleOfAttack3 = rad2deg(atan(sind(Theta+240.0)/((norm(AngularSpeedV)*Radius/norm(AbsoluteWaterSpeedV))+cosd(Theta+240.0))));     


            if(AngleOfAttack1>180.0)
                AngleOfAttack1=AngleOfAttack1-360.0;
            end
            if(AngleOfAttack2>180.0)
                AngleOfAttack2=AngleOfAttack2-360.0;
            end
            if(AngleOfAttack3>180.0)
                AngleOfAttack3=AngleOfAttack3-360.0;
            end
            %Obtain the module of Airspeed for further calculations
            AirSpeedM1 = norm(AirSpeedV1);
            AirSpeedM2 = norm(AirSpeedV2);
            AirSpeedM3 = norm(AirSpeedV3);
            %Create the list of results (Remember, in Matlab the first
            %term is 1 no 0 like in other programming languajes)
            PeripheralSpeedVA(Theta+1,:)=[PeripheralSpeedV1 PeripheralSpeedV2 PeripheralSpeedV3];
            RadiusVA(Theta+1,:) = [RadiusV1 RadiusV2 RadiusV3];
            RelativeWaterSpeedVA(Theta+1,:)=[AirSpeedV1 AirSpeedV2 AirSpeedV3];
            AngleOfAttackA(Theta+1,:) = [AngleOfAttack1 AngleOfAttack2 AngleOfAttack3];
            ThetaA =Theta; 
            CheckM(Theta+1,:) = [Check1 Check2 Check3];
            RelativeWaterSpeedM(Theta+1,:) =[AirSpeedM1 AirSpeedM2 AirSpeedM3];
        end