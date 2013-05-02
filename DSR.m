
function [CYCLES, EVEN, ES, BADPAIRS, ADJ]=DSR(filename)
%function [S_matrix, V_matrix]=readSVFile(filename)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Reading the data file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%filename = 'mat.dat';

fid = fopen(filename);

line_data = fgetl(fid);

disp(line_data)


line_string = deblank(sprintf(line_data, '%s'));

while (strcmp(line_string, 'S MATRIX') == 0)
	line_data = fgetl(fid);
	line_string = deblank(sprintf(line_data, '%s'));
end

line_data = fgetl(fid);

S_matrix = [];
V_matrix = [];

line_string = sprintf(line_data, '%s'); % tries to parse string   
split_data = strsplit(line_string,  " ");

while (strcmp(line_string, 'V MATRIX') == 0)      
   temp={};
   size_temp=0;
	
   for i=1:length(split_data)
		if (strcmp(split_data(i),'') == 0)
			size_temp = size_temp+1;
			temp{size_temp} = deblank(split_data(i));
		end			
	end
	S_matrix = [S_matrix; temp];
	line_data = fgetl(fid);  

    line_string = sprintf(line_data, '%s'); % tries to parse string   
    split_data = strsplit(line_string, " ");
end

line_data = fgetl(fid);

while (line_data ~= -1)   % makes sure its not eof
   line_string = sprintf(line_data, '%s'); % tries to parse string   
   split_data = strsplit(line_string, " ");

   
   temp={};
   size_temp=0;
	
   for i=1:length(split_data)
		if (strcmp(split_data(i), '') == 0)
			size_temp = size_temp+1;
			temp{size_temp} = deblank(split_data(i));
		end			
	end
	V_matrix = [V_matrix; temp];
	line_data = fgetl(fid); % reads one line of the file   
end

fclose(fid);

[m,n]=size(S_matrix);

S=zeros(m,n);
V=zeros(m,n);

for i=1:m
  for j=1:n        
    S(i,j)=str2num(S_matrix{i,j}{1,1});
    V(i,j)=str2num(V_matrix{i,j}{1,1});
  endfor
endfor


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Analyze the DSR graph
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[CYCLES, EVEN, ES, BADPAIRS, ADJ]=DSR3(S,transpose(V))


end
 
