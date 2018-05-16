function overlap = textcompare(txt0, txt1, chunksize)
% This code was written by Mathias Benedek's in mfilecompare
% Which can be found at https://www.mathworks.com/matlabcentral/fileexchange/29781-mfilecompare?s_tid=gn_loc_drop


txt0(isspace(txt0)) = ''; %trim filetext
txt1(isspace(txt1)) = ''; %trim filetext

nchunks = floor(length(txt0)/chunksize);
hit = 0;

for ii = 1:nchunks

    chunk = txt0(((ii-1)*chunksize+1):(ii*chunksize));
    if any(strfind(txt1, chunk))
        hit = hit+1;
    end

end

overlap = hit/nchunks;
