%numero de centroides conhecido a priori
n = 4;

%localizacao dos pontos
A = [    
    0.9058    0.9706
    0.1270    0.9572
    0.9134    0.4854
    0.6324    0.8003
    0.0975    0.1419
    0.2785    0.4218
    0.5469    0.9157
    0.9575    0.7922
    0.9649    0.9595
    0.1576    0.6557
    ];

%duas solucoes
nos = 10;
s1 = [1 2 4 4 3 3 2 1 1 2];
s2 = [4 3 1 2 2 1 3 4 4 3];

%calculando centroides
c1 = [];
c2 = [];
for i=1:n
    p = find(s1==i);    
    c1 = [c1; (sum(A(p,1)/size(p,2))) (sum(A(p,2)/size(p,2)))];
    p = find(s2==i);    
    c2 = [c2; (sum(A(p,1)/size(p,2))) (sum(A(p,2)/size(p,2)))];
end

%vetor com as distancias
D = [];

%vetor para normalizar
V = [];

%centroides normalizados
Nc1 = [];
Nc2 = [];

%auxiliar
N1 = [-1 -1 -1 -1];
N2 = [-1 -1 -1 -1];

%primeiro passo da normalização
for i=1:4
    for j=1:4
        D(i,j) = sqrt((c1(i,1) - c2(j,1))^2 + (c1(i,2) - c2(j,2))^2);
        if size(V,1) == 0
            V = [i j D(i,j)];
        else
            k = 1;
            while V(k,3) <= D(i,j)
                k = k+1;
                if k > size(V,1)
                    break
                end
            end
                                    
            if k <= size(V,1)
                V = [V(1:k-1,:,:); i j D(i,j); V(k:size(V,1),:,:)]; 
            else
                V = [V; i j D(i,j)];
            end
        end
    end
end

%solucao transformada
ns1 = zeros(1,nos);
ns2 = zeros(1,nos);

%segundo passo, dar rótuos ao grupos baseado nas distâncias entre centroides
grupo = 1;
for i=1:n^2
    if N1(V(i,1))==-1 && N2(V(i,2))==-1
        %ajustar o vetor com os centroides
        Nc1 = [Nc1; c1(V(i,1),:)];
        Nc2 = [Nc2; c2(V(i,2),:)];
        N1(V(i,1))=0;
        N2(V(i,2))=0;
        
        %ajustar solucao
        ns1(find(s1 == V(i,1))) = grupo;
        ns2(find(s2 == V(i,2))) = grupo;
        grupo = grupo + 1;
    end
end

figure(1)
%cenário antes e depois da normalização 

subplot(2,2,1)
title('s_i before normalization','FontSize',14)
hold on
cores = jet(n);
cores = cores(randperm(n),:); 

for i=1:nos              
    plot(A(i,1), A(i,2),'*','Color',cores(s1(i),:));      
    plot(c1(s1(i),1),c1(s1(i),2),'^');
    plot([A(i,1) c1(s1(i),1)],[A(i,2) c1(s1(i),2)],'-');
    text(A(i,1), A(i,2),['  ' num2str(s1(i))]);        
end 
hold off
set(gca,'xtick',[],'ytick',[])

subplot(2,2,2)
title('s_j before normalization','FontSize',14)
hold on

for i=1:nos          
    plot(A(i,1), A(i,2),'*','Color',cores(s2(i),:));                
    plot(c2(s2(i),1),c2(s2(i),2),'^');
    plot([A(i,1) c2(s2(i),1)],[A(i,2) c2(s2(i),2)],'-');    
    text(A(i,1), A(i,2),['  ' num2str(s2(i))]);        
end 
hold off
set(gca,'xtick',[],'ytick',[])

subplot(2,2,3)
title('s_i after normalization','FontSize',14)
hold on

for i=1:nos          
    plot(A(i,1), A(i,2),'*','Color',cores(ns1(i),:));   
    plot(Nc1(ns1(i),1),Nc1(ns1(i),2),'^');
    plot([A(i,1) Nc1(ns1(i),1)],[A(i,2) Nc1(ns1(i),2)],'-');    
    text(A(i,1), A(i,2),['  ' num2str(ns1(i))]);        
end 
hold off
set(gca,'xtick',[],'ytick',[])

subplot(2,2,4)
title('s_f after normalization','FontSize',14)
hold on

for i=1:nos          
    plot(A(i,1), A(i,2),'*','Color',cores(ns2(i),:));                
    plot(Nc2(ns2(i),1),Nc2(ns2(i),2),'^');
    plot([A(i,1) Nc2(ns2(i),1)],[A(i,2) Nc2(ns2(i),2)],'-');    
    text(A(i,1), A(i,2),['  ' num2str(ns2(i))]);        
end 
hold off
set(gca,'xtick',[],'ytick',[])