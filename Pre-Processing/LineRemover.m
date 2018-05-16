% The following function was created by Jan Simon in Feb 2012
% Documentation can be found here:
% https://www.mathworks.com/matlabcentral/answers/30336-remove-space-line-from-a-text-file
function [] = LineRemover()
Location = uigetdir(matlabroot,'MATLAB Root Directory')
% Testing on the TestingThings.m file
FullPath = sprintf('%s\\*.m',Location);
files = dir(FullPath);
for pp = 1:length(files)
    FileName = sprintf('%s\\%s',Location,files(pp).name);
fid = fopen(FileName, 'r');
if fid < 0, error('Cannot open file: %s', FileName); end
Data = textscan(fid, '%s', 'delimiter', '\n', 'whitespace', '');
fclose(fid);
% Remove empty lines:
C    = deblank(Data{1});   % [EDITED]: deblank added
C(cellfun('isempty', C)) = [];
% Write the cell string:
fid = fopen(FileName, 'w');
if fid < 0, error('Cannot open file: %s', FileName); end
fprintf(fid, '%s\n', C{:});
fclose(fid);
end
end