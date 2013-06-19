
function [CYCLES, EVEN, ES, BADPAIRS, ADJ]=DSR(filename)
%function [S_matrix, V_matrix]=readSVFile(filename)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Reading the data file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%filename = 'mat.dat';

fid = fopen(filename);

line_data = fgetl(fid);

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

[CYCLES, EVEN, ES, BADPAIRS, ADJ]=DSR3(S,transpose(V));

e1=false; e2=false;

if (sum(size(ES))<sum(size(EVEN))) 
   e1=true;
end
if (sum(size(BADPAIRS))>0)
   e2=true;
end

if and(!e1, !e2)
  fprintf(stdout(),"DSR test successful! The system satisfies condition <a title=\"IC3\" href=\"http://reaction-networks.net/wiki/CoNtRol#Injectivity_condition_3_.28IC3.29\">IC3</a>. It does not admit multiple positive nondegenerate equilibria for general kinetics.\n")

else fprintf(stdout(),"DSR test inconclusive. This test alone can not determine whether or not the system admits multiple equilibria.\n")  
end
 
