
quality = @(x1,x2) -20.*exp(-0.2*sqrt(1/2*(x1.^2+x2.^2)))-exp(1/2*(cos(x1)+cos(x2)))+ 20 + exp(1); %Função fornecida 

%Estabelecimento dos limites e design do gráfico%%%
x1 = linspace(-32.768,32.768,100);                %
x2 = linspace(-32.768,32.768,100);                %
[X1,X2] =  meshgrid(x1,x2);                       %
Fx = quality(X1,X2);                              %
contour(X1,X2,Fx,20);                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hold on %Retém o gráfico atual para que novos plots sejam realizados no mesmo gráfico do inicial

x = (rand(5,2)-0.5)*2*32.768; %Matriz de coordenadas aleatórias

fx = quality(x(:,1), x(:,2)); %Quality inicial de cada partícula

plot(x(1,1), x(1,2), 'rx') %Colocar as 5 particulas inicializadas aleatoriamente num gráfico
plot(x(2,1), x(2,2), 'bx')
plot(x(3,1), x(3,2), 'gx')
plot(x(4,1), x(4,2), 'kx')
plot(x(5,1), x(5,2), 'cx')

xlabel('Iterações'); %Eixo dos x e dos y assim como o título do gráfico são definidos aqui
ylabel('fx');
title('Particle Swarm Optimization');

b = x; %Inicialização da matriz de coordenadas com os personal best de cada partícula
fb = fx; %Inicialização da matriz das qualidades personal best de cada partícula

[fg, i] = min(fb); %Inicialização da melhor quality global, isto é, o min encontra o valor mínimo da matriz 
                   %com os melhores fx pessoais de cada partícula, o melhor é atribuído ao valor fg
g = b(i,:); %Inicialização das coordenadas global best

v = (rand(5,2)-0.5)*2*1; %Velocidade inicial de cada particula gerada aleatoriamente entre 0 e 1

n = 1; %Inicializador do loop while
w = 0.7; %Fator de inércia

bestred(n) = 0;     %Inicialização das variáveis para armazenar os personal e globalbests de 
bestblue(n) = 0;    %cada partícula para futura referência
bestgreen(n) = 0;
bestblack(n) = 0;
bestcyan(n) = 0;
globalbest(n) = 0;

while n <= 1000 %Inicialização do ciclo while, calculado para que w seja 0.4 no final do ciclo
    
    phic = (rand(5,2)-0.5)*2*1; %Inicialização do phi cognitivo, erro cognitivo, utilizado na equação de 
                                %evolução de velocidade da partícula
    phis = (rand(5,2)-0.5)*2*1; %Inicialização do phi sociial, erro social, utilizado na equação de 
                                %evolução de velocidade da partícula
   
    w = w - 0.0003; %Evolução do fator de inércia ao longo do ciclo
    
    v = w * v + 0.2 * phic.*(b - x) + 0.2 * phis.*(g - x); %Equação de determinação de velocidade das partículas
                                                       %ao longo do ciclo,onde a velocidade aumenta com cada
    %Nota: foram considerados os valores 1.5 para      %loop onde w representa o fator de inércia, v a
    %      os valores de c1 e c2 porque, devido ao     %velocidade anterior, 1.5 é o c1 ou seja, a
    %      baixo número de iterações, com o valor      %componente de peso para o fator de erro cognitivo,
    %      2 iriam raramente todas as partículas       %phic é o erro cognitivo, (b-x) significa o valor
    %      converger para o mesmo valor                %das coordenadas melhores de cada partícula menos o
                                                       %valor gerado aleatoriamente, o segundo 1.5
                                                       %representa o c2, ou seja um peso para o fator social, 
                                                       %phis e (g-x) são as coordenadas melhores
                                                       %globais menos as coordenadas geradas aleatoriamente 
                                                       
    x = x + v; %Equação de atualização das coordenadas de cada partícula, onde x representa a matriz das 
               %coordenadas de cada uma das partículas e v a velocidade determinada na equação anterior
               
%Estas duas equações representam o coração do PSO, isto é, a partir destas duas equações é que o PSO funciona corretamente 
               
    x = max(min(x,32.768),-32.768); %Estabelecimento de um limite no cálculo das novas coordenadas para que estas não 
                                    %ultrapassem os limites do gráfico e não saiam do domínio deste
    
    fx = quality(x(:,1), x(:,2)); %Determinação do novo fx de cada partícula, ou seja, da qualidade nova de cada partícula
    
    for i = 1:1:5 %Ciclo for para determinar se o valor atual verifica um valor menor do que o previamente estipulado
    if fx(i) < fb(i) %Caso isto seja verdade:
        fb(i) = fx(i); %O valor anterior no local (i, 1) da matriz será substituído pela nova coordenada
        b(i,1) = x(i,1); %A coordenada anterior no local (i, i) da matriz será substituída pela nova melhor coordenada
        b(i,2) = x(i,2);
    end %Fim do ciclo if
    end %Fim do ciclo for
    
    [fg, i] = min(fb); %Determinação do melhor valor (quality, fx) global
    g = b(i,:); %Determinação da melhor coordenada global
    
    plot(b(1,1), b(1,2), 'ro') %Inserção no gráfico de cada uma das partículas conforme encontram melhores pessoais
    plot(b(2,1), b(2,2), 'bo')
    plot(b(3,1), b(3,2), 'go')
    plot(b(4,1), b(4,2), 'ko')
    plot(b(5,1), b(5,2), 'co')

    bestred(n) = fb(1);  %Armazenamento das melhores globais e pessoais a cada iteração para futura referência
    bestblue(n) = fb(2);
    bestgreen(n) = fb(3);
    bestblack(n) = fb(4);
    bestcyan(n) = fb(5);
    globalbest(n) = fg;
    
    n = n + 1; %A cada ciclo n incrementa 1 valor para que o ciclo while funcione corretamente
    
end %Fim do ciclo while

plot(g(1),g(2), 'k*'); %Plot da melhor variável global encontrada, ou seja, o valor mínimo encontrado

hold off %Liberta o gráfico que estava atualmente retido

figure %Gráfico à parte para visualizar-mos a evolução do melhor fx global ao longo das iterações, o fg
plot(globalbest);
xlabel('Iterações');
ylabel('fx');
title('Evolução do melhor fx global');

figure %Gráfico à parte para visualizarmos a evolução dos melhores fx pessoais ao longo das iterações, os fb
hold on
plot(bestred, 'r')
plot(bestblue, 'b')
plot(bestgreen, 'g')
plot(bestblack, 'k')
plot(bestcyan, 'c')
xlabel('Iterações');
ylabel('fx');
title('Evolução dos personal best por partícula');
hold off
