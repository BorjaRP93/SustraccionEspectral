function wavwrite(y,Fs,N,filename)
%
%   wavwrite(y,Fs,N,filename)
%
%   Escribe un fichero de audio
%   Esta función permite compatibilizar las nuevas versiones de MatLab con
%   el software generado para versiones anteriores a la 2012b
%
%   Entradas:
%
%       y           Datos de audio a escribir
%       Fs          Frecuencia de muestreo
%       N           Número de bits por muestra
%       filename    Nombre del fichero a escribir
%
%   Comentarios:
%
%       wavwrite writes data to 8-, 16-, 24-, and 32-bit .wav files.
%
%       wavwrite(y,'filename') writes the data stored in the variable y
%       to a WAVE file called filename. The data has a sample rate of
%       8000 Hz and is assumed to be 16-bit. Each column of the data
%       represents a separate channel. Therefore, stereo data should be
%       specified as a matrix with two columns. Amplitude values outside
%       the range [-1,+1] are clipped prior to writing.
%
%       wavwrite(y,Fs,'filename') writes the data stored in the variable
%       y to a WAVE file called filename. The data has a sample rate of
%       Fs Hz and is assumed to be 16-bit. Amplitude values outside the
%       range [-1,+1] are clipped prior to writing.
%
%       wavwrite(y,Fs,N,'filename') writes the data stored in the
%       variable y to a WAVE file called filename. The data has a sample
%       rate of Fs Hz and is N-bit, where N is 8, 16, 24, or 32. 
%       For N < 32, amplitude values outside the range [-1,+1]
%       are clipped.

%       Procesamos según el número de argumentos

%       Verificamos si el nombre del fichero finaliza en .wav, en caso
%       contrario añadimos el punto y la extensión. Hay que tener en cuenta
%       que el fichero podría tener menos de cuatro caracteres

%       Escribimos los datos en disco

  
    
    switch nargin
        case 2
            filename=Fs;
            Fs=8000;
            N=16;
 
        case 3
            filename=N;
            N=16;    
    end
    
      if length(filename)>4
         if strcmp(filename(end-3:end),'.wav')==0
            filename=strcat(filename,'.wav');
         end
     else
            filename=strcat(filename,'.wav');
     end
    
    audiowrite(filename,y,Fs,'BitsPerSample',N);
end
    
    
    
    
    

    