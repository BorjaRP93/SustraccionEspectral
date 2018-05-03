function [y,fs,nbits] = wavread(filename,arg2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% comprobamos si el filename acaba en .wav y si no se lo incluimos %
    if length(filename)>4
         if strcmp(filename(end-3:end),'.wav')==0
            filename=strcat(filename,'.wav');
         end
    else
            filename=strcat(filename,'.wav');
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    
    if nargin == 1
        [y,fs] = audioread(filename);

    elseif nargin > 1
                if ischar(arg2)
                       if strcmp(arg2,'size')
                        [x,fs] = audioread(filename);
                        y=size(x);
                       else
                        disp('ERROR: Introduzca una cadena correcta');
                        y=NaN;
                        fs=NaN;
                        
                       end
                else
                    [y,fs] = audioread(filename,arg2);
                end
     end
       
     info=audioinfo(filename);
     nbits = info.BitsPerSample;
end