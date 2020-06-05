function [Cl,Cd] = getCoefficientsFromTxt(filename, reynoldsNum, anglesOfAttack)

    text = fileread(filename);

    fileID = fopen(filename);

    %% count lines in the file
    nrLines = 0;
    while true
        tline = fgetl(fileID);
        if(tline == -1)
            frewind(fileID);
            break;
        end
        nrLines = nrLines + 1;
    end

%% fill in the vector with file's lines
    lines = strings(nrLines ,1);
    for i = 1: 1: nrLines
        tline = fgetl(fileID);
        if(tline == -1)
            fclose(fileID);
            break;
        end
        lines(i) = tline;
    end

%% Find Data with proper Reynold's number

    pattern = 'Re = ';
    patternLength = length(pattern);
    
    rangeBeginning = 0;
    for i = 1: 1: nrLines
    
        result = strfind(lines(i), pattern);
    
        if(length(result) == 0)
            continue;
        end
    
        semicolon = strfind(lines(i), '0;');
    
        beginning = patternLength + result;
        ending = semicolon(2);
        currentLine = char(lines(i));
        size(currentLine);
    
    
        stringReynold = currentLine(beginning:ending);
        finalReynoldNum = str2double(stringReynold);
        
        if(finalReynoldNum == reynoldsNum)
        
            % 4 lines after Reynold data begins
            rangeBeginning = i + 4;
            break;
        end
    end

%% Find begin and end of the range of data

    counter = rangeBeginning;
    rangeEnding = rangeBeginning;
    while true
        
        currentLine = lines(counter);
        if(length(char(currentLine)) == 0)
            rangeEnding = counter - 1;
            break;
        end
        counter = counter + 1;
    end
    
    % borders of the interesting range of values
    rangeBeginning;
    rangeEnding;
    nrValues = rangeEnding - rangeBeginning;
    moveBy = nrValues/2;

%% Iterate over the range of values between beginning and ending

    Cl = zeros(length(anglesOfAttack),1);
    Cd = zeros(length(anglesOfAttack),1);
 %   Cm = zeros(length(anglesOfAttack),1);
    firstfileLine = -180 + moveBy + rangeBeginning;
    finalfileLine = 180 + moveBy + rangeBeginning;
    %diff = finalfileLine-firstfileLine;
                count = 1;

    for i = firstfileLine: 1: finalfileLine
    
%        currentAoA = anglesOfAttack(i,1);
%        fileLine = floor(currentAoA) + moveBy + rangeBeginning;
        
        currentFileLine = strrep(lines(i), ',', '.');
%         nextFileLine    = strrep(lines(fileLine + 1), ',', '.');
        
        currentValues = strsplit(currentFileLine);
%         nextValues    = strsplit(nextFileLine);
        
        currentValueAoA = str2double(currentValues(1));
        currentValueCl  = str2double(currentValues(2));
        currentValueCd  = str2double(currentValues(3));
%       currentValueCm  = str2double(currentValues(4));
        
%         nextValueAoA    = str2double(nextValues(1));
%         nextValueCl     = str2double(nextValues(2));
%         nextValueCd     = str2double(nextValues(3));
%         nextValueCm     = str2double(nextValues(4));
%         
%         x     = [currentValueAoA; nextValueAoA];

            y_Cl(1,count)=currentValueCl;
            y_Cd(1,count)  = currentValueCd;
           % x(1,i)     = currentValueAoA;
%         y_Cl  = [currentValueCl;  nextValueCl];
%         Cl(i) = interp1(x, y_Cl,  currentAoA);
%     
%         y_Cd  = [currentValueCd;  nextValueCd];
%         Cd(i) = interp1(x, y_Cd,  currentAoA);
%     
%         y_Cm  = [currentValueCm;  nextValueCm];
%         Cm(i) = interp1(x, y_Cm,  currentAoA);
                    count = count+1;
    end
    x = -180:1:180;
        anglesOfAttack=anglesOfAttack';
        Cl = makima(x,y_Cl,anglesOfAttack)';
        Cd = makima(x,y_Cd,anglesOfAttack)';
        

end


