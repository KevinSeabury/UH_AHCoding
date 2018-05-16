function [] = VChanger()
Location = uigetdir(matlabroot,'MATLAB Root Directory')
% Testing on the TestingThings.m file
FullPath = sprintf('%s\\*.m',Location)
files = dir(FullPath)
for pp = 1:length(files)
    FILENAME = sprintf('%s\\%s',Location,files(pp).name);
    
    A = fileread(FILENAME);
    % Certain things next to an equal sign indicate a variable assignment is
    % not taking place, if this script sees an =,<,>,~, the program will not
    % consider this as a location where a variable assignment is taking place.
    B = regexp(A,'=');
    for aa = 1:length(B)
        if A(B(aa) - 1) == '>' | A(B(aa) - 1) == '<' | A(B(aa) - 1) == '=' | A(B(aa) - 1) == '~'
            B(aa) = 0;
        end
        if A(B(aa) + 1) == '>' | A(B(aa) + 1) == '<' | A(B(aa) + 1) == '=' | A(B(aa) + 1) == '~'
            B(aa) = 0;
        end
    end
    B = B(B>0);
    % char(10) is the end of line characters, char(32) are space characters,
    % by finding end of line characters and space characters we can find all
    % variable assignments whether they at the start of a line or in the middle
    % of a line.  This probably won't work for global variable assignments but
    % oh well.
    EOL = char(10);
    Space = char(32);
    EndOfLines = regexp(A,EOL);
    Spaces = regexp(A,Space);
    C = [EndOfLines,Spaces];
    C = sort(C);
    % Now to find the indexes of variable names so that they may be replaced
    for ii = 1:length(B)
        PC =  C(C<B(ii));
        EP(ii) = B(ii) - 1;
        SP(ii) = PC(end) + 1;
        VariableNames{ii} = A(SP(ii):EP(ii));
        SpaceChecker = VariableNames{ii};
        PC =  EndOfLines(EndOfLines<B(ii));
        if isempty(PC) == 1
            %             This fixes the special case where students start writing the
            %             code immediately without a header or line before.
            PC = 0;
        end
        EP(ii) = B(ii) - 1;
        SP(ii) = PC(end) + 1;
        VariableNames{ii} = A(SP(ii):EP(ii));
        SpaceChecker2 = VariableNames{ii};
        if sum(SpaceChecker == '%') ~= 0
            VariableNames{ii} = '0';
        elseif sum(SpaceChecker2 == '%') ~= 0
            VariableNames{ii} = '0';
        end
        if length(SpaceChecker) == sum(SpaceChecker == ' ')
            PC =  EndOfLines(EndOfLines<B(ii));
            if isempty(PC) == 1
                %             This fixes the special case where students start writing the
                %             code immediately without a header or line before.
                PC = 0;
            end
            EP(ii) = B(ii) - 1;
            SP(ii) = PC(end) + 1;
            VariableNames{ii} = A(SP(ii):EP(ii));
            SpaceChecker = VariableNames{ii};
        end
        if sum(SpaceChecker == '%') ~= 0
            VariableNames{ii} = '0';
        end
    end
    % Now it is time to properly sort the Variable Names and to remove
    % potential duplicates.
    VariableNames = unique(VariableNames);
    for bb = 1:length(VariableNames)
        Q = 1;
        TL = length(VariableNames);
        CurrentCell = VariableNames{bb};
        row = find(CurrentCell=='[' | CurrentCell==']' | CurrentCell==',' | CurrentCell==']');
        col = find(CurrentCell=='(' | CurrentCell=='{');
        if length(col) > 0
            VariableNames{bb} = VariableNames{bb}(1:col-1);
        end
        for cc = 1:length(row)-1
            if length(row) == 0
                break
            else
                VariableNames{bb} = '0';
            end
            VariableNames{TL+Q} = CurrentCell(row(cc)+1:row(cc+1)-1);
            Q = Q + 1;
        end
    end
    % I am pretty sure there is a function to find things inside cell arrays
    % but I shall just make my own.  I need to get rid of the cells that still
    % have '' in them from the last step.
    Indexs = [];
    for cc = 1:length(VariableNames)
        CurrentCell = VariableNames{cc};
        row = find(CurrentCell==0);
        if length(row) > 0
        else
            Indexs = [Indexs,cc];
        end
    end
    VariableNames = VariableNames(Indexs);
    VariableNames = strtrim(VariableNames);
    VariableNames = unique(VariableNames);
    % Now to replace all variable names with the same identifier to make
    % changing variable names not effect similarity detection.
    Directory = cd;
    NewDirectory = sprintf('%s\\FIXEDMFILES',Directory);
    for kk = 1:length(VariableNames)
        VariableNameInput = sprintf('\\<%s\\>',VariableNames{kk});
        find_and_replace(FILENAME, VariableNameInput,'$')
    end
end
% Initial Testing shows that it sucessfully finds all varible names in
% m-files.
%
% Directory = cd;
% NewDirectory = sprintf('%s\\FIXEDMFILES',Directory);



end

