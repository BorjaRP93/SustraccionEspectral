function SustraccionEspectral_2(f_x,f_sest)
% SustraccionEspectral_2(f_x,f_s_est)
%
% Implementaci�n sel m�todo de Sustraccion Espectral de acuerdo al
% paper [1]
%
% Versi�n 2.0 
%
%   Entradas:
%       f_x   	Fichero conteniendo la se�al contaminada a procesar
%       f_sest	Fichero contiendo la se�al estimada
%
%	Comentarios:
%
%	Esta versi�n implementa el m�todo propuesto en [1] de forma completa
%
%	El tama�o de las tramas de procesado es de alrededor de 20 ms,
%   ajustando su longitud para que el n�mero de muestras sea una 
%   potencia de dos, con un overlap del 50%, utilizando un enventanado
%   de Hanning, de acuerdo con la propuesta realizada en el art�culo
%   original. 
%
%   Dado que la longitud de la se�al de entrada no se ajusta 
%   necesariamente a un n�mero entero de tramas, se a�aden ceros hasta
%   alcanzar la longitud necesaria para procesar toda la se�al. Una
%   vez procesada, se reajusta la longitud de la se�al obtenida para
%   que coincida con la original.
%   
%   Se supone que las primeras cinco tramas corresponden �nicamente a
%   ruido, y permiten una estimaci�n inicial del mismo.
%
%	Se utilizar� como detector de actividad vocal el propuesto en el
%   art�culo original
%
%   [1] BOLL, Steven. Suppression of acoustic noise in speech using
%   spectral subtraction. IEEE Transactions on acoustics, speech, 
%   and signal processing, 1979, vol. 27, no 2, p. 113-120.

%   Establecimiento de par�metros globales: % de overlap, duraci�n de
%   trama en ms, n�mero de tramas iniciales utilizadas para estimar el
%   ruido, atenuaci�n adicional de ruido (dB), nivel de detecci�n de
%   actividad vocal

%   Carga del fichero de audio
    [contaminada,fs]=wavread(f_x);
    
    
%  contaminada=resample(contaminada,8e3,fs);
%  fs=8e3;
 
 
%   Definici�n de par�metros: longitud de los datos, tama�o de ventana,
%   longitud del overlap entre ventanas, n�mero de bloques a procesar,
%   longitud de x extendida

    W=fix(0.02*fs); %longitud ventana en 20 ms
    SP=.5;         %factor de overlapp
    Tramas_ruido=5; %n�mero de tranmas inciales de ruido
    
    len_x=length(contaminada);
    len_20=0.02*fs;
    
%   Generaci�n de la ventana
    wnd=hanning(W,'periodic');
%   Incrementando longitud de x para que coincida con un n�mero entero
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

%   Utilizaci�n de las primeras cinco tramas para realizar una
%   estimaci�n inicial del espectro de ruido (hay que verificar que 
%   el n�mero de tramas sea superior a 5, obviamente)
if N<=5
    error('Hay menos de 5 tramas de 20ms');
end

Noise=mean(Y(:,1:Tramas_ruido).').'; %media del espectro del ruido de 
% las 5 primeras tramas
NoiseCont=5;
%   Inicializaci�n del valor m�ximo del ruido residual
Noise_max=zeros(size(Noise));
%   Procesado de los bloques siguientes
for ii=6:N
    %   Eliminaci�n de bias y rectificaci�n de media onda
     S(:,ii)=(Y(:,ii))-(Noise);
     S((find(S(:,ii)<0)),ii)=0;
     T=20*log10(mean(S(:,ii)./Noise));
    %   Si no hay actividad vocal 
    if (T <= Speech_Margin)
        %   Actualizar ruido
        NoiseCont=NoiseCont+1;
        Noise=(Noise*(NoiseCont-1)+Y(:,ii))/(NoiseCont);
        %   Actualizar el valor del ruido residual
        Noise_max=max(Noise_max,Noise);
        %   Atenuaci�n adicional de ruido
        S(:,ii)=Y(:,ii)/1000;
        
    % en caso contrario
    else
        Est=S(:,ii);
        if ii>1 && ii<N           
            for j=1:length(Est)
                if Est(j)<Noise_max(j)
                    Est(j)=min([Est(j) Y(j,ii-1)-Noise(j) Y(j,ii+1)-Noise(j)]);
                end
            end
        end
        S(:,ii)=Est;
        S((find(Est<0)),ii)=0;
    end
end    
S(:,1:5)=Y(:,1:5);

S=S.^(1/P);

S_est=S.*exp(1j*Yfase);
S_est=real(ifft(S_est,W));
%   S�ntesis mediante overlap-add
s=zeros(size(contaminada));


for jj=1:N
    comienzo=(jj-1)*W/2+1;
    s(comienzo:comienzo+W-1)=s(comienzo:comienzo+W-1)+S_est(:,jj);
    
end

%   Recorte de sest hasta la longitud original de x
s=s(1:end-ceros);

%   Almacenamiento en disco
    wavwrite(s,fs,f_sest);
