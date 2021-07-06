
quality = @(x1,x2) -20*exp(-0.2*sqrt(1/2*(x1.^2+x2.^2)))-exp(1/2*(cos(x1)+cos(x2)))+ 20 + exp(1); %Função fornecida 

%Estabelecimento dos limites e design do gráfico%%%
x1 = linspace(-32.768,32.768,100);                %
x2 = linspace(-32.768,32.768,100);                %
[X1,X2] =  meshgrid(x1,x2);                       %
Fx = quality(X1,X2);                              %
contour(X1,X2,Fx,20);                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

T = 90; %Inicialização da variável temperatura (para proceder-mos a uma analogia entre a temperatura de um metal
        %e este parâmetro ajustável do algoritmo, visto que este se baseia numa analogia deste tipo
 
r = (rand(1,2)-0.5)*2*32.768; %Gera uma matriz de 1 por 2 de números aleatórios entre -32.768 e 32.768

fx = quality(r(1), r(2)); %Cálculo do valor da qualidade da função segundo os valores gerados aleatóriamente

hold on %Retém o gráfico atual para que novos plots sejam realizados no mesmo gráfico do inicial

plot(r(1), r(2), 'r*') %Coloca a partícula no gráfico
xlabel('x') %Label do eixo dos x
ylabel('y') %Label do eixo dos y
title('Simulated Annealing') %Título do gráfico

n = 0; %t e n são variáveis inicializadas para que possamos estabelecer o número de iterações do ciclo
t = 1;

evo(t) = 0; %Inicialização da variável evo para verificarmos a evolução da qualidade da função, isto é, do fx
temp(t) = 0; %Inicialização da variável temp para verificarmos a evolução da temepratura, isto é, de T
probabilidade(t) = 0; %Inicialização da variável para verificarmos a evolução da probabilidade, isto é, do prob

while(t <= 1000) %Inicialização do ciclo while para que o algoritmo funcione

    n = 0; %Reinicialização da variável n para que o ciclo while seguinte seja percorrido 5 vezes por cada
           %vez que o ciclo while em que este se insere percorre

    while(n <= 5) %Inicilização de um segundo ciclo while
        
        r_new = r + (rand(1,2)-0.5)*2*1; %Geração de novas variáveis aleatórias na vizinhança das precedentes (r)
        
        r_new = max(min(r_new,32.768),-32.768); %Estabelecimento de um limite na geração das novas variáveis
                                                %para que estas não ultrapassem os limites do gráfico e não saiam                                          
                                                %do domínio deste
        
        fx_new = quality(r_new(1), r_new(2)); %Cálculo da qualidade da nova partícula que irá ser potencialmente gerada 
        
        deltaE = fx_new - fx; %Cálculo da variância da energia ao longo do ciclo

        prob = exp(-deltaE/T); %Cálculo da probabilidade de aceitação da nova partícula, que irá ser menor conforme
                               %o número de iterações
                               
        prob = max(min(prob,1),0); %Para que a probabilidade não ultrapasse 1, pois isso é matematicamente impossível
        
        if deltaE < 0 %Caso a amplitude das energias seja menor que 0, a nova partícula é automaticamente aceite e a
                      %anterior substituída pela nova
                      
            r = r_new; %As coordenadas aleatórias geradas anteriormente são substituídas pelas da nova partícula
            fx = fx_new; %A qualidade, ou fx, da partícula anterior é substituída pela da nova partícula
            plot(r(1), r(2), 'gx') %A nova partícula é colocada no gráfico
            
        elseif rand < prob %Caso a condição anterior não seja verificada, é feita uma nova verificação e garantida uma
                           %segunda oportunidade para que a partícula nova possa ser aceite. Se a probabilidade, 
                           %calculada anteriormente, for maior que um número gerado  aleatóriamente entre 0 e 1, 
                           %esta nova partícula, com fx maior que aanterior, o que não é o inicialmente pretendido, 
                           %é aceite e substitui a anterior
            
            r = r_new; %As coordenadas aleatórias geradas anteriormente são substituídas pelas da nova partícula
            fx = fx_new; %A qualidade, ou fx, da partícula anterior é substituída pela da nova partícula
            plot(r(1), r(2), 'yo') %A nova partícula é colocada no gráfico
           
        end %Fim da constraint if
        
            evo(t) = fx; %No final de cada ciclo, na matrix evo é registada a qualidade da partícula 
            n = n + 1; %A cada ciclo n incrementa 1 valor para que o ciclo while funcione corretamente
         
    end %Fim do ciclo while interno
    
       if t < 101 %Constraint para que só seja armazenada até à iteração 100 uma vez que a temperatura não decai mais
       temp(t) = T; %Registo da temperatura a cada ciclo, para que possa ser observada a sua evolução
       end %Fim do if
       
       probabilidade(t) = prob; % Registo da evolução da probabilidade a cada ciclo, para ser analisada
       
       T = 0.94*T; %Decaimento da temperatura ao longo do ciclo while, com um fator de 0,94
       
       t = t + 1; %A cada ciclo t incrementa 1 valor para que o ciclo while funcione corretamente
       
end %Fim do ciclo while externo

plot(r(1),r(2),'b*') %Partícula melhor, ou seja, com o menor valor de fx econtrada é colocada no gráfico
                     %com uma cor diferente das outras, para que possa ser facilmente identificada como a melhor

hold off %Liberta o gráfico que estava atualmente retido

figure %Figure cria uma nova janela com uma nova figura, no nosso caso um gráfico para que possamos inserir os dados
plot(evo) %Insere os dados da evolução do fx
ylabel('Fx') %Label do eixo dos y
xlabel('Iterações') %Label do eixo dos x-
title('Evolução do fx') %Título do gráfico

figure 
plot(temp) %Insere os dados da evolução da temperatura
ylabel('T') %Label do eixo dos y
xlabel('Iterações') %Label do eixo dos x
title('Evolução da temperatura') %Título do gráfico

figure
plot(probabilidade) %Insere os dados da evolução da probabilidade
ylabel('Probabilidade') %Label do eixo dos y
xlabel('Iterações') %Label do eixo dos x
title('Evolução da probabilidade') %Título do gráfico