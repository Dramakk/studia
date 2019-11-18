#a
a = [1:100];
#b
b = [1:2:100];
#c
c = [-1:0.01:1] * pi;
#d
d = c(c!=0);
#e
e = sin(a);
e(e<0) = 0;
#A
A = reshape(a,10,10); 
A = A';
#B
B_pom_1 = [1:100];
B_pom_2 = [1:99];
B = zeros(100,100);
ind_1 = sub2ind(size(B),B_pom_1,B_pom_1);
ind_2 = sub2ind(size(B),B_pom_2+1,B_pom_2);
ind_3 = sub2ind(size(B),B_pom_2,B_pom_2+1);
B(ind_1) = B_pom_1;
B(ind_2) = B_pom_2(end:-1:1);
B(ind_3) = B_pom_2(end:-1:1);
#C
C = triu(ones(5,5));
#D
D_pom_1 = cumsum([1:100]);
D_pom_2 = cumprod([1:100]);
D = horzcat(D_pom_1,D_pom_2);
#E
E_pom = [1:10000];
E_pom = reshape(E_pom,100,100);
[R, C] = ndgrid(1:size(E_pom,1), 1:size(E_pom,2));
E = mod(C,R)==0