clc
close all;
clearvars;
%-------------------------------------------------------------------------%
% Inicializacion

Ni = 687;             % Numero de puntos
dx = 0.001;           % Espacio entre dos puntos
Nx = Ni*dx;           % Punto x = L
x(1,:) = (0:Ni-1)*dx; % Vector fila con todos los puntos de la cuerda

fx = 0.2;             % Punto de aplicacion de la fuerza
fi = fx/dx+1;         % Indice del punto de aplicacion de la fuerza
h = -0.01;            % Desplazamiento inicial causado la fuerza

Tx = 60;              % Tension de la cuerda
p = 0.00525;          % Densidad lineal de la cuerda
c = sqrt(Tx/p);       % Velocidad de la onda

T = 10001;            % Numero de intervalos de tiempo
dt = dx/c;            % Tiempo entre intervalos
t(:,1)= (0:T-1)*dt;   % Vector columna con todos los instantes de tiempo

R = c*(dt/dx);        % Numero de Courant R<=1
R2 = R*R;
U = zeros(T,Ni);      % U(x,t) = U(espacio,tiempo)
                      % Matriz de ceros de dimensiones T x Nx
                      % Cada fila es un instante de tiempo
                      % Cada columna es un punto de la cuerda
%-------------------------------------------------------------------------%

% Condiciones iniciales

%Forma de la cuerda
ctr1 = polyfit([0,fx],[0,h],1);
ctr2 = polyfit([fx,Nx-dx],[h,0],1);

% Instante 1
U(1,1:fi) = ctr1(1)*x(1,1:fi) + ctr1(2);
U(1,fi+1:Ni-1) = ctr2(1)*x(1,fi+1:Ni-1) + ctr2(2);

% Instante 2
U(2,1:fi) = ctr1(1)*x(1,1:fi) + ctr1(2);
U(2,fi+1:Ni-1) = ctr2(1)*x(1,fi+1:Ni-1) + ctr2(2);
%-------------------------------------------------------------------------%

% Condiciones de contorno

% Cuerda fija en los extremos
U(1:T,1) = 0;       % extremo izquierdo
U(1:T,Ni) = 0;      % extremo derecho
%-------------------------------------------------------------------------%

% Diferencias finitas
for j = 2:T         % a partir del instante 3 y hasta T
    for i = 2:Ni-1  % sin incluir extremos de la cuerda
        U1 = 2*U(j,i)-U(j-1,i);
        U2 = U(j,i+1)-2*U(j,i)+U(j,i-1);
        U(j+1,i) = U1 + R2*U2;    
    end
end
%-------------------------------------------------------------------------%

% Movie

for j = 1:4:T              
  plot(x,U(j,:),'linewidth',2);
  grid on;
  axis([min(x) max(x) -0.02 0.02]);
  xlabel('x [m]','fontSize',14);
  ylabel('u [m]','fontSize',14);              
  titlestring = ['n = ',num2str(j), ' t = ',num2str(t(j)), 's'];
  title(titlestring ,'fontsize',14);                            
  h=gca; 
  get(h,'FontSize') 
  set(h,'FontSize',14);
  fh = figure(5);
  set(fh, 'color', 'white'); 
  F=getframe;
            
end