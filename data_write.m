datafilename = strcat('deck_D','.dat'); % name of data file to write to

datafilepointer = fopen(datafilename,'wt');

for i=1:40
    fprintf(datafilepointer,'%g %g %g\n',...
    deck_D{i}(1),...
    deck_D{i}(2),...
    deck_D{i}(3))
end