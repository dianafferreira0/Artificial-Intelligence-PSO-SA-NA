n_epochs = 10000; %Numero de épocas (iterações)
alpha = 0.9; %Fator de aprendizagem

%Vetor soma dos erros quadráticos
SSE = zeros(3, n_epochs);

N=120; %Numero de amostras 
%Amostras de entrada funçao XOR
Data_multi
X = [ X_A;
      X_B;
      X_C;
      ];
  
X=[X,ones(N,1)]; %X_Testes

%X=X_teste;

 %T 120x3
 %Primeiras 40 linhas 1º coluna a 1s
 %Segundas 40 linhas 2º coluna a 1s
 %Utlimas 40 linhas 3º coluna a 1s
 %Inicialização aleatoria dos pesos [-1,1]
 %Saidas da funçao XOR

T= [ones(40,1),zeros(40,2);
    zeros(40,1),ones(40,1),zeros(40,1);
    zeros(40,2),ones(40,1);
    ];
%W1-4X3 W2- 3X5

% W1 = 2*rand(4,3) - 1;
% W2 = 2*rand (3,5) - 1;

W1 = (rand(4,3)-0.5)*2*5
W2 = (rand(3,5)-0.5)*2*5

for epoch = 1:n_epochs
    sum_sq_error=0;
    for k = 1:N
        x = X(k,:)';
        t = T(k,:)';
        
        %Soma da camada de entrada
        g1 = W1*x;
        %Função de ativação sigmoidal
        y1 = sig(g1);
        
        %Adição à saída da camada escondida y1
        %da entrada de bias com +1
        %Resulta em y1_b
        y1_b = [y1
                1];
        
        %Soma da camada de saída
        g2 = W2*y1_b;
        %Função de ativação sigmoidal
        y2 = sig(g2);
        
        %Retropropagação
        %Erro da camada de saída
        e = t - y2;
        %Cálculo do delta da camada de saída
        %Sigmoide
        delta2 = y2.*(1-y2).*e;
        
        equadrado = e.^2;
        
        %Atualização da soma dos erros quadráticos
        sum_sq_error = sum_sq_error + equadrado;
        
        %Erro da camada escondida
        e1 = W2'*delta2;
        %Erro sem o bias
        e1_b = e1(1:4);
        
        %Cálculo do delta da camada de saída
        delta1 = y1.*(1-y1).*e1_b;
        
        %Atualização dos pesos da camada escondida
        dW2 = alpha * delta2 * y1_b'; %Com bias
        W2 = W2 + dW2;
        
        %Atualização dos pesos da camada de entrada
        dW1 = alpha * delta1 * x'; 
        W1 = W1 + dW1;
        
    end
    A = (sum_sq_error)/N;
    SSE(1,epoch) = A(1,1);
    SSE(2,epoch) = A(2,1);
    SSE(3,epoch) = A(3,1);
end

%Teste da rede
for k = 1:N
    
    x = X(k,:)';
    g1 = W1*x;
    
    %Sigmóide
    y1 = sig(g1);
    
    %y1 mais uma entrada de bias
    y1_b = [y1
            1];
    
    g2 = W2*y1_b;
    
    %Saída prevista XOR
    %y_plot(k) = sig(g2);
   
    y_plot(k,:) = sig(g2)';


end
y_plot

It = 1 :1:n_epochs;
plot(It, SSE, 'r-', 'LineWidth', 2)
xlabel('Época')
ylabel('SSE')
title('Função de ativação: Sigmoide')
hold off

figure
hold on
grid on
Data_multi
 plot(X_A(:,1), X_A(:,2), 'r*')
 plot(X_B(:,1), X_B(:,2), 'b*')
 plot(X_C(:,1), X_C(:,2), 'k*')
 plot(X_teste(:,1), X_teste(:,2), 'go')
hold off

figure
hold on
grid on
for j = 1:120
    if j > 0 && j <= 40
    plot(y_plot(j,1), y_plot(j,2), 'r*')
    end
    if j > 40 && j <= 80
    plot(y_plot(j,1), y_plot(j,2), 'b*')
    end
    if j > 80 && j <= 120
    plot(y_plot(j,1), y_plot(j,2), 'k*')
    end
end

hold off

%%%TESTES%%%

% figure
% plot(y_plot)

%TESTAR AS CLASSES
% figure
% hold on
% grid on
% Data_multi
% plot(X_A, 'r*')
% plot(X_B, 'b*')
% plot(X_C, 'k*')
% hold off

%Teste de rede
    
%     saidaSig = sig(g2);
%     a = saidaSig(1,1);
%     b = saidaSig(2,1);
%     c = saidaSig(3,1);
%     y_plot(a); 
%     y_plot(b); 
%     y_plot(c); 