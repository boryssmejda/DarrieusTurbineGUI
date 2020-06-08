function [Cl,Cd] = getCoefficientsFromTxtFast(filename, reynoldsNum)

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


    firstfileLine = -180 + moveBy + rangeBeginning;
    finalfileLine = 180 + moveBy + rangeBeginning;

                count = 1;

    for i = firstfileLine: 1: finalfileLine
    
     
        currentFileLine = strrep(lines(i), ',', '.');
        
        currentValues = strsplit(currentFileLine);
        
        currentValueCl  = str2double(currentValues(2));
        currentValueCd  = str2double(currentValues(3));

            y_Cl(1,count)=currentValueCl;
            y_Cd(1,count)  = currentValueCd;

                    count = count+1;
    end
    x = -180:1:180;
        Cl = makima(x,y_Cl);
        Cd = makima(x,y_Cd);
         fclose('all');

end


