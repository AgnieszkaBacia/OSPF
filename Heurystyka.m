% Internet Traffic Engineering by optimizing OSPF Weights
% Notacja jest odwzorowana na podstawie dokumentu.
% Skierowany graf G = (N, A)
%             r1
%           /   \
%          r2 -- r3
%          |     |
%         pc(4)-pc(5)

clear all;

n = 5;                                      %number of nodes
a = 12;                                     %number of Arcs
A = [12 21 13 31 23 32 24 42 35 53 45 54];  %Arcs vector
cap = 100 * ones(1, a);                     %Arcs capacity
d = 2;                                      %Number of demands
omega = [10 10 10 10 10 10 10 10 10 10 10 10]; %Koszt ��cza
hd = [20 20];                               %volume of demands
s = [4 2];                                  %demand source nodes
t = [3 3];                                  %demand target nodes

y = [0 0 0 0 40 0 0 20 0 0 0 0];   %calculate in w CPLEXie

%
f = zeros(n, n, a);
costprim = zeros(1, a);
maxObciazenie = -1; %�eby si� chociaz raz p�tla wykona�a (linijka 32)
maxObciazeniePrim = 0;
index = 1;
q = 1;

while (q < 10 && maxObciazeniePrim > maxObciazenie)
    
%%szukamy najbardziej obciazonego ��cza
for i = 1:a  
    if y(i)/cap(i) >= maxObciazenie && y(i)/cap(i) ~=0;
        maxObciazenie = y(i)/cap(i);    %warto�� maksymalnego obci��enia
        lacza(index) = i;               %wektor przeciazonych ��cz
        index = index + 1;
    end
end

% dla najbardziej obci��onego ��cza ustawiamy metryk�=n, dla reszy ��cz jest
% r�wna 0
costprim(lacza(1)) = q;

Matrix = zeros(n, n);

for i = 1:a
   v = mod(A(i), 10);                       %cyfra jednosci
   w = floor(A(i) / 10);                    %cyfra dziesiatek
   Matrix(w, v) = costprim(i);
end

G = sparse(Matrix);

for i = 1:d
[totalcost{i, 1}, path{i, 1}, pred{i, 1}] = graphshortestpath(G, s(i), t(i));
end


%temp: macierz routingu - je�li zapotrzebowanie k u�ywa �uku j to temp(k, j) = 1 
temp = zeros(d,a);
for k = 1:d
    for i = 1:(length(path{k})-1)
        for j = 1:a
            if A(j) == path{k}(i)*10+path{k}(i+1);
            temp(k, j) = 1;
            end
        end
    end
end

%do f(n,n,a) przypisujemy warto�� kt�ra m�wi o tym ile ruchu przp�ynie z s do t przez kraw�d� a
        
for i = 1:d
    for j = 1:a
       if temp(i, j) == 1;
          f(s(i), t(i), j) = hd(i);
       end
    end
end

%l(a) m�wi o ca�kowitym ruchu p�yn�cym przez ga��� a (load)
l = zeros(1, a);            
for i = 1:d
    for j = 1:a
       if f(s(i), t(i), j) ~= 0;
          l(j) = l(j) + f(s(i), t(i), j);
       end
    end
end


for i = 1:a  
    if y(i)/cap(i) >= maxObciazeniePrim && l(i)/cap(i) ~=0;
        maxObciazeniePrim = l(i)/cap(i);    %warto�� maksymalnego obci��enia po zmianie metryki
 
    end
end
q = q + 1;

end

if maxObciazeniePrim < maxObciazenie
omegaprim = omega + costprim;
end