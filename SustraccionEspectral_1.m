function SustraccionEspectral_1(f_x,f_sest)
% SustraccionEspectral_1(f_x,f_s_est)
%
% Implementación de la versión más elemental del método de Sustraccion
% Espectral de acuerdo al paper [1]
%
% Versión 1.0 
%
%   Entradas:
%       f_x   	Fichero conteniendo la señal contaminada a procesar
%       f_sest	Fichero contiendo la señal estimada
%
%	Comentarios:
%
%	Esta versión implementa el método básico propuesto en [1] sin
%   incorporar técnicas adicionales para silenciar posible ruido
%   musical o silenciar el ruido durante los períodos de ausencia
%   de actividad vocal.
%
%	El tamaño de las tramas de procesado es de alrededor de 20 ms,
%   ajustando su longitud para que el número de muestras sea una 
%   potencia de dos, con un overlap del 50%, utilizando un enventanado
%   de Hanning, de acuerdo con la propuesta realizada en el artículo
%   original. 
%
%   Dado que la longitud de la señal de entrada no se ajusta 
%   necesariamente a un número entero de tramas, se añaden ceros hasta
%   alcanzar la longitud necesaria para procesar toda la señal. Una
%   vez procesada, se reajusta la longitud de la señal obtenida para
%   que coincida con la original.
%   
%   Se supone que las primeras cinco tramas corresponden únicamente a
%   ruido, y permiten una estimación inicial del mismo.
%
%	Se utilizará como detector de actividad vocal el propuesto en el
%   artículo original
%
%   [1] BOLL, Steven. Suppression of acoustic noise in speech using spectral
%   subtraction. IEEE Transactions on acoustics, speech, and signal 
%   processing, 1979, vol. 27, no 2, p. 113-120.

%   Carga del fichero de audio
    [contaminada,fs]=wavread(f_x);
    
%  contaminada=resample(contaminada,8e3,fs);
%  fs=8e3;
 
%   Definición de parámetros: longitud de los datos, tamaño de ventana,
%   longitud del overlap entre ventanas, número de bloques a procesar,
%   longitud de x extendida
    W=fix(0.02*fs); %longitud ventana en 20 ms
    SP=.5;         %factor de overlapp
    Tramas_ruido=5; %número de tranmas inciales de ruido
    
    len_x=length(contaminada);
    len_20=0.02*fs;
    
%   Generación de la ventana
    wnd=hanning(W,'periodic');
%   Incrementando longitud de x para que coincida con un número entero
%   de bloques

    ceros=len_20*(floor(len_x/len_20)+1)-len_x;
    len_x=len_x+ceros;
    contaminada=[contaminada;zeros(ceros,1)];
    
%   Enventanado, FFT y promediado de tres tramas
P=1;
Speech_Margin=-12;

muestras=fix(W.*SP);
N=fix((len_x-W)/muestras +1); %numero de tramas/segmentos

Index=(repmat(1:W,N,1)+repmat((0:(N-1))'*muestras,1,W))';
hw=repmat(wnd,1,N);
Seg=contaminada(Index).*hw;
Y_orig=fft(Seg,W,1);

% Y(:,1)=Y_orig(:,1);
% for i=2:(N-1)
%     Y(:,i)=(Y_orig(:,i-1)+Y_orig(:,i)+Y_orig(:,i+1))/3;
% end
% Y(:,N)=Y_orig(:,N);

Yfase=angle(Y_orig);
Ymag=abs(Y_orig).^P;

Y(:,1)=Ymag(:,1);
for i=2:(N-1)
    Y(:,i)=(Ymag(:,i-1)+Ymag(:,i)+Ymag(:,i+1))/3;
end
Y(:,N)=Ymag(:,N);


S=zeros(size(Y));

%   Utilización de las primeras cinco tramas para realizar una
%   estimación inicial del espectro de ruido (hay que verificar que 
%   el número de tramas sea superior a 5, obviamente)
if N<=5
    error('Hay menos de 5 tramas de 20ms');
end

Noise=mean(Y(:,1:Tramas_ruido).').'; %media del espectro del ruido de 
% las 5 primeras tramas
NoiseCont=5;


%   Procesado de los bloques siguientes
for ii=6:N
    
    %   Eliminación de bias y rectificación de media onda
    S(:,ii)=(Y(:,ii))-(Noise);
    S((find(S(:,ii)<0)),ii)=0;
    
    T=20*log10(mean(S(:,ii)./Noise));
    
    %   Si no hay actividad vocal actualizar ruido
    if (T <= Speech_Margin)
        NoiseCont=NoiseCont+1;
        Noise=(Noise*(NoiseCont-1)+Y(:,ii))/(NoiseCont);
    end
end
S(:,1:5)=Y(:,1:5);

S=S.^(1/P);

S_est=S.*exp(1j*Yfase);
S_est=real(ifft(S_est,W));
%   Síntesis mediante overlap-add
s=zeros(size(contaminada));


for jj=1:N
    comienzo=(jj-1)*W/2+1;
    s(comienzo:comienzo+W-1)=s(comienzo:comienzo+W-1)+S_est(:,jj);
    
end

%   Recorte de sest hasta la longitud original de x
s=s(1:end-ceros);

%   Almacenamiento en disco
    wavwrite(s,fs,f_sest);
 

end

